/**
 * Release Notes Agent
 *
 * Triggered by the release workflow. Reads the git log since the previous tag
 * (or the full history for the first release), and generates human-readable
 * release notes via a Cursor SDK agent.
 *
 * Outputs the notes to /tmp/release_notes.md for the workflow to consume.
 */

import { Agent, CursorAgentError } from "@cursor/sdk";
import { execSync } from "child_process";
import { readFileSync, writeFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = join(__dirname, "..");

const version = process.env.RELEASE_VERSION;
const repo = process.env.GITHUB_REPOSITORY;

if (!version || !repo) {
  console.error("Missing required env vars: RELEASE_VERSION, GITHUB_REPOSITORY");
  process.exit(1);
}

if (!process.env.CURSOR_API_KEY) {
  console.error("Missing CURSOR_API_KEY");
  process.exit(1);
}

// Find the previous tag (empty string if this is the first release)
let previousTag = "";
try {
  previousTag = execSync("git describe --tags --abbrev=0", {
    cwd: repoRoot,
  })
    .toString()
    .trim();
} catch {
  previousTag = "";
}

// Get commits since the previous tag (or all commits for first release)
const range = previousTag ? `${previousTag}..HEAD` : "HEAD";
const gitLog = execSync(
  `git log ${range} --pretty=format:"%h %s" --no-merges`,
  { cwd: repoRoot }
).toString();

// Read CHANGELOG.md for style reference
let changelog = "";
try {
  changelog = readFileSync(join(repoRoot, "CHANGELOG.md"), "utf8").slice(0, 2_000);
} catch {
  changelog = "";
}

const isFirstRelease = !previousTag;

const prompt = `
You are writing release notes for a Flutter app called Pulse.

## Context
Version: ${version}
Previous release: ${isFirstRelease ? "none (this is the first release)" : previousTag}
Repository: https://github.com/${repo}

## CHANGELOG.md (style reference)
${changelog}

## Commits included in this release
${gitLog || "(no commits found — use CHANGELOG.md content for the first release)"}

## Your task
Write concise, user-facing release notes for v${version}.

Rules:
- Group changes under Keep a Changelog headings: ### Added, ### Changed, ### Fixed, ### Removed (omit empty groups)
- Each bullet should describe the user or developer benefit, not the implementation detail
- Skip pure chore/CI/dependency commits unless they affect developer experience significantly
- Write in plain English; no jargon
- Keep the total under 400 words
- Do not include a version header — the workflow adds that

Output only the release notes content, no preamble.
`.trim();

console.log(
  `Generating release notes for v${version} (since ${previousTag || "beginning"})...`
);

let notes;
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

  notes = result.result ?? "(no output)";
} catch (err) {
  if (err instanceof CursorAgentError) {
    console.error(
      `Agent startup failed: ${err.message} (retryable=${err.isRetryable})`
    );
    process.exit(1);
  }
  throw err;
}

// Write just the bullet content — the workflow adds the section header
// for CHANGELOG; GitHub Release uses the version as its title.
writeFileSync("/tmp/release_notes.md", notes, "utf8");
console.log("Release notes written to /tmp/release_notes.md");
console.log("\n---\n" + notes);
