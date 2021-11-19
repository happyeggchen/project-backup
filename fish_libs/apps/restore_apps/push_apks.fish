function push_apks -d "install apks"
  for apk in (ls backup_dir/apks)
    adb install $apk
  end
end
