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

# create code coverage report
./gradlew createDebugCoverageReport

# move code coverage
mv -v inventory/build/reports/coverage reports$1

#move Android test
mv -v inventory/build/reports/androidTests reports$1

# replace .resources with resource because github don't support folders with "_" or "." at the beginning
mv reports$1/debug/.resources reports$1/debug/resources

# replace .sessions
mv reports$1/debug/.sessions.html reports$1/debug/sessions.html

# add header
ruby ci/scripts/add_coverage_header.rb

# add code coverage and test result
git add reports$1 -f

# temporal commit
git commit -m "tmp reports"

# get gh-pages branch
git fetch origin gh-pages

# move to gh-pages
git checkout gh-pages

# clean
sudo git clean -fdx

# remove report folder
sudo rm -R reports$1

# get documentation folder
git checkout $CIRCLE_BRANCH reports$1

# create commit
git commit -m "docs(coverage): update code coverage and test result"

# push to branch
git push origin gh-pages

# got back to original branch
git checkout $CIRCLE_BRANCH