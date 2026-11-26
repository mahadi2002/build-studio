#!/usr/bin/env bash
# Lint the build-studio skill folder. Exit 1 on any FAIL.
# Usage: scripts/lint.sh [--allow-missing-roles]
#   --allow-missing-roles  missing references/roles/*.md links become WARN (while role files are still being written)
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ALLOW_MISSING_ROLES=0
[ "${1:-}" = "--allow-missing-roles" ] && ALLOW_MISSING_ROLES=1
fails=0; warns=0
fail() { echo "FAIL  $*"; fails=$((fails+1)); }
warn() { echo "WARN  $*"; warns=$((warns+1)); }

SKILL="$ROOT/SKILL.md"
[ -f "$SKILL" ] || { fail "SKILL.md missing"; exit 1; }

# 1. Line limits
n=$(wc -l < "$SKILL"); [ "$n" -le 300 ] || fail "SKILL.md has $n lines (max 300)"
for f in "$ROOT"/templates/*.md; do
  [ -f "$f" ] || continue
  n=$(wc -l < "$f"); [ "$n" -le 60 ] || warn "${f#$ROOT/} has $n lines (templates should stay short, <=60)"
done

# 2. Role files: tier line, sections, size
T12=("Triggers" "Responsibilities" "Role-specific rules" "Default tool options" "Checklist" "Common mistakes" "Definition of done" "Per-stack notes")
T3=("Triggers" "Scope check" "Role-specific rules" "Definition of done")
for f in "$ROOT"/references/roles/*.md; do
  [ -f "$f" ] || continue
  rel="${f#$ROOT/}"; base="$(basename "$f")"
  [ "$base" = "_template.md" ] && continue
  tier=$(grep -m1 -oE '^tier: [123]' "$f" | grep -oE '[123]$')
  if [ -z "$tier" ]; then fail "$rel has no 'tier: N' line"; continue; fi
  n=$(wc -l < "$f")
  case "$tier" in
    1) lo=60;  hi=120; secs=("${T12[@]}") ;;
    2) lo=25;  hi=40;  secs=("${T12[@]}") ;;
    3) lo=15;  hi=25;  secs=("${T3[@]}") ;;
  esac
  { [ "$n" -ge "$lo" ] && [ "$n" -le "$hi" ]; } || fail "$rel tier $tier has $n lines (want $lo-$hi)"
  for s in "${secs[@]}"; do
    grep -qE "^##+ $s\b" "$f" || fail "$rel missing section '## $s'"
  done
done

# 3. Banned words and em-dash chains (all markdown in the skill)
BANNED='\b(delve|delves|delving|robust|seamless|seamlessly|leverage|leverages|leveraging|comprehensive|utilize|utilizes|utilizing|holistic|streamline|streamlines|moreover|furthermore)\b|it.s important to note|in conclusion'
while IFS= read -r hit; do fail "banned word: $hit"; done < <(grep -rniE "$BANNED" --include='*.md' "$ROOT" | sed "s#^$ROOT/##")
while IFS= read -r hit; do fail "em-dash chain: $hit"; done < <(grep -rnE '—.*—' --include='*.md' "$ROOT" | sed "s#^$ROOT/##" | cut -c1-120)

# 4. Relative links resolve
while IFS=: read -r file _ match; do
  t="${match#](}"; t="${t%)}"; t="${t%%#*}"
  [ -z "$t" ] && continue
  case "$t" in http*|mailto:*) continue ;; esac
  [ -e "$(dirname "$file")/$t" ] && continue
  rel="${file#$ROOT/}"
  if [ "$ALLOW_MISSING_ROLES" = 1 ] && [[ "$t" == *roles/*.md ]]; then
    warn "pending role file: $rel -> $t"
  else
    fail "broken link: $rel -> $t"
  fi
done < <(grep -rnoE '\]\([^) ]+\)' --include='*.md' "$ROOT")

# 4b. Backticked skill-relative paths in SKILL.md exist (templates/x.md, references/..., scripts/...)
for p in $(grep -oE '`(templates|references|scripts)/[^`]+`' "$SKILL" | tr -d '`' | sort -u); do
  [ -e "$ROOT/$p" ] && continue
  [ "$p" = "references/owner-profile.md" ] && continue   # private, optional by design
  if [ "$ALLOW_MISSING_ROLES" = 1 ] && [[ "$p" == references/roles/*.md ]]; then warn "pending role file: SKILL.md -> $p"
  else fail "path named in SKILL.md does not exist: $p"; fi
done

# 5. Routed skill names exist
known="$(mktemp)"
{
  for d in "$HOME"/.claude/skills/*/; do [ -f "$d/SKILL.md" ] && basename "$d"; done
  for pj in $(find "${APPDATA:-/nonexistent}/Claude/rpm" "$HOME/.claude/plugins/cache" -path '*/.claude-plugin/plugin.json' 2>/dev/null); do
    pdir="$(dirname "$(dirname "$pj")")"
    pname="$(grep -oE '"name"[[:space:]]*:[[:space:]]*"[^"]+"' "$pj" | head -1 | sed -E 's/.*"([^"]+)"$/\1/')"
    [ -d "$pdir/skills" ] || continue
    for sd in "$pdir"/skills/*/; do [ -f "$sd/SKILL.md" ] && echo "$pname:$(basename "$sd")"; done
  done
  # Built into the session (no files on disk); checked against the session skill list 2026-11-26.
  printf '%s\n' claude-api find-skills anthropic-skills:docx anthropic-skills:xlsx anthropic-skills:pptx anthropic-skills:pdf \
    anthropic-skills:mcp-builder anthropic-skills:web-artifacts-builder anthropic-skills:theme-factory anthropic-skills:skill-creator
} | sort -u > "$known"
routes=$(awk '/^## .*Routes/{f=1;next} /^## /{f=0} f && /^\|/' "$SKILL" | awk -F'|' 'NR>2{print $3}' | grep -oE '`[^`]+`' | tr -d '`' | sort -u)
[ -n "$routes" ] || fail "no routes found under a '## ... Routes' heading"
if [ "${LINT_SKIP_ROUTES:-0}" = 1 ]; then
  echo "info  route install check skipped (LINT_SKIP_ROUTES=1)"
else
  for r in $routes; do grep -qxF "$r" "$known" || fail "route skill not installed: $r"; done
fi
rm -f "$known"

# 6. Safety sentinels: v1 safety rules must stay in SKILL.md
SENTINELS=(
  "Evidence before claims"
  "never push, migrate, or deploy without my explicit yes"
  "no fix before the root cause"
  "G1" "G2" "G3" "G4"
  "written permission"
  "Do not weaken"
)
for s in "${SENTINELS[@]}"; do grep -qF "$s" "$SKILL" || fail "SKILL.md lost safety sentinel: '$s'"; done

echo "---"
echo "lint: $fails fail, $warns warn"
[ "$fails" -eq 0 ]
