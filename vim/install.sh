#!/bin/sh

BASE_DIR=`pwd`
TODAY=`date +%Y%m%d%H%M%S`

install_mac_os() {
    brew install python
    brew install vim ctags
    brew install tmux
}

install_debain() {
    sudo apt-get install -y clang cmake build-essential 2>> err.log

    # 解决Ubuntu 14.04编译YCM时找不到libclang.so的问题
    for CLANG_VERSION in 4.2 4.1 4.0 3.9 3.8 3.7 3.6 3.5 3.4 3.3 3.2 3.1 3.0
    do
        if [ ! -e /usr/lib/llvm-$CLANG_VERSION/lib/libclang.so ] && [ -e /usr/lib/llvm-$CLANG_VERSION/lib/libclang.so.1 ]
        then
            sudo ln -sf /usr/lib/llvm-$CLANG_VERSION/lib/libclang.so.1 /usr/lib/llvm-$CLANG_VERSION/lib/libclang.so
            break
        elif [ -L /usr/lib/llvm-$CLANG_VERSION/lib/libclang.so ]
        then
            sudo unlink /usr/lib/llvm-$CLANG_VERSION/lib/libclang.so
            sudo ln -sf /usr/lib/llvm-$CLANG_VERSION/lib/libclang.so.1 /usr/lib/llvm-$CLANG_VERSION/lib/libclang.so
            break
        fi
    done

    sudo apt-get install -y vim ctags 2>> err.log
    sudo apt-get install -y python-dev python-setuptools 2>> err.log
}

install_fedora() {
    sudo yum install vim -y
    sudo yum install python-devel.x86_64
    sudo yum groupinstall 'Development Tools'
}

install_vim() {
    echo "\033[034m* Installing vim...\033[0m"
    SYSTEM=`uname -s`
    if [ $SYSTEM = "Darwin" ]
    then
        install_mac_os
    elif [ `which apt-get` ]
    then
        install_debain
    elif [ `which yum` ]
    then
        install_fedora
    fi
}

# Configure Vim
link_vimrc() {
    echo "\033[34m* Backing up vim configure...\033[0m"
    for i in $HOME/.vim $HOME/.vimrc $HOME/.vimrc.bundles; do [ -L $i ] && unlink $i; done
    for i in $HOME/.vim $HOME/.vimrc $HOME/.vimrc.bundles; do [ -e $i ] && mv $i $i.$TODAY; done

    echo "\033[34m* Setting up symlinks...\033[0m"
    ln -s $BASE_DIR/vimrc $HOME/.vimrc
    ln -s $BASE_DIR/vimrc.bundles $HOME/.vimrc.bundles
    ln -s $BASE_DIR $HOME/.vim
}



################# Start ########################
install_vim
link_vimrc
# Vim configure complete
echo "\033[034m* Vim Configure completed!\033[0m"
################ End ###########################
