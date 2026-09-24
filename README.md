# StickyTarget2

A lightweight World of Warcraft addon that keeps your target "sticky" while in combat, so clicking the ground or an empty area doesn't deselect it — while restoring normal click-to-deselect behavior out of combat.

Inspired by the original StickyTarget by SatPagle.

## What it does

StickyTarget2 toggles the `deselectOnClick` CVar automatically:

- Entering combat (`PLAYER_REGEN_DISABLED`): sets `deselectOnClick` to `0` (sticky — your target stays selected).
- Leaving combat (`PLAYER_REGEN_ENABLED`) or logging in: sets `deselectOnClick` back to `1` (normal deselect behavior).
- Watches for the CVar being changed externally and re-enforces the desired value.

## Slash commands

- `/stickytarget on` — force sticky targeting on.
- `/stickytarget off` — disable the addon's enforcement.

## Installation

Copy the `StickyTarget` folder into your WoW `_retail_/Interface/AddOns/` directory (Modern WoW) or `_classic_beta_/Interface/AddOns/` directory (WoW Forever), or install through Wago app

## Supported clients

A single TOC lists both interface versions:

- Modern WoW (retail): 120100
- WoW Forever: 16001
