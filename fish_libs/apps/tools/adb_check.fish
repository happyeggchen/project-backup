function adb_check -d "check if adb connected"
checkdependence /usr/bin/adb
if adb devices
else
  set_color red
  echo "$prefix adb went wrong,fix this manually"
  set_color normal
end
end
