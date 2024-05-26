﻿## [10.2.7.1] ##
### Fixed ###

  * [retail] fix: Another LFGList layer change - missed previously - #116
  * [retail] fix: GetPlayerStyleString Taint
  * [retail] add: support for groupfinder-icon-role-micro


## [10.2.7.0] ##
### Fixed ###

  * [classic] disabled non-mainline builds while rebuilding the structure
  * [retail] disable: hooksecurefunc FriendsFrame - this is no longer a function
  * [retail] fix: changes to LoadWith and toc - Blizzard fubard this one
  * [retail] fix: LFGList is changed - added another layer
  * [retail] disable petstable broken code - add a error on staticpopups.
  * [general] chore: resync all Addons and FramleXML xml files. Cata is added..
  * [retail] chore: resync Skin/Interface/FrameXML/FrameXML_WoWLabs.xml
  * [retail] fix: missing brackets
  * [retail] chore: sync with gethe/wow-ui-source


## [10.2.6.1] ##
### Fixed ###

  * [retail] Remove LFGListUtil_SetSearchEntryTooltip debug print spam
  * [retail] Fixed some missing _G references and cleared out luacheck warnings

## [10.2.6.0] ##
### Fixed ###

  * [retail] LFGListUtil_SetSearchEntryTooltip updates
  * [retail] Fix for 10.2.6 API changes C_Item


## [10.2.5.1] ##
### Fixed ###

  * [retail] AuctionHouseItemListMixin no longer has the functions OnScrollBoxRangeChanged or UpdateSelectionHighlights


## [10.2.5.0] ##
### Fixed ###

  * [retail] ColorPicker changes according to 10.2.5
  * [retail] LFG and PVP Groupfinder cleanups
  * [retail] license update for 2024


## [10.2.0.0] ##
### Fixed ###

  * [retail] Some new status bars in raids don't have a texture?
  * [retail] Addon management functions moved to the C_AddOns namespace.
  * [retail] Error on AddOn list in game. AddonList now uses ScrollBox.
  * [retail] Change of OrbitCamera to ModelScene.ControlFrame  

### Disabled ###
  * [retail] PlayerChoiceFrame while fixing this


## [10.1.7.0] ##
### Fixed ###

  * [retail] Fixed for Patch 10.1.7


## [10.1.5.1] ##
### Fixed ###

  * [retail] Error when opening the battlefield map
  * [retail] Action bar error on login


## [10.1.5.0] ##
### Fixed ###

  * [retail] Fixed for Patch 10.1.5

## [10.0.2.2] ##
### Fixed ###

  * [retail] Error when scenario stage has a progress bar
  * [retail] Covenant sanctum was missing background
  * [retail] Error when searching LFG
  * [wrath] Error when inspecting other players
  * [wrath] Error for scribes with Northrend Inscription


## [10.0.2.1] ##
### Fixed ###

  * Error with loot history
  * [retail] Various small fixes for Dragonflight


## [10.0.2.0] ##
### Fixed ###

  * More fixes for Dragonflight


## [10.0.0.0] ##
### Fixed ###

  * Updated for Dragonflight


## [9.2.7.0] ##
### Added ###

  * [retail] Basic support for Dragonflight (WIP)

### Fixed ###

  * Money test for trade targets was misplaced
  * [retail] Achievement borders wer not skinned
  * [wrath] Various fixes for Wrath Classic


## [9.2.5.0] ##
### Changed ###

  * [retail] Updated mail skin
  * [classic] Updated interface options

### Fixed ###

  * [retail] Various fixes for 9.2.5
  * [retail] Error when using the map before choosing a Covenant
  * [retail] Error when using Cypher gear


## [9.2.0.0] ##
### Changed ###

  * [retail] Updated guild bank skin

