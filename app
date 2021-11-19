#!/usr/bin/env fish
function checkdependence
  if test -e $argv
    echo -e "\033[32m[checkdependence]check passed - $argv exist\033[0m"
  else
    echo -e "\033[0;31m[checkdependence]check failed - plz install $argv\033[0m"
    exit
  end
end
function checknetwork
  if curl -s -L $argv[1] | grep -q $argv[2]
    echo -e "\033[32m[checknetwork]check passed - u`ve connected to $argv[1]\033[0m"
  else
    echo -e "\033[0;31m[checknetwork]check failed - check your network connection\033[0m"
  end
end
function dir_exist
  if test -d $argv[1]
    echo -e "\033[32m[checkdir]check passed - dir $argv[1] exist\033[0m"
  else
    echo -e "\033[0;31m[checkdir]check failed - dir $argv[1] doesn't exist,going to makr one\033[0m"
    mkdir $argv[1]
  end
end
function list_menu
ls $argv | sed '\~//~d'
end
function help_echo
  echo "==========Help Documentation=========="
  set_color green
  echo "(./)app argv[1]"
  set_color normal
  echo " -argv[1]:the command to execute"
  echo "  -Available:"
  echo "======================================"
end
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
function push_apks -d "install apks"
  for apk in (ls backup_dir/apks)
    adb install $apk
  end
end
function adb_check -d "check if adb connected"
checkdependence /usr/bin/adb
if adb devices
else
  set_color red
  echo "$prefix adb went wrong,fix this manually"
  set_color normal
end
end
function backup_dir -d "description"
  mkdir -p backup_dir/apks
  mkdir -p backup_dir/data
end
set_color yellow
echo Build_Time_UTC=2021-11-19_18:12:32
set_color normal
set prefix "[project-backup]"
switch $argv[1]
case backup_apks
  get_package
case backup_data
  get_data
case backup_all
  get_package
  get_data
end
