# script by urain39
# https://github.com/urain39/terant.git

SYSTEM="archlinux"
TGZ_FILE=${PWD}/${SYSTEM}.tgz

check_prefix() {
    ## Check variable if it is not set.
    #if [ ! -v PREFIX ]; then
    #    export PREFIX=/data/data/com.termux/files/usr
    #    return
    #fi

    # Check variable if it is empty
    if [ -z $PREFIX ]; then
        export PREFIX=/data/data/com.termux/files/usr
    fi

    if [ ! -e ${PREFIX} ]; then
        echo "ERROR: prefix path is not found!"
        exit 2
    fi
}

check_depends() {
    for depend in ${depends[@]}; do
        if [ ! -e ${depend} ]; then
            pkgname=${depend##*/}
            echo "installing ${pkgname}"
            echo "y" | apt install ${pkgname} 2> /dev/null

            if [ $? != 0 ]; then
                echo "ERROR: install ${pkgname} failed!"
                exit 1
            fi
        fi
    done
}

download_tgzfile() {
    if [ ! -e ${TGZ_FILE} ]; then
        wget=${depends[2]}
        arch=$(uname -m)

        case ${arch} in
        aarch64)
            # 64 bit
            down_url="http://mirrors.ustc.edu.cn/archlinuxarm/os/ArchLinuxARM-aarch64-latest.tar.gz"
            ;;
        *)
            # 32 bit
            down_url="http://mirrors.ustc.edu.cn/archlinuxarm/os/ArchLinuxARM-armv5-latest.tar.gz"
            ;;
        esac

        if [ ! -e ${TGZ_FILE} ]; then
            ${wget} -O ${TGZ_FILE} ${down_url}
        fi
    fi
}

check_runpath() {
    tar=${depends[0]}

    if [ ! -e ${RUN_PATH} ]; then
        mkdir ${RUN_PATH}
    fi
    
    cd ${RUN_PATH}
    ${tar} -xvpf ${TGZ_FILE} 2> /dev/null
}


# Keep it simple and stupid
generate_init_sh() {
    if [ ! -e ${RUN_PATH}/root/.bashrc ]; then
        echo 'export PS1="[\u@arch \W]"'       >  ${RUN_PATH}/root/.bashrc
        echo 'alias ls="ls --color=auto"'     >> ${RUN_PATH}/root/.bashrc
        echo 'alias grep="grep --color=auto"' >> ${RUN_PATH}/root/.bashrc
    fi

    echo '#!/usr/bin/bash'               >  ${RUN_PATH}/init.sh
    echo 'unset LD_LIBRARY_PATH'         >> ${RUN_PATH}/init.sh
    echo 'unset PREFIX'                  >> ${RUN_PATH}/init.sh
    echo 'unset LD_PRELOAD'              >> ${RUN_PATH}/init.sh
    echo 'export TERM="xterm"'           >> ${RUN_PATH}/init.sh
    echo 'export HOME="/root"'           >> ${RUN_PATH}/init.sh
    echo '. /etc/profile'                >> ${RUN_PATH}/init.sh
    echo 'cd $HOME'                      >> ${RUN_PATH}/init.sh
    echo 'export HOSTNAME="arch"'        >> ${RUN_PATH}/init.sh
    echo 'bash'                          >> ${RUN_PATH}/init.sh
    echo 'rm -rf /tmp/*'                 >> ${RUN_PATH}/init.sh

    echo '# No Shebang!!!'               >  ${PREFIX}/bin/terant
    echo "proot -r ${RUN_PATH} \\"       >> ${PREFIX}/bin/terant
    echo ' -b /dev -b /proc \'           >> ${PREFIX}/bin/terant
    echo ' -b /sdcard -b /sys \'         >> ${PREFIX}/bin/terant
    echo ' -w /root -0 --link2symlink \' >> ${PREFIX}/bin/terant
    echo ' /init.sh'                     >> ${PREFIX}/bin/terant 

    chmod 0755 ${RUN_PATH}/init.sh
    chmod 0755 ${PREFIX}/bin/terant
}

replace_resolv() {
    if [ ! -e $RUN_PATH/etc/resolv.conf ]; then
        rm $RUN_PATH/etc/resolv.conf
        echo "nameserver 8.8.8.8" >  ${RUN_PATH}/etc/resolv.conf
        echo "nameserver 8.8.4.4" >> ${RUN_PATH}/etc/resolv.conf
    fi

    chmod 644 $RUN_PATH/etc/resolv.conf
}

main() {

    check_prefix

    local depends=(
        "$PREFIX/bin/tar"
        "$PREFIX/bin/figlet"
        "$PREFIX/bin/wget"
        "$PREFIX/bin/proot"
    )

    local RUN_PATH=${PREFIX}/share/terant

    check_depends
    download_tgzfile

    check_runpath
    generate_init_sh
    
    replace_resolv
}

main

echo "感谢使用，如果可以的话欢迎加入termux社(QQ群494453985)" && sleep 3
xdg-open "mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Fk%3DM7DiaZsJmkVhvD9B321HAbCqoOiYV80-%26auth%3Dbd8d786d79fc1cff9a063cfe2bd19a791ceb3c7af44e2e4d988efc5e851ba0488db142e55f6d4041"

# vim: set ts=4 sw=4 et:

