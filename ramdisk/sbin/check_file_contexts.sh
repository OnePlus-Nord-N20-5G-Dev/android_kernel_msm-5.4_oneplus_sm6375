#!/bin/sh
#check_file_contexts zip_path
zip_path="$1"
echo "input is [$zip_path]"
new_ctx_bin=/tmp/file_contexts_bin
cur_ctx_bin=/tmp/file_contexts_bin0
ctx_M=/file_contexts
busybox unzip -p "$zip_path" META-INF/com/android/file_contexts.bin  > $new_ctx_bin

if [[ -s $new_ctx_bin ]]; then
    #file_contexts has not .bin extension in system before Android 7.0
    if [[ -s $ctx_M ]]; then
        con_diff="cross Android version update, just do restorecon"
        rm -f /file_contexts
    else
        cp -f /file_contexts.bin $cur_ctx_bin
        con_diff=`busybox diff $new_ctx_bin $cur_ctx_bin`
    fi

    if [ x"$con_diff" = x ] ;then
        echo "no change in file_contexts"
    else
        echo "diff is $con_diff"
        busybox unzip -p "$zip_path" META-INF/com/android/file_contexts.bin > /file_contexts.bin
        restorecon -RF /data
    fi
fi
