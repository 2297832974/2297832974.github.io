# Project Baseline

## Current Truth

- Project directory: `token-buy`
- Flutter package name: `token_buy`
- Created on: `2026-05-13`
- Enabled platforms: `windows`, `ios`, `macos`
- Excluded platforms by current scaffold: `android`, `linux`, `web`
- Runtime asset root: `assets/`
- Asset subdirectories: `assets/images/`, `assets/videos/`
- Asset workflow doc: `docs/assets.md`

## Creation Command

```bash
flutter --no-version-check create --offline --project-name token_buy --platforms=windows,ios,macos /Users/sunqin/study/language/dart/code/token-buy
```

## Notes

- The directory name uses `token-buy` to match the requested project name.
- The internal Flutter package name uses `token_buy` because Flutter package identifiers must use underscores instead of hyphens.
- Project runtime assets are organized under relative workspace paths to avoid machine-specific absolute path coupling.

## Quick Start

```bash
cd /Users/sunqin/study/language/dart/code/token-buy
flutter run
```
