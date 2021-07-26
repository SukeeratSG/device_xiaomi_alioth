#!/bin/bash

# <> Marks the things you can fill

# User Defined Stuff

user="shubham"

# Build env definition

lunch_command="corvus"
device_codename="alioth"
build_type="userdebug"
gapps_command="WITH_GAPPS"

#(With Gapps yes|no)

with_gapps="<no>"

#(Make command  : yes|no|bacon)

use_brunch="<yes>" 

# ROM Path definition

folder="/home2/shubh1133/corvus/"
rom_name="Corvus_v16.8-Avalon-"*.zip
OUT_PATH="$folder/out/target/product/${device_codename}"
ROM=${OUT_PATH}/${rom_name}

# Telegram Config

priv_to_me="/home/dump/configs/priv.conf"

tg_send () {
    sudo telegram-send --format html "$priv" --config ${priv_to_me} --disable-web-page-preview && \
    sudo telegram-send --format html "$priv" --config ${newpeeps} --disable-web-page-preview
}

# Go to build directory

cd "$folder"
echo -e "Build starting thank you for waiting"
BLINK="https://ci.goindi.org/job/$JOB_NAME/$BUILD_ID/console"

read -r -d '' priv <<EOT
<b>Build Started</b>
${lunch_command} for  ${device_codename}
<b>Console log:</b> <a href="${BLINK}">here</a>
Hope it Boots !
Visit goindi.org for more
EOT
tg_send $priv

# Time to build

export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
export CCACHE_DIR=/home2/shubh1133/ccache 
if [ -d ${CCACHE_DIR} ]; then
        echo "ccache folder already exists."
        else
        sudo chmod -R 777 ${CCACHE_DIR}
        echo "modifying ccache dir permission."
fi
if [ -d ${folder}/out ]; then
        echo "out folder already exists."
        else
        mkdir out
        sudo chmod -R 777 out
        echo "modifying out dir permission."
fi
ccache -M 75G

source build/envsetup.sh
lunch ${lunch_command}_${device_codename}-${build_type}

# Gapps export to env

if [ "$with_gapps" = "yes" ]; then
    export "$gapps_command"=true
    else
    export "$gapps_command"=false
fi

# Clean build

make_clean=installclean
if [ "$make_clean" = "yes" ]; then
    rm -rf out
    echo -e "Clean Build";
fi
if [ "$make_clean" = "installclean" ]; then
    rm -rf ${OUT_PATH}
    echo -e "Install Clean";
fi

# Need to clean old zips for pattern matching

rm -rf ${OUT_PATH}/*.zip

# Build Time

brunch ${device_codename}

# ROM

if [ -f $ROM ]; then
    mkdir -p /home/dump/sites/goindi/downloads/${user}/${device_codename}
    cp $ROM /home/dump/sites/goindi/downloads/${user}/${device_codename}

    # Finished build notification

    filename="$(basename $ROM)"
    LINK="https://download.goindi.org/${user}/${device_codename}/${filename}"
    size="$(du -h ${ROM}|awk '{print $1}')"
    mdsum="$(md5sum ${ROM}|awk '{print $1}')"

	read -r -d '' priv <<EOT
	<b>Build Completed</b>
	${lunch_command} for ${device_codename}
	<b>Download:</b> <a href="${LINK}">here</a>
	<b>Size:</b> <pre> ${size}</pre>
	<b>MD5:</b> <pre> ${mdsum}</pre>
EOT
    tg_send $priv

else
    # Error notification
    read -r -d '' priv <<EOT
	<b>Error Generated</b>
	<b>Check error:</b> <a href="https://ci.goindi.org/job/$JOB_NAME/$BUILD_ID/console">here</a>
EOT
	tg_send $priv
	fi
