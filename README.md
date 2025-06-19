# SSL.com CodeSignTool Mirror

Automatically mirrors the latest **CodeSignTool** release published by [SSL.com](https://www.ssl.com/). Every day a GitHub Actions workflow checks the upstream download page, extracts the current version from the `Content‑Disposition` header, and—if it is newer than the most recent tag—creates a new GitHub Release in this repository and uploads the ZIP.

> **TL;DR** – You always have a clean, version‑tagged copy of the tool right here on GitHub, without duplicate releases or wasted workflow minutes.

---

## How it works

| Step                | File                                        | What it does                                                              |
| ------------------- | ------------------------------------------- | ------------------------------------------------------------------------- |
| **Header probe**    | `scripts/extract_header.sh`                 | Curls the upstream URL *headers only*; pulls out the filename and SemVer. |
| **Duplicate guard** | `scripts/check_release.sh`                  | Exits early if a release tag like `v1.2.3` already exists.                |
| **Workflow**        | `.github/workflows/mirror_codesigntool.yml` | Ties everything together—scheduled run, download, tag & release.          |

### Tag & release format

Releases are tagged `v<major>.<minor>.<patch>` (e.g. `v1.3.2`) and titled `CodeSignTool v1.3.2`. Feel free to edit the workflow if you prefer a different naming scheme (e.g. `codesign‑1.3.2`).

---

## Development

```bash
# Run header extraction locally
bash scripts/extract_header.sh "https://www.ssl.com/download/codesigntool-for-linux-and-macos/"
# → prints filename and version to STDOUT

# Simulate duplicate‑release guard
bash scripts/check_release.sh 1.3.2
```

The scripts are POSIX‑compliant and require only `bash`, `curl`, `sed`, and `grep`.

---

## License

This mirror’s workflow and helper scripts are distributed under the MIT License.

Upstream software: To the best of our knowledge, SSL.com does not publish any license terms for the CodeSignTool ZIP downloaded from their site. This repository re‑publishes that binary verbatim solely as an automated convenience mirror.

No rights to modify, redistribute, or use the upstream software beyond those expressly granted by SSL.com are implied or provided here.

The maintainers of this mirror accept no responsibility or liability for any direct or consequential damages arising from the use of the upstream CodeSignTool.

If you require definitive licensing terms, you must obtain them directly from SSL.com.

---

## Disclaimer

This project is **not** affiliated with or endorsed by SSL.com. It exists solely as an automated, unofficial convenience mirror. Use at your own risk.
