if [ -d ~/bin ]; then
	PATH=~/bin:"${PATH}"
fi

if [ -d ~/.cabal/bin ]; then
	PATH=~/.cabal/bin:"${PATH}"
fi

if [ -d ~/Library/Haskell/bin ]; then
	PATH=~/Library/Haskell/bin:"${PATH}"
fi

if [ -d ~/man ]; then
    MANPATH=~/man${MANPATH:-:}
    export MANPATH
fi

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

export QSYS_ROOTDIR="/home/gobi/altera_lite/15.1/quartus/sopc_builder/bin"

export ALTERAOCLSDKROOT="/home/gobi/altera_lite/15.1/hld"

# Added by GraphLab Create Launcher v3.0.1

if [ -f ~/.profabevjava ]; then
  source ~/.profabevjava
fi
