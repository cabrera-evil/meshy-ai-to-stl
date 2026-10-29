# Meshy To STL

Local Chrome extension that finds `.meshy` files loaded by the current tab and converts them to STL, OBJ, or GLB.

## Install

Before loading the extension, download the local decoder files:

### Windows

```powershell
cd C:\path\to\meshy-to-stl
powershell -ExecutionPolicy Bypass -File .\setup-vendor.ps1
```

### macOS or Linux

Open Terminal in the project root (the folder above `chrome-extension`) and run:

```bash
sh ./setup-vendor.sh
```

1. Open `chrome://extensions`.
2. Enable `Developer mode`.
3. Click `Load unpacked`.
4. Select the project's `chrome-extension` folder.

## Use

1. Open the page where the `.meshy` model is hosted.
2. Reload the page if no file is listed.
3. Click the extension icon.
4. Select the detected `.meshy` file.
5. Choose STL, OBJ, or GLB.
6. Click the download button.

## Notes

- Conversion runs locally in the browser.
- `vendor/mesh_loader.js` and `vendor/mesh_loader.wasm` are not versioned in this repository; run the setup script for your operating system to download local copies.
- If the extension says decoder files are missing, run `setup-vendor.ps1` on Windows or `sh ./setup-vendor.sh` on macOS/Linux, then reload the extension in `chrome://extensions`.
- On convert, Chrome asks for site access to the model file's origin (optional host permission); the extension holds no site access until you allow it. Downloads are made without cookies.
- `setup-vendor.sh` and `setup-vendor.ps1` verify the SHA-256 of each decoder file against pinned values. On a mismatch the file is deleted and the script fails; upstream may have changed, so re-review the file before updating the pin.
- The extension requires Google Chrome or a compatible Chromium browser; Safari is not supported.
- STL output is binary, OBJ output contains geometry without materials, and GLB preserves the decoded model data.
- The popup scans the page's DOM and `performance.getEntriesByType("resource")` when opened.
- Sites with temporary URLs or strict download permissions may not work, since downloads are made without your cookies.
