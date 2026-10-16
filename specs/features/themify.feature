Feature: Build Windows desktop theme packs from file collections
  As a Windows user
  I want to generate .deskthemepack files from wallpapers and optional mapped resources
  So that my desktop theme can be portable and consistently named

  Scenario: Build a wallpaper-only theme pack
    Given a wallpaper source folder with valid image files
    When I run Themify with SourcePath and ThemeName
    Then a deskthemepack file is generated
    And packaged wallpapers are renamed with the theme prefix
    And the generated theme file points to DesktopBackground\ThemeName.Wallpaper0.*

  Scenario: Build a theme pack with mapped cursors and sounds
    Given a cursor source folder and a sound source folder
    And a PSD1 map for cursor and sound file-name mapping
    When I run Themify with CursorSourcePath and SoundSourcePath
    Then packaged cursor files are renamed to ThemeName.Cursor.<LogicalName>.*
    And packaged sound files are renamed to ThemeName.Sounds.<LogicalName>.*

  Scenario: Reject missing source path
    Given a missing wallpaper source folder
    When I run Themify
    Then the command fails with a validation error
