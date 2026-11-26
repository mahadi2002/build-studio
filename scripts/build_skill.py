"""Package skills/build-studio as a .skill file (a zip) for claude.ai uploads.

Usage:
  python scripts/build_skill.py                      -> dist/build-studio.skill (public)
  python scripts/build_skill.py --profile FILE       -> dist/build-studio-owner.skill
                                                        (adds FILE as references/owner-profile.md; keep it private)
"""
import argparse
import pathlib
import zipfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
SKILL = ROOT / "skills" / "build-studio"


def build(out: pathlib.Path, profile: pathlib.Path | None) -> None:
    out.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
        for f in sorted(SKILL.rglob("*")):
            if f.is_file() and f.name != "owner-profile.md":
                z.write(f, pathlib.Path("build-studio") / f.relative_to(SKILL))
        # Apache-2.0 asks that copies carry the license and notice.
        for legal in ("LICENSE", "NOTICE"):
            z.write(ROOT / legal, f"build-studio/{legal}")
        if profile:
            z.write(profile, "build-studio/references/owner-profile.md")
    with zipfile.ZipFile(out) as z:
        names = z.namelist()
    assert "build-studio/SKILL.md" in names, "SKILL.md missing from package"
    assert "build-studio/LICENSE" in names, "LICENSE missing from package"
    print(f"{out} ({len(names)} files, {out.stat().st_size} bytes)")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--profile", type=pathlib.Path)
    args = ap.parse_args()
    name = "build-studio-owner.skill" if args.profile else "build-studio.skill"
    build(ROOT / "dist" / name, args.profile)
