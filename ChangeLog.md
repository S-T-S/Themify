# iBug Themify Change Log

### Monad (PowerShell branch)

Added a PowerShell implementation with parameterized automation flow.

- Added module files: `Themify.psd1`, `Themify.psm1`
- Added script entry point: `Themify.ps1`
- Added configurable mapping file: `ResourceNameMap.psd1`
- Added Cucumber specifications in `specs/features/themify.feature`
- Added Pester tests in `tests/Themify.Tests.ps1`
- Added module process documentation: `Themify.RedMe.md`
- No GUI implemented in PowerShell version
- Exported resource files now include the theme name and standardized naming:
  - `Theme01.Wallpaper0.png`
  - `Theme01.Cursor.NWPen.cur`
  - `Theme01.Sounds.DefaultBeep.wav`

### 8

Automatically cut off CAB file at 2 GB (CAB file can't exceed 2 GiB)

### 7

Allow more than 1,000 files.

You can now let ***Themify*** default output file name

### 6

Now you can specify a slideshow interval.

A small typo fix.

### 5

Add support for command line arguments. Currectly it only reads the first argument as the configuration file and proceeds automatically.

```
Themify.vbs <ConfigFile>
```

### 4

A line containing an equal sign `=` will no longer cause error if it starts with a semicolon `;`

### 3

Fix a bug where options are truncated at the equal sign `=`

Options are no longer case sensitive.

### 1

Initial release.