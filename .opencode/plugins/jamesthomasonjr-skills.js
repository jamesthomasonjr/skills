/**
 * jamesthomasonjr-skills plugin for OpenCode.
 *
 * Dual-compatible with OpenCode V1 and V2. Registers the promoted skill
 * buckets (skills/engineering, skills/productivity); personal/ and
 * in-progress/ stay out. No bootstrap injection: these skills are
 * agent-agnostic and carry no ambient "using skills" preamble.
 *
 * V1: named export `SkillsPlugin`; the config hook appends each bucket
 *     directory to config.skills.paths.
 * V2: default export `{ id, server, setup }`; setup() registers every
 *     skill via ctx.skill.transform().
 *
 * No external dependencies.
 */

import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const PROMOTED_BUCKETS = ['engineering', 'productivity'];
const skillsRoot = path.resolve(__dirname, '../../skills');

const bucketDirs = () =>
  PROMOTED_BUCKETS.map((b) => path.join(skillsRoot, b)).filter((d) => fs.existsSync(d));

// Minimal frontmatter parser: plain `key: value`, quoted values, block
// scalars (`>`, `|`) and CRLF. Only name/description/disable-model-invocation
// are consumed here.
const extractAndStripFrontmatter = (content) => {
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
  if (!match) return { frontmatter: {}, content };

  const frontmatter = {};
  let lastKey = null;
  for (const rawLine of match[1].split('\n')) {
    const line = rawLine.replace(/\r$/, '');
    const colonIdx = line.indexOf(':');
    if (colonIdx > 0 && !/^\s/.test(line)) {
      const key = line.slice(0, colonIdx).trim();
      const value = line.slice(colonIdx + 1).trim();
      frontmatter[key] = /^(>[+-]?|\|[+-]?)$/.test(value) ? '' : value;
      lastKey = key;
    } else if (lastKey !== null && line.trim() !== '') {
      frontmatter[lastKey] = `${frontmatter[lastKey]} ${line.trim()}`.trim();
    }
  }
  for (const key of Object.keys(frontmatter)) {
    frontmatter[key] = frontmatter[key].replace(/^(["'])([\s\S]*)\1$/, '$2');
  }
  return { frontmatter, content: match[2] };
};

export const SkillsPlugin = async () => ({
  config: async (config) => {
    // V2: skills is a flat array; setup() handles registration.
    if (Array.isArray(config.skills)) return;

    config.skills = config.skills || {};
    config.skills.paths = config.skills.paths || [];
    for (const dir of bucketDirs()) {
      if (!config.skills.paths.includes(dir)) config.skills.paths.push(dir);
    }
  },
});

async function setup(ctx) {
  // V1 also calls default.setup with a ctx lacking the skill domain.
  if (!ctx || !ctx.skill || typeof ctx.skill.transform !== 'function') return;

  try {
    const skills = [];
    for (const bucketDir of bucketDirs()) {
      for (const entry of fs.readdirSync(bucketDir, { withFileTypes: true })) {
        if (!entry.isDirectory() || entry.name.startsWith('.')) continue;
        const skillPath = path.join(bucketDir, entry.name, 'SKILL.md');
        if (!fs.existsSync(skillPath)) continue;
        const { frontmatter, content } = extractAndStripFrontmatter(fs.readFileSync(skillPath, 'utf8'));
        skills.push({
          id: entry.name,
          name: frontmatter.name || entry.name,
          ...(frontmatter.description ? { description: frontmatter.description } : {}),
          ...(frontmatter['disable-model-invocation'] === 'true' ? { autoinvoke: false } : {}),
          path: skillPath,
          content,
        });
      }
    }
    await ctx.skill.transform((draft) => {
      // draft.add() throws on schema mismatch, and an escaping throw
      // hard-disables the plugin; contain failures per skill.
      for (const skill of skills) {
        try {
          draft.add(skill);
        } catch (err) {
          console.error(`[jamesthomasonjr-skills] skill "${skill.id}" rejected by host, skipping:`, err);
        }
      }
    });
  } catch (err) {
    console.error('[jamesthomasonjr-skills] skill registration failed:', err);
  }
}

export default {
  id: 'jamesthomasonjr-skills',
  server: SkillsPlugin,
  setup,
};
