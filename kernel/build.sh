#!/bin/sh

TARGET="linux-2.6.22"
TARGET_SRC="linux-2.6.22.tar.bz2"
TARGET_SRC="linux-2.6.22.tar.xz"
CROSS_PATH=/opt/buildroot-2012.08/output/host/usr/bin

if [ ! -d ${CROSS_PATH} ];then
    echo "The Cross Compile not exsit"
    exit 1
fi

if [ ! -d ${TARGET} ];then

    if [ ! -f ${TARGET_SRC} ];then

        which wget

        if [ ! $? -eq 0 ];then
            echo "Sorry cannot find wget command, please install first"
            exit
        fi

        wget -c https://www.kernel.org/pub/linux/kernel/v2.6/${TARGET_SRC}

        if [ ! -s ${TARGET_SRC} ];then
            echo "Sorry cannot find file ${TARGET_SRC}, please check"
            exit
        fi

    fi

    #tar xjf ${TARGET_SRC}    # if u download file type is tar.bz2, please use tar xjf 
    tar xJf ${TARGET_SRC}     # if u download file type is tar.xz,  please use tar xJf 

    if [ ! -d ${TARGET} ];then
        echo "Sorry seems file broken, uncompress failed"
        exit
    fi

fi

cd ${TARGET}
zcat ../linux-2.6.22_9260.patch.gz | patch -p1

'cp' 9260_configs_2014 .config -av
make uImage
cp arch/arm/boot/uImage -av ../

cd ../
ls -lt
