# Meshy To STL

A Chrome extension that finds `.meshy` model files on the current tab and converts them to STL, OBJ, or GLB, entirely in your browser.

## Quick start

1. Download the decoder files (one-time, see [Install](#install)).
2. Load the `chrome-extension` folder in `chrome://extensions`.
3. Open the page with the model, click the extension icon, pick a file and a format, then click **Download**.

## Choose a format

| Format | Use it for | Keeps |
|--------|-----------|-------|
| GLB | Blender and other 3D editors | The decoded model as-is, including materials and textures if present |
| OBJ | Editors that cannot read GLB | Geometry only, no materials |
| STL | 3D printing | Binary geometry only, no colors or textures |

## Install

### 1. Download the decoder files

The decoder (`mesh_loader.js` and `mesh_loader.wasm`) is not stored in this repository. Run the script for your system from the project root.

| System | Command |
|--------|---------|
| macOS or Linux | `sh ./setup-vendor.sh` |
| Windows (PowerShell) | `powershell -ExecutionPolicy Bypass -File .\setup-vendor.ps1` |

Both scripts download from `meshy.ai`, check each file's SHA-256 against a pinned value, and put the files in `chrome-extension/vendor/`. On a mismatch the file is deleted and the script fails.

### 2. Load the extension

1. Open `chrome://extensions`.
2. Turn on **Developer mode**.
3. Click **Load unpacked**.
4. Select the `chrome-extension` folder.

Requires Google Chrome or another Chromium browser.

## Use

1. Open the page where the model is shown and let it finish loading.
2. Click the extension icon. It scans the page automatically; use **Refresh** to scan again.
3. Select a `.meshy` file and an output format.
4. Click **Download**. Chrome asks once per site to allow access to the file's origin.

## Security and privacy

| Topic | Behavior |
|-------|----------|
| Permissions | `activeTab`, `downloads`, `scripting`. No content script and no background network monitoring. |
| Site access | Requested per file origin when you click Download, never granted up front. |
| Cookies | Not sent. Downloads are made without your login. |
| Conversion | Runs locally in a sandboxed page. Nothing is uploaded. |
| Decoder files | Pinned by SHA-256. If `meshy.ai` changes them, setup fails until you review the new files and update the pin in both setup scripts. |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "Decoder files are missing" | Run the setup script for your system, then reload the extension in `chrome://extensions`. |
| No file listed | Wait for the model to load on the page, then click **Refresh**. |
| Download fails on a site that needs login | Files that require your cookies or short-lived URLs are not supported. |
| Setup script reports a SHA-256 mismatch | Upstream changed the file. Review it before updating the pinned hash. |

## Extra: command-line GLB to STL

`glb-to-stl.js` converts a GLB you already have to STL, without the extension:

```bash
node glb-to-stl.js input.glb output.stl
```
