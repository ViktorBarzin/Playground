#!/bin/bash
set -e

packages_file="/home/viktor/packages.txt"

# Get package names
pk=$(kdialog --title "Add package" --inputbox "Package to add:")

# For each package - add it (assume split by space)
for p in $pk; do
    echo $p >> $packages_file
done