### Fixed ###

  * The "At War" check box in the reputations frame was out of place
  * The reputation detail frame had an out of place background
  * [retail] Various fixes for 9.2.0
  * [retail] Error when changing guild bank permissions
  * [retail] Error when opening BFA island queue frame
  * [classic] An extra texture was visible when at max level and not tracking any reputations
  * [classic] Error when mousing over the skill detail status bar
  * [classic] Spellbook tabs would not react to mouse input
  * [tbc] LFG skin was broken
  * [tbc] The character title dropdown had a misaligned backdrop


## [9.1.5.0] ##
### Added ###

  * [tbc] LFG frame skin

### Changed ###

  * Updates for recent patch compatibility
  * Tweak class and spec backdrops
  * [retail] Update item upgrade frame
  * [retail] Tweak create channel popup
  * [retail] Update dress up frame
  * [classic] Tweak chat frame skin
  * [tbc] Update inspect frame

### Fixed ###

  * Various tooltip issues
  * [retail] Browse groups button was not skinned in LFG list
  * [retail] Channel headers in the chat channels frame were not skinned
  * [retail] PvP ready popup background was not aligned
  * [classic] Bag frame background would not update after opening the keyring
  * [classic] Errors when opening the talent frame


## [9.0.5.0] ##
### Added ###

  * [tbc] Support for BC Classic
  * [classic] Items in the loot frame now have quality colored borders
  * Skin for upgraded event trace frame

### Fixed ###

  * Loot frame misplaced when set under mouse
  * [classic] Error when opening Beast Training
  * [retail] Call to Arms reward role icons were misaligned



## [9.0.2.1] ##
### Added ###

  * [retail] Campaign Recap
  * [retail] Torghast Level Picker
  * [retail] Anima Diversion

### Changed ###

  * [retail] Tweak campaign headers

### Fixed ###

  * [retail] Error when clicking optional reagents
  * [retail] Achievement search preview backdrop was broken
  * [retail] Adventure rewards weren't skinned



## [9.0.2.0] ##
### Fixed ###

  * [retail] SSAO graphics option was not skinned
  * [retail] The dungeon ready popup had two backdrops
  * [retail] The world map's close button was out of place when maximized
  * [retail] Intermittent errors when opening the talent frame



## [9.0.1.7] - 2020-12-07 ##
### Added ###

  * [retail] Skinned Maw Buffs

### Changed ###

  * [retail] Updated Warlords garrison skin
  * Tweaked mail inbox items to not be so close to the page buttons
  * Updated /etrace dev tool skin

### Fixed ###

  * [classic] Error while exploring the plaguelands
  * [retail] Error when completing an LFG dungeon
  * [retail] Campaign quest progress bars were not skinned
  * [retail] Error when opening PvP frame
  * [retail] Scouting maps were unusable with high frame opacity
  * [retail] Dressup frame borders were not skinned
  * [retail] Barber shop buttons would sometimes be unskinned
  * [retail] Spell quest rewards had a dark colored header



## [9.0.1.6] - 2020-11-16 ##
### Added ###

  * [retail] Skinned Covenant Renown
  * Skinned RatingMenuFrame

### Changed ###

  * [retail] Updated gossip frame friendship status bar

### Fixed ###

  * Various bugs with backdrops
  * [retail] Quest tracker progress bars weren't skinned
  * [retail] Empty mission spots had the highlight out of place
  * [retail] Help tip arrows would sometimes be placed wrong
  * [retail] Various bugs from 9.0.2



## [9.0.1.5] - 2020-10-25 ##
### Changed ###

  * Tweaked font for chat bubble names

### Fixed ###

  * Error when loot skin is disabled
  * Chat bubble didn't work
  * [retail] Out of place borders on LFG list refresh buttons
  * [retail] Queue status frame wasn't skinned properly
  * [retail] Void Storage item background didn't display properly
  * [retail] Optional reagents icons would get stretched when adding an item
  * [retail] Out of place borders on the PvP category buttons
  * [retail] Sell item icon had the wrong texture
  * [retail] Volume sliders were white
  * [retail] Missed some textures on the spec frame
  * [retail] Display bug with quest detail
  * [retail] World quest header wasn't skinned
  * [retail] Display bug with the calendar
  * [retail] Error when entering a pet battle



