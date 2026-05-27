#!/usr/bin/env python3
"""Add iOS flavor build configurations and Xcode schemes to Runner.xcodeproj."""

from __future__ import annotations

import pathlib
import re
import uuid

ROOT = pathlib.Path(__file__).resolve().parents[1]
PBXPROJ = ROOT / "ios/Runner.xcodeproj/project.pbxproj"
SCHEMES_DIR = ROOT / "ios/Runner.xcodeproj/xcshareddata/xcschemes"

FLAVORS = ("dev", "staging", "prod")
MODES = (
    ("Debug", "9740EEB21CF90195004384FC", "97C147031CF9000F007C117D", "97C147061CF9000F007C117D", "331C8088294A63A400263BE5"),
    ("Release", "7AFA3C8E1D35360C0083082E", "97C147041CF9000F007C117D", "97C147071CF9000F007C117D", "331C8089294A63A400263BE5"),
    ("Profile", "7AFA3C8E1D35360C0083082E", "249021D3217E4FDB00AE95B9", "249021D4217E4FDB00AE95B9", "331C808A294A63A400263BE5"),
)


def gen_id() -> str:
    return uuid.uuid4().hex[:24].upper()


def main() -> None:
    text = PBXPROJ.read_text()

    file_refs: dict[str, str] = {}
    proj_configs: dict[str, str] = {}
    runner_configs: dict[str, str] = {}
    test_configs: dict[str, str] = {}

    file_ref_section = []
    build_config_section = []

    for flavor in FLAVORS:
        for mode, _, proj_template, runner_template, test_template in MODES:
            name = f"{mode}-{flavor}"
            xcconfig_name = f"{mode}-{flavor}.xcconfig"
            xcconfig_path = f"Flutter/{xcconfig_name}"

            file_id = gen_id()
            file_refs[name] = file_id
            file_ref_section.append(
                f"\t\t{file_id} /* {xcconfig_name} */ = {{isa = PBXFileReference; lastKnownFileType = text.xcconfig; name = {xcconfig_name}; path = {xcconfig_path}; sourceTree = \"<group>\"; }};"
            )

            proj_id = gen_id()
            runner_id = gen_id()
            test_id = gen_id()
            proj_configs[name] = proj_id
            runner_configs[name] = runner_id
            test_configs[name] = test_id

            # Project-level config: clone from template block by name
            proj_block = extract_block(text, proj_template)
            proj_block = replace_name(proj_block, proj_template_name(text, proj_template), name)
            build_config_section.append(wrap_config(proj_id, proj_block))

            runner_block = extract_block(text, runner_template)
            runner_block = replace_name(runner_block, runner_template_name(text, runner_template), name)
            runner_block = set_base_config(runner_block, file_id, xcconfig_name)
            runner_block = remove_bundle_id(runner_block)
            build_config_section.append(wrap_config(runner_id, runner_block))

            test_block = extract_block(text, test_template)
            test_block = replace_name(test_block, runner_template_name(text, test_template), name)
            build_config_section.append(wrap_config(test_id, test_block))

    # Insert file refs before /* End PBXFileReference section */
    text = text.replace(
        "/* End PBXFileReference section */",
        "\n".join(file_ref_section) + "\n/* End PBXFileReference section */",
    )

    # Add xcconfig files to Flutter group
    flutter_children = "\n".join(
        f"\t\t\t\t{file_refs[f'{mode}-{flavor}']} /* {mode}-{flavor}.xcconfig */,"
        for flavor in FLAVORS
        for mode, _, _, _, _ in MODES
    )
    text = text.replace(
        "\t\t\t9740EEB31CF90195004384FC /* Generated.xcconfig */,",
        "\t\t\t9740EEB31CF90195004384FC /* Generated.xcconfig */,\n" + flutter_children,
    )

    # Insert build configurations before /* End XCBuildConfiguration section */
    text = text.replace(
        "/* End XCBuildConfiguration section */",
        "\n".join(build_config_section) + "\n/* End XCBuildConfiguration section */",
    )

    # Extend configuration lists
    proj_list = "\n".join(
        f"\t\t\t\t{proj_configs[f'{mode}-{flavor}']} /* {mode}-{flavor} */,"
        for flavor in FLAVORS
        for mode, _, _, _, _ in MODES
    )
    text = text.replace(
        "\t\t\t\t249021D3217E4FDB00AE95B9 /* Profile */,\n\t\t\t);",
        "\t\t\t\t249021D3217E4FDB00AE95B9 /* Profile */,\n" + proj_list + "\n\t\t\t);",
        1,
    )

    runner_list = "\n".join(
        f"\t\t\t\t{runner_configs[f'{mode}-{flavor}']} /* {mode}-{flavor} */,"
        for flavor in FLAVORS
        for mode, _, _, _, _ in MODES
    )
    text = text.replace(
        "\t\t\t\t249021D4217E4FDB00AE95B9 /* Profile */,\n\t\t\t);",
        "\t\t\t\t249021D4217E4FDB00AE95B9 /* Profile */,\n" + runner_list + "\n\t\t\t);",
        1,
    )

    test_list = "\n".join(
        f"\t\t\t\t{test_configs[f'{mode}-{flavor}']} /* {mode}-{flavor} */,"
        for flavor in FLAVORS
        for mode, _, _, _, _ in MODES
    )
    text = text.replace(
        "\t\t\t\t331C808A294A63A400263BE5 /* Profile */,\n\t\t\t);",
        "\t\t\t\t331C808A294A63A400263BE5 /* Profile */,\n" + test_list + "\n\t\t\t);",
        1,
    )

    PBXPROJ.write_text(text)

    for flavor in FLAVORS:
        write_scheme(flavor)

    print("Patched project.pbxproj and created flavor schemes.")


