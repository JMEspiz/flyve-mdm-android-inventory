#!/bin/bash
#
#  Copyright (C) 2017 Teclib'
#
#  This file is part of Flyve MDM Inventory Android.
#
#  Flyve MDM Inventory Android is a subproject of Flyve MDM. Flyve MDM is a mobile
#  device management software.
#
#  Flyve MDM Android is free software: you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 3
#  of the License, or (at your option) any later version.
#
#  Flyve MDM Inventory Android is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  ------------------------------------------------------------------------------
#  @author    Rafael Hernandez - rafaelje
#  @copyright Copyright (c) 2017 Flyve MDM
#  @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
#  @link      https://github.com/flyve-mdm/flyve-mdm-android-inventory
#  @link      http://www.glpi-project.org/
#  @link      https://flyve-mdm.com/
#  ------------------------------------------------------------------------------
#

# get gh-pages branch
git fetch origin gh-pages

# move to gh-pages
git checkout gh-pages

# clean unstage file on gh-pages to remove all others files gets on checkout
sudo git clean -fdx

# remove local CHANGELOG.md on gh-pages
if [[ -e CHANGELOG.md ]]; then
    sudo rm CHANGELOG.md
fi

# get changelog from branch
git checkout $CIRCLE_BRANCH CHANGELOG.md

# Create header content to CHANGELOG.md
echo "---" > header.md
echo "layout: modal" >> header.md
echo "title: changelog" >> header.md
echo "---" >> header.md

# Duplicate CHANGELOG.md
cp CHANGELOG.md CHANGELOG_COPY.md
# Add header to CHANGELOG.md
(cat header.md ; cat CHANGELOG_COPY.md) > CHANGELOG.md
# Remove CHANGELOG_COPY.md
rm CHANGELOG_COPY.md
rm header.md

# if has change
if [[ -z $(git status -s) ]]; then
    echo "with out modifications"
else
    # create a commit
    git commit -m "build(changelog): send changelog.md to gh-page"

    # push to branch
    git push origin gh-pages
fi
    # got back to original branch
    git checkout $CIRCLE_BRANCH