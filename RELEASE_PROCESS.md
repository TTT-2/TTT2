# TTT2 Releases

## Overview

TTT2 versioning is based on semantic-versioning.
Prefixing versions with a `v` to indicate it is a version number and appending a `b` to indicate its beta status.

The latest release will be published to the Steam Workshop in form of an [addon](https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556).
The latest development will be accessible on this repository's master branch.

## Release steps

The following steps will document our release process to prevent mistakes and convey possible changes to our release process more easily.

**Note:** This is meant as a guideline to achieve the goals mentioned above. Steps may be more vague or more specific than they need to be.

1. Decide the `<version>` string following SemVer.

1. Prepare necessary files.

    1. Update `CHANGELOG.md`.

        - Insert a level 2 heading right below `## Unreleased`
        - use the following format:
            - `## [<version>](https://github.com/TTT-2/TTT2/tree/<version-tag>) (YYYY-MM-DD)`

    1. Update `gamemodes/terrortown/gamemode/client/cl_changes.lua`.

        - Use the `AddChange()` function and supply it with the following three arguments:
            - Addon name and version `"TTT2 Base - <version>"`.
            - An html formatted list of changes since the last release.
            - `os.time()` supplied with the current date e.g. `os.time({year = YYYY, month = MM, day = DD})`.

    1. Update `gamemodes/terrortown/gamemode/shared/sh_init.lua`.

        - Update the `GM.Version` string to the new version.
        - Check if other `GM` strings are up to date as well.

    1. Clean up the language files with our leanguage cleanup tool

        - Tool: https://github.com/TTT-2/ttt2-language_parser
        - Run from folder as: `python parse.py --in "../TTT2/lua/terrortown/lang" --out "../TTT2/lua/terrortown/lang" --base "en" --ignore "chef"`
        - Makes sure all language files align with the english translation

1. Open a Pull-Request prefixed with `[Release]` with the changes from above.

1. Once the Pull-Request is approved and merged, proceed.

1. Draft a new Github release.

    1. Target the `master` branch.
    1. Supply both `Tag version` and `Release title` with `<version>`.
    1. Copy applicable entries from the `CHANGELOG.md` to the `Describe this release` textarea.
    1. Press `Publish release`.

1. Release to the Steam Workshop.