def extract_block(text: str, config_id: str) -> str:
    pattern = rf"(\t\t{config_id} /\* .*? \*/ = {{.*?^\t\t}};)"
    match = re.search(pattern, text, re.DOTALL | re.MULTILINE)
    if not match:
        raise ValueError(f"Could not extract XCBuildConfiguration {config_id}")
    return match.group(1)


def proj_template_name(text: str, config_id: str) -> str:
    block = extract_block(text, config_id)
    return block.split("name = ")[1].split(";")[0].strip()


def runner_template_name(text: str, config_id: str) -> str:
    return proj_template_name(text, config_id)


def replace_name(block: str, old: str, new: str) -> str:
    return block.replace(f"name = {old};", f"name = {new};")


def set_base_config(block: str, file_id: str, xcconfig_name: str) -> str:
    if "baseConfigurationReference" in block:
        import re

        return re.sub(
            r"baseConfigurationReference = [A-F0-9]+ /\* .*? \*/;",
            f"baseConfigurationReference = {file_id} /* {xcconfig_name} */;",
            block,
        )
    insert = f"\t\t\tbaseConfigurationReference = {file_id} /* {xcconfig_name} */;\n"
    return block.replace("\t\t\tbuildSettings = {", insert + "\t\t\tbuildSettings = {")


def remove_bundle_id(block: str) -> str:
    lines = []
    for line in block.splitlines():
        if "PRODUCT_BUNDLE_IDENTIFIER" in line:
            continue
        lines.append(line)
    return "\n".join(lines)


def wrap_config(config_id: str, block: str) -> str:
    inner = block.split("= ", 1)[1]
    return f"\t\t{config_id} /* flavor */ = {inner}"


def write_scheme(flavor: str) -> None:
    scheme_path = SCHEMES_DIR / f"{flavor}.xcscheme"
    scheme_path.write_text(
        SCHEME_TEMPLATE.format(
            flavor=flavor,
            debug=f"Debug-{flavor}",
            profile=f"Profile-{flavor}",
            release=f"Release-{flavor}",
        )
    )


SCHEME_TEMPLATE = """<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1510"
   version = "1.3">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "97C146ED1CF9000F007C117D"
               BuildableName = "Runner.app"
               BlueprintName = "Runner"
               ReferencedContainer = "container:Runner.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "{debug}"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      customLLDBInitFile = "$(SRCROOT)/Flutter/ephemeral/flutter_lldbinit"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <MacroExpansion>
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </MacroExpansion>
      <Testables>
         <TestableReference
            skipped = "NO"
            parallelizable = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "331C8080294A63A400263BE5"
               BuildableName = "RunnerTests.xctest"
               BlueprintName = "RunnerTests"
               ReferencedContainer = "container:Runner.xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "{debug}"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      customLLDBInitFile = "$(SRCROOT)/Flutter/ephemeral/flutter_lldbinit"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "{profile}"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "{debug}">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "{release}"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""


if __name__ == "__main__":
    main()
