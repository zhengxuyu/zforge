#!/usr/bin/env node

import { execSync } from "child_process";
import { dirname, join, resolve } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ZFORGE_DIR = resolve(__dirname, "..");
const setupScript = join(ZFORGE_DIR, "setup");

console.log("zforge — installing skills for Claude Code\n");

try {
  execSync(`bash "${setupScript}"`, { stdio: "inherit", cwd: ZFORGE_DIR });
} catch (e) {
  process.exit(1);
}
