# Project Notes

## Versioning

**Every software update to the application MUST increment the version number.**

The version lives in `pubspec.yaml` under `version:` (format: `<major>.<minor>.<patch>+<build>`, currently `1.0.0+1`).

On each change that ships:
- Bump the version in `pubspec.yaml` — increment the build number (the part after `+`) at minimum, and the semantic version (`major.minor.patch`) as appropriate for the size of the change.
- Do this as part of the same change/commit, so no update goes out without a version bump.
