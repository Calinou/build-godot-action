#!/bin/sh
set -e

# Install export templates
wget https://downloads.tuxfamily.org/godotengine/3.2.1/Godot_v3.2.1-stable_export_templates.tpz --quiet
mkdir ~/.cache
mkdir -p ~/.config/godot
mkdir -p ~/.local/share/godot/templates/3.2.1.stable
unzip Godot_v3.2.1-stable_export_templates.tpz
mv templates/* ~/.local/share/godot/templates/3.2.1.stable
rm -f Godot_v3.2.1-stable_export_templates.tpz

if [ "$3" != "" ]
then
    SubDirectoryLocation="$3/"
fi

mode="export"
if [ "$6" = "true" ]
then
    mode="export-debug"
fi

# Export for project
echo "Building $1 for $2"
mkdir -p ~/build/${SubDirectoryLocation:-""}
cd ${5-"~"}
godot --${mode} $2 ~/build/${SubDirectoryLocation:-""}$1
cd ~

echo ::set-output name=build::~/build/${SubDirectoryLocation:-""}


if [ "$4" = "true" ]
then
    mkdir ~/package
    cd ~/build
    zip ~/package/artifact.zip ${SubDirectoryLocation:-"."} -r
    echo ::set-output name=artifact::~/package/artifact.zip
fi
