#!/bin/bash

usage()
{
cat << _EOT_
    invalid arguments

    usage : build.sh [option]
      make    - compile binaries
      debug   - compile binaries with debug symbol
      clean   - delete binaries and src/version.h
      package - compress binaries and .txt to zip (require 7z.exe)
_EOT_
exit
}

make_version.h()
{
    echo "#define A2PM_VERSION \"rev `git rev-list HEAD -n 1 | cut -c 1-7`\"" > src/version.h
    echo "#define A2PM_DATE_OF_BUILD \"`date -u +"%Y%m%d-%H:%M"`[UTC]\"" >> src/version.h
}

if [ $# -eq 0 ]; then
    usage
fi

cd `dirname $0`

case $1 in
    make )
        make_version.h
        cd src
        gcc -Wall -Os -std=gnu99 -s -DA2P_AVS26 -fstrength-reduce -march=i686 -mfpmath=sse -msse -ffast-math avs2pipemod.c common.c wave.c avisynth26/avisynth.lib -o ../avs2pipe26mod.exe
        gcc -Wall -Os -std=gnu99 -s -fstrength-reduce -march=i686 -mfpmath=sse -ffast-math -msse avs2pipemod.c common.c wave.c avisynth25/avisynth.lib -o ../avs2pipemod.exe
        ;;
    debug )
        make_version.h
        cd src
        gcc -Wall -g -std=gnu99 -DA2P_AVS26 avs2pipemod.c common.c wave.c avisynth26/avisynth.lib -o ../a2pm26_dbg.exe
        gcc -Wall -g -std=gnu99 avs2pipemod.c common.c wave.c avisynth25/avisynth.lib -o ../a2pm_dbg.exe
        ;;
    clean )
        rm -f avs2pipe*.exe *_dbg.exe
        rm -f src/version.h
        ;;
    package )
        7z a -tzip avs2pipemod-`date -u +"%Y%m%d"` *.exe *.txt
        ;;
    *)
        usage
        ;;
esac