## [9.0.1.4] - 2020-10-14 ##
### Added ###

  * [retail] New player guide sign-up skin

### Changed ###

  * [retail] Updated barber shop skin

### Fixed ###

  * [retail] Chat frame had an extra backdrop
  * [retail] Gossip options were black



## [9.0.1.3] - 2020-10-12 ##
### Fixed ###

  * [retail] Some dropdown menus did not use the configured frame alpha
  * [retail] Error when bounty tutorial is shown



## [9.0.1.2] - 2020-10-10 ##
### Fixed ###

  * [retail] Error when entering a pet battle



## [9.0.1.1] - 2020-10-10 ##
### Fixed ###

  * Core files missing in the package



## [9.0.1.0] - 2020-10-09 ##
### Added ###

  * [classic] CraftUI skin
  * [classic] Honor frame skin
  * [retail] Auto-quest objective popups skin

### Changed ###

  * [retail] Updated inspect frame
  * [retail] Tweaked hunter pet stable

### Fixed ###

  * [classic] Display bugs in dropdown menu
  * [retail] Display bugs with the AH favorite button
  * [retail] Error with rep frame
  * [retail] Gossip text overlapping friendship bar
  * [retail] Display bugs with achievement alert



## [8.3.0.8] - 2020-07-18 ##
### Added ###

  * Basic compatibility for Shadowlands

### Changed ###

  * Who list search box is now more visible
  * The archeology progress bar now has dynamic ticks

### Fixed ###

  * [classic] Fixed errors when the loot frame shows
  * [classic] Gossip frame options had the wrong colors
  * [classic] Missed some textures in the friends frame
  * [classic] SetTextColor error when in a raid
  * Error with some dropdown frames
  * Scroll list error in AH
  * Tooltip skin toggle didn't work
  * Font size was still set even when the font skin is disabled
  * Backpack money frame border was positioned wrong



## [8.3.0.7] - 2020-06-10 ##
### Fixed ###

  * Macro icon picker would obscure icons if too opaque
  * Addon list check boxes were not shaded properly
  * A few frames for the club finder were not skinned



## [8.3.0.6] - 2020-04-30 ##
### Changed ###

  * The default highlight color is now blue
  * Darkened the cast bar and main menu tracking bars
  * Minor tweak to item button borders

### Fixed ###

  * PvP results frame sill had a border around the "X" button
  * Queue status role icons were not spaced out well
  * Highlight textures for some expand buttons would still show
  * Tracking bars were still skinned if the main menu skin is disabled
  * `classic` Errors when opening the friends frame



## [8.3.0.5] - 2020-03-26 ##
### Added ###

  * Community invite skin
  * Additional action bars

### Fixed ###

  * Error when opening communities UI
  * Display bug with the send mail money border
  * Button highlights when disabled
  * Friends tooltip is now skinned again



## [8.3.0.4] - 2020-03-06 ##
### Changed ###

  * `classic` Improved keyring skin

### Fixed ###

  * Error in raid UI
  * Error when using nameplates in a raid
  * AH sell item did not have a border



## [8.3.0.3] - 2020-02-17 ##
### Changed ###

  * Improved auto complete skin

### Fixed ###

  * Chat minimize button had wrong offsets
  * Error with some older skins



## [8.3.0.2] - 2020-02-12 ##
### Added ###

  * Classic support

### Changed ###

  * More custom class color overrides across the UI
  * Various minor tweaks

### Fixed ###

  * Guild news filter options weren't skinned
  * Auction House buy dialog wasn't skinned
  * World Quest tracker heading wasn't skinned
  * CUSTOM_CLASS_COLORS callbacks were not always called when changed



## [8.3.0.1] - 2020-01-18 ##
### Fixed ###

  * Boss buttons in the Encounter Journal would not un-highlight
  * Encounter Journal loot buttons had an out of bounds overlay
  * The wardrobe outfits dropdown menu was too short



## [8.3.0.0] - 2020-01-14 ##
### Added ###

  * Flight Map
  * Item Interaction (used to cleanse Corrupted Items)
  * LFG invite popup

### Changed ###

  * Updates for 8.3.0
  * Updated group finder skin
  * Updated tradeskill skin
  * Buttons with white textures now highlight from the background instead of the white texture (close, scroll bar)
  * Tweak item scrapping UI

### Fixed ###

  * Error when opening Communities
  * BNet broadcast would not send
  * Error when viewing sets in adventure journal
  * The conquest progress bar was not colored
  * Error when opening azerite respec UI

[Unreleased]: https://github.com/Gethe/Aurora/compare/master...develop
[10.1.5.1]: https://github.com/Haleth/Aurora/compare/10.1.5.0...10.1.5.1
[10.1.5.0]: https://github.com/Haleth/Aurora/compare/10.0.2.2...10.1.5.0
[10.0.2.2]: https://github.com/Haleth/Aurora/compare/10.0.2.1...10.0.2.2
[10.0.2.1]: https://github.com/Gethe/Aurora/compare/10.0.2.0...10.0.2.1
[10.0.2.0]: https://github.com/Gethe/Aurora/compare/10.0.0.0...10.0.2.0
[10.0.0.0]: https://github.com/Gethe/Aurora/compare/9.2.7.0...10.0.0.0
[9.2.7.0]: https://github.com/Gethe/Aurora/compare/9.2.5.0...9.2.7.0
[9.2.5.0]: https://github.com/Gethe/Aurora/compare/9.2.0.0...9.2.5.0
[9.2.0.0]: https://github.com/Gethe/Aurora/compare/9.1.5.0...9.2.0.0
[9.1.5.0]: https://github.com/Gethe/Aurora/compare/9.0.5.0...9.1.5.0
[9.0.5.0]: https://github.com/Gethe/Aurora/compare/9.0.2.1...9.0.5.0
[9.0.2.1]: https://github.com/Gethe/Aurora/compare/9.0.2.0...9.0.2.1
[9.0.2.0]: https://github.com/Gethe/Aurora/compare/9.0.1.7...9.0.2.0
[9.0.1.7]: https://github.com/Gethe/Aurora/compare/9.0.1.6...9.0.1.7
[9.0.1.6]: https://github.com/Gethe/Aurora/compare/9.0.1.5...9.0.1.6
[9.0.1.5]: https://github.com/Gethe/Aurora/compare/9.0.1.4...9.0.1.5
[9.0.1.4]: https://github.com/Gethe/Aurora/compare/9.0.1.3...9.0.1.4
[9.0.1.3]: https://github.com/Gethe/Aurora/compare/9.0.1.2...9.0.1.3
[9.0.1.2]: https://github.com/Gethe/Aurora/compare/9.0.1.1...9.0.1.2
[9.0.1.1]: https://github.com/Gethe/Aurora/compare/9.0.1.0...9.0.1.1
[9.0.1.0]: https://github.com/Gethe/Aurora/compare/8.3.0.8...9.0.1.0
[8.3.0.8]: https://github.com/Gethe/Aurora/compare/8.3.0.7...8.3.0.8
[8.3.0.7]: https://github.com/Gethe/Aurora/compare/8.3.0.6...8.3.0.7
[8.3.0.6]: https://github.com/Gethe/Aurora/compare/8.3.0.5...8.3.0.6
[8.3.0.5]: https://github.com/Gethe/Aurora/compare/8.3.0.4...8.3.0.5
[8.3.0.4]: https://github.com/Gethe/Aurora/compare/8.3.0.3...8.3.0.4
[8.3.0.3]: https://github.com/Gethe/Aurora/compare/8.3.0.2...8.3.0.3
[8.3.0.2]: https://github.com/Gethe/Aurora/compare/8.3.0.1...8.3.0.2
[8.3.0.1]: https://github.com/Gethe/Aurora/compare/8.3.0.0...8.3.0.1
[8.3.0.0]: https://github.com/Gethe/Aurora/compare/8.2.5.3...8.3.0.0
