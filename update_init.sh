RUN_PATH=${PREFIX}/share/terant

generate_init_sh() {
    if [ ! -e ${RUN_PATH}/root/.bashrc ]; then
        echo 'export PS1="[\u@arch \W]"'      >  ${RUN_PATH}/root/.bashrc
        echo 'alias ls="ls --color=auto"'     >> ${RUN_PATH}/root/.bashrc
        echo 'alias grep="grep --color=auto"' >> ${RUN_PATH}/root/.bashrc
    fi

    echo '#!/usr/bin/bash'               >  ${RUN_PATH}/init.sh
    echo 'export TERM="xterm"'           >> ${RUN_PATH}/init.sh
    echo 'export HOME="/root"'           >> ${RUN_PATH}/init.sh
    echo '. /etc/profile'                >> ${RUN_PATH}/init.sh
    echo 'cd $HOME'                      >> ${RUN_PATH}/init.sh
    echo 'export HOSTNAME="arch"'        >> ${RUN_PATH}/init.sh
    echo 'bash'                          >> ${RUN_PATH}/init.sh
    echo 'rm -rf /tmp/*'                 >> ${RUN_PATH}/init.sh

    mkdir ${RUN_PATH}/sdcard
    echo "mount /dev  ${RUN_PATH}/dev"               >  ${PREFIX}/bin/terant
    echo "mount /dev/pts ${RUN_PATH}/dev/pts"        >> ${PREFIX}/bin/terant
    echo "mount /proc ${RUN_PATH}/proc"              >> ${PREFIX}/bin/terant
    echo "mount /sdcard ${RUN_PATH}/sdcard"          >> ${PREFIX}/bin/terant
    echo "mount /sys  ${RUN_PATH}/sys"               >> ${PREFIX}/bin/terant
    echo "mount -t tmpfs tmpfs ${RUN_PATH}/tmp"      >> ${PREFIX}/bin/terant
    echo 'unset LD_LIBRARY_PATH'                     >> ${PREFIX}/bin/terant
    echo 'unset PREFIX'                              >> ${PREFIX}/bin/terant
    echo 'unset LD_PRELOAD'                          >> ${PREFIX}/bin/terant
    echo "chroot ${RUN_PATH} /init.sh"               >> ${PREFIX}/bin/terant
    echo "umount ${RUN_PATH}/dev/pts"                >> ${PREFIX}/bin/terant 
    echo "umount ${RUN_PATH}/dev"                    >> ${PREFIX}/bin/terant
    echo "umount ${RUN_PATH}/proc"                   >> ${PREFIX}/bin/terant
    echo "umount ${RUN_PATH}/sdcard"                 >> ${PREFIX}/bin/terant
    echo "umount ${RUN_PATH}/sys"                    >> ${PREFIX}/bin/terant

    chmod 0755 ${RUN_PATH}/init.sh
    chmod 0755 ${PREFIX}/bin/terant
}

generate_init_sh
