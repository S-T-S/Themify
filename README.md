# Themify

A Windows desktop theme pack creator.

This repository now includes:

- Legacy VBScript implementation: [Themify.vbs](./Themify.vbs)
- PowerShell implementation (no GUI): [Themify.ps1](./Themify.ps1), [Themify.psm1](./Themify.psm1)
- Default resource mapping data file: [ResourceNameMap.psd1](./ResourceNameMap.psd1)
- Cucumber specifications: [specs/features/themify.feature](./specs/features/themify.feature)
- Pester tests: [tests/Themify.Tests.ps1](./tests/Themify.Tests.ps1)

## PowerShell usage

Import as module:

```powershell
Import-Module .\Themify.psd1 -Force
```

Create a theme pack from wallpapers:

```powershell
New-ThemifyDesktopThemePack -SourcePath 'C:\Images\Wallpapers' -ThemeName 'Theme01' -OutputPath 'C:\Output\Theme01'
```

Create a theme pack with mapped cursor and wave resources:

```powershell
$params = @{
    SourcePath       = 'C:\Images\Wallpapers'
    ThemeName        = 'Theme01'
    OutputPath       = 'C:\Output\Theme01.deskthemepack'
    CursorSourcePath = 'C:\ThemeAssets\Cursors'
    SoundSourcePath  = 'C:\ThemeAssets\Sounds'
    ResourceMapPath  = '.\ResourceNameMap.psd1'
    PassThru         = $true
}

New-ThemifyDesktopThemePack @params
```

Run through script entry point:

```powershell
.\Themify.ps1 -SourcePath 'C:\Images\Wallpapers' -ThemeName 'Theme01' -OutputPath 'C:\Output\Theme01'
```

## Naming guarantees for exported resources

All exported resources include the theme name prefix and standardized category naming:

- `Theme01.Wallpaper0.png`
- `Theme01.Cursor.NWPen.cur`
- `Theme01.Sounds.DefaultBeep.wav`

## Testing

Run Pester tests:

```powershell
Invoke-Pester -Path .\tests\Themify.Tests.ps1
```