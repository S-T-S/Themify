[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $SourcePath,

    [Parameter(Mandatory)]
    [string] $ThemeName,

    [Parameter()]
    [string] $OutputPath = (Join-Path -Path (Get-Location) -ChildPath 'Output.deskthemepack'),

    [Parameter()]
    [ValidateRange(1, [int]::MaxValue)]
    [int] $SlideshowInterval = 600000,

    [Parameter()]
    [switch] $Shuffle,

    [Parameter()]
    [string[]] $WallpaperExtensions = @('.bmp', '.jpg', '.jpeg', '.png'),

    [Parameter()]
    [string] $CursorSourcePath,

    [Parameter()]
    [string] $SoundSourcePath,

    [Parameter()]
    [string] $ResourceMapPath = (Join-Path -Path $PSScriptRoot -ChildPath 'ResourceNameMap.psd1'),

    [Parameter()]
    [switch] $PassThru
)

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Themify.psd1') -Force

$themePackParams = @{
    SourcePath         = $SourcePath
    ThemeName          = $ThemeName
    OutputPath         = $OutputPath
    SlideshowInterval  = $SlideshowInterval
    Shuffle            = $Shuffle
    WallpaperExtensions = $WallpaperExtensions
    ResourceMapPath    = $ResourceMapPath
    PassThru           = $PassThru
}

if ($PSBoundParameters.ContainsKey('CursorSourcePath')) {
    $themePackParams.CursorSourcePath = $CursorSourcePath
}
if ($PSBoundParameters.ContainsKey('SoundSourcePath')) {
    $themePackParams.SoundSourcePath = $SoundSourcePath
}

New-ThemifyDesktopThemePack @themePackParams
