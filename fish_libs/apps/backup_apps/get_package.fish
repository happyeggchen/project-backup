function get_package -d "get apks from device"
  adb_check
  backup_dir
  cd backup_dir/apks
  for apks in (adb shell pm list packages --user 0 -f)
    set apk_full_path (echo $apks | sed "s/^package://" | sed "s/base.apk=/base.apk /")
    set apk_path (echo $apk_full_path | awk 'BEGIN{FS=OFS=" ";} {print $1}')
    set apk_dist (echo $apk_full_path | awk 'BEGIN{FS=OFS=" ";} {print $2}')
    if echo $apk_path | grep -q /data/app
    adb pull $apk_path $apk_dist.apk
    end
  end
end
