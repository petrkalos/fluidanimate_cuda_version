#!/bin/bash

CC="g++"

if [ `which my_nvcc` ]; then
    NVCC="my_nvcc"
    NVCCFLAGS=""
    echo "my_nvcc found, use that"
else
    NVCC="nvcc"

    case $HOSTNAME in
        blacksunhat)
            #my machine
            SDK_PATH="/opt"
            ;;
        *)
            SDK_PATH="~"
    esac

    SDK_HOME="$SDK_PATH/NVIDIA_GPU_Computing_SDK"

    ARCH="`uname -i`"

    if [ $ARCH = 'unknown' ]; then
        echo "unkown platform, set to i386"
        ARCH="i386"
    fi

    NVCCFLAGS="-I $SDK_HOME/C/common/inc/ \
    -L $SDK_HOME/C/lib/ -l cutil_$ARCH \
    -lcudart \
    -O4"
fi

CPPFLAGS="-lpthread -O4"
NVCCFLAGS="$NVCCFLAGS $@"

BINDIR="bin"
TOOLSDIR="tools"

CPU_BIN="fluidanimate_cpu"
GPU_BIN="fluidanimate_gpu"
CMP_BIN="checkfiles"

CPU_SRC_CODE="./src/pthreads.cpp"
GPU_SRC_CODE="./src/cuda.cu"
CMP_SRC_CODE="./src/cmp.cpp"

mkdir -p $BINDIR

$CC $CPPFLAGS $CPU_SRC_CODE -o ./$BINDIR/$CPU_BIN

$NVCC $NVCCFLAGS $GPU_SRC_CODE -o ./$BINDIR/$GPU_BIN

$CC $CPPFLAGS $CMP_SRC_CODE -o ./$TOOLSDIR/$CMP_BIN
