exclude="ck\\.fs|pl\\.fs|sysmd5\\.zip|sd_after|install-recovery\\.sh|install_recovery\\.sh|recovery-from-boot\\.p|recovery_rootcheck|vendor/nvdata|vendor/nvcfg|vendor/persist|vendor/protect|vendor/euclid"
if [ "$#" -eq 3 ];then
pushd $3 2>&1 > /dev/null;
fi
if [ "$2" = "deep" ]; then
md5=`busybox find $1 -type f | sed 's/system_root\///g'| busybox grep -Ev $exclude | busybox sort | busybox xargs busybox md5sum | busybox md5sum | busybox cut -b  -32 `
else
md5=`busybox find $1 -type f | sed 's/system_root\///g' | busybox xargs busybox ls -l --color=never | busybox grep -Ev $exclude | busybox awk '{
print $5,$9}' | busybox sort | busybox md5sum | busybox cut -b -32`
fi
build_time=`cat system/build.prop  | busybox grep utc| busybox cut -b  19-`
echo "$build_time,$md5";

if [ "$#" -eq 3 ];then
popd 2>&1 > /dev/null;
fi
