/**
 * PR Review Agent
 *
 * Triggered by GitHub Actions on pull_request events.
 * Reads the PR diff, sends it to a Cursor cloud agent for review against
 * the project's AGENTS.md standards, and posts the result as a PR comment.
 */

import { Agent, CursorAgentError } from "@cursor/sdk";
import { execSync } from "child_process";
import { readFileSync, writeFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = join(__dirname, "..");

const prNumber = process.env.PR_NUMBER;
const baseSha = process.env.BASE_SHA;
const headSha = process.env.HEAD_SHA;
const repo = process.env.GITHUB_REPOSITORY; // srdjan86/pulse_coaching_app

if (!prNumber || !baseSha || !headSha || !repo) {
  console.error(
    "Missing required env vars: PR_NUMBER, BASE_SHA, HEAD_SHA, GITHUB_REPOSITORY"
  );
  process.exit(1);
}

if (!process.env.CURSOR_API_KEY) {
  console.error("Missing CURSOR_API_KEY");
  process.exit(1);
}

// Get the diff for lib/ and test/ only (ignore generated, config, assets)
let diff;
try {
  diff = execSync(
    `git diff ${baseSha}..${headSha} -- lib/ test/ .github/ scripts/`,
    { cwd: repoRoot, maxBuffer: 2 * 1024 * 1024 }
  ).toString();
} catch {
  diff = "(could not compute diff)";
}

const MAX_DIFF_CHARS = 24_000;
if (diff.length > MAX_DIFF_CHARS) {
  diff =
    diff.slice(0, MAX_DIFF_CHARS) +
    `\n\n... diff truncated at ${MAX_DIFF_CHARS} chars. Review the full diff on GitHub.`;
}

// Read AGENTS.md so the agent has the full project standards
let agentsMd = "";
try {
  agentsMd = readFileSync(join(repoRoot, "AGENTS.md"), "utf8");
} catch {
  agentsMd = "(AGENTS.md not found)";
}

const prompt = `
You are a senior Flutter/Dart engineer reviewing a pull request for the pulse_coaching_app project.

## Project standards (AGENTS.md)
${agentsMd}

## PR diff (lib/, test/, .github/ only)
\`\`\`diff
${diff}
\`\`\`

## Your task
Review the diff against the project standards above. Be direct and concise.

Check each area and report findings. **Skip any area where there are no issues.**

### Areas to check
1. **Architecture** — Feature-first layout? Business logic out of UI widgets? Repository/service pattern used correctly?
2. **State management** — BLoC for interactive state, MVVM/ChangeNotifier for simpler flows?
3. **Dependency injection** — New services registered in service_locator.dart? Injected via constructor for testability?
4. **Tests** — New files have tests? Tests verify behaviour (not just implementation details)? Edge cases covered?
5. **Localization** — All user-facing strings in ARB files? No hardcoded strings in widgets?
6. **Naming and conventions** — Consistent with existing codebase?
7. **Scope** — PR focused on one concern? No unrelated changes?
8. **Risks / edge cases** — Anything that could break at runtime?

### Output format
Start with a one-line verdict:
- ✅ LGTM
- ⚠️ LGTM with minor notes
- ❌ Changes requested

Then list only the areas that have actual findings, as short bullet points.
End with a one-sentence summary.
`.trim();

console.log(`Running Cursor review agent for PR #${prNumber}...`);

let reviewText;
try {
  const result = await Agent.prompt(prompt, {
    apiKey: process.env.CURSOR_API_KEY,
    model: { id: "composer-2.5" },
    local: { cwd: repoRoot },
  });

  if (result.status !== "finished") {
    console.error(`Agent finished with status: ${result.status}`);
    process.exit(2);
  }

  reviewText = result.result ?? "(no output)";
} catch (err) {
  if (err instanceof CursorAgentError) {
    console.error(`Agent startup failed: ${err.message} (retryable=${err.isRetryable})`);
    process.exit(1);
  }
  throw err;
}

const body = `## AI Code Review

${reviewText}

---
*Reviewed by [Cursor Review Agent](https://cursor.com) · [View run logs](https://github.com/${repo}/actions)*`;

const bodyFile = "/tmp/pr_review_body.md";
writeFileSync(bodyFile, body, "utf8");

try {
  execSync(`gh pr comment ${prNumber} --repo ${repo} --body-file ${bodyFile}`, {
    stdio: "inherit",
  });
  console.log(`Review posted to PR #${prNumber}.`);
} catch {
  console.error("Failed to post PR comment. Check GH_TOKEN permissions.");
  process.exit(1);
}
