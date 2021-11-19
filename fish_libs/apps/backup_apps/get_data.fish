function get_data -d "description"
  adb_check
  backup_dir
  cd backup_dir/data
  for apks in (adb shell pm list packages --user 0 -f)
    set apk_full_path (echo $apks | sed "s/^package://" | sed "s/base.apk=/base.apk /")
    set apk_path (echo $apk_full_path | awk 'BEGIN{FS=OFS=" ";} {print $1}')
    set apk_dist (echo $apk_full_path | awk 'BEGIN{FS=OFS=" ";} {print $2}')
    if echo $apk_path | grep -q /data/app
    adb pull (echo $apk_path | sed 's/\/data\/app/\/data\/data/g' | sed 's/base.apk//g')
    end
  end
end
