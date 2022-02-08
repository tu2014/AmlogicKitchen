#!/usr/bin/sudo sh

if [ ! -d level1 ]; then
    echo "Unpack level 1 first"
    exit 0
fi

if [ -d level3 ]; then
    rm -rf level3 && mkdir level3
else
    mkdir level3
fi

for part in boot recovery
do
    if [ -f level1/${part}.PARTITION ]; then
    mkdir level3/$part
    bin/linux/unpackbootimg -i level1/${part}.PARTITION -o level3/$part
    fi
done

if [ -f level1/logo.PARTITION ]; then
    mkdir level3/logo
    bin/linux/imgpack -d level1/logo.PARTITION level3/logo
fi

if [ -f level1/_aml_dtb.PARTITION ]; then
    mkdir level3/devtree
    bin/linux/dtbSplit level1/_aml_dtb.PARTITION level3/devtree/
    for filename in level3/devtree/*.dtb; do
    [ -e "$filename" ] || continue
    name=$(basename $filename .dtb)
    dtc -I dtb -O dts level3/devtree/$name.dtb -o level3/devtree/$name.dts
    done
fi

echo "Done."