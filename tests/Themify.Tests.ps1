Set-StrictMode -Version Latest

$moduleManifestPath = Join-Path -Path $PSScriptRoot -ChildPath '..\Themify.psd1'
Import-Module -Name $moduleManifestPath -Force

Describe 'New-ThemifyDesktopThemePack' {
    BeforeAll {
        $testRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ("ThemifyTests_{0}" -f [guid]::NewGuid())
        $null = New-Item -Path $testRoot -ItemType Directory -Force
    }

    AfterAll {
        if (Test-Path -Path $testRoot -PathType Container) {
            Remove-Item -Path $testRoot -Recurse -Force
        }
    }

    It 'creates a deskthemepack with themed wallpaper names and default extension behavior' {
        $sourcePath = Join-Path -Path $testRoot -ChildPath 'wallpapers-basic'
        $null = New-Item -Path $sourcePath -ItemType Directory -Force
        Set-Content -Path (Join-Path -Path $sourcePath -ChildPath 'a.png') -Value 'image-a' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $sourcePath -ChildPath 'b.jpg') -Value 'image-b' -Encoding ASCII

        $outputBasePath = Join-Path -Path $testRoot -ChildPath 'ThemePackOutput'
        $result = New-ThemifyDesktopThemePack -SourcePath $sourcePath -ThemeName 'Theme01' -OutputPath $outputBasePath -PassThru

        $result.OutputPath | Should -Be (Join-Path -Path $testRoot -ChildPath 'ThemePackOutput.deskthemepack')
        Test-Path -Path $result.OutputPath -PathType Leaf | Should -BeTrue

        $extractPath = Join-Path -Path $testRoot -ChildPath 'extract-basic'
        $null = New-Item -Path $extractPath -ItemType Directory -Force
        expand.exe $result.OutputPath -F:* $extractPath | Out-Null

        Test-Path -Path (Join-Path -Path $extractPath -ChildPath 'DesktopBackground\Theme01.Wallpaper0.png') -PathType Leaf | Should -BeTrue
        Test-Path -Path (Join-Path -Path $extractPath -ChildPath 'DesktopBackground\Theme01.Wallpaper1.jpg') -PathType Leaf | Should -BeTrue

        $themeFile = Get-ChildItem -Path $extractPath -Filter '*.theme' | Select-Object -First 1
        $themeFile | Should -Not -BeNullOrEmpty
        $themeContent = Get-Content -Path $themeFile.FullName -Raw
        $themeContent | Should -Match 'Wallpaper=DesktopBackground\\Theme01.Wallpaper0\.png'
    }

    It 'creates mapped cursor and sound files with standardized themed names' {
        $sourcePath = Join-Path -Path $testRoot -ChildPath 'wallpapers-mapped'
        $cursorPath = Join-Path -Path $testRoot -ChildPath 'cursors'
        $soundPath = Join-Path -Path $testRoot -ChildPath 'sounds'
        $null = New-Item -Path $sourcePath -ItemType Directory -Force
        $null = New-Item -Path $cursorPath -ItemType Directory -Force
        $null = New-Item -Path $soundPath -ItemType Directory -Force

        Set-Content -Path (Join-Path -Path $sourcePath -ChildPath 'w0.png') -Value 'image-0' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $sourcePath -ChildPath 'w1.png') -Value 'image-1' -Encoding ASCII

        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_pen.cur') -Value 'pen' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_arrow.cur') -Value 'arrow' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_busy.ani') -Value 'wait' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_working.ani') -Value 'working' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_link.cur') -Value 'link' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_helpsel.cur') -Value 'help' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_unavail.cur') -Value 'no' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_move.cur') -Value 'move' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_nesw.cur') -Value 'nesw' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_ns.cur') -Value 'ns' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_nwse.cur') -Value 'nwse' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_ew.cur') -Value 'ew' -Encoding ASCII
        Set-Content -Path (Join-Path -Path $cursorPath -ChildPath 'aero_up.cur') -Value 'up' -Encoding ASCII

        Set-Content -Path (Join-Path -Path $soundPath -ChildPath 'Windows Default.wav') -Value 'beep' -Encoding ASCII

        $outputPath = Join-Path -Path $testRoot -ChildPath 'ThemeMapped.deskthemepack'
        $result = New-ThemifyDesktopThemePack -SourcePath $sourcePath -ThemeName 'Theme01' -OutputPath $outputPath -CursorSourcePath $cursorPath -SoundSourcePath $soundPath -PassThru
        Test-Path -Path $result.OutputPath -PathType Leaf | Should -BeTrue

        $extractPath = Join-Path -Path $testRoot -ChildPath 'extract-mapped'
        $null = New-Item -Path $extractPath -ItemType Directory -Force
        expand.exe $result.OutputPath -F:* $extractPath | Out-Null

        Test-Path -Path (Join-Path -Path $extractPath -ChildPath 'Cursors\Theme01.Cursor.NWPen.cur') -PathType Leaf | Should -BeTrue
        Test-Path -Path (Join-Path -Path $extractPath -ChildPath 'Sounds\Theme01.Sounds.DefaultBeep.wav') -PathType Leaf | Should -BeTrue
    }

    It 'fails when source path does not exist' {
        {
            New-ThemifyDesktopThemePack -SourcePath (Join-Path -Path $testRoot -ChildPath 'missing-source') -ThemeName 'Theme01'
        } | Should -Throw
    }

    It 'supports the script entry point with parameters' {
        $sourcePath = Join-Path -Path $testRoot -ChildPath 'wallpapers-script'
        $null = New-Item -Path $sourcePath -ItemType Directory -Force
        Set-Content -Path (Join-Path -Path $sourcePath -ChildPath 'x.png') -Value 'image-x' -Encoding ASCII

        $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath '..\Themify.ps1'
        $outputPath = Join-Path -Path $testRoot -ChildPath 'ThemeFromScript'
        & $scriptPath -SourcePath $sourcePath -ThemeName 'Theme01' -OutputPath $outputPath

        Test-Path -Path (Join-Path -Path $testRoot -ChildPath 'ThemeFromScript.deskthemepack') -PathType Leaf | Should -BeTrue
    }
}
