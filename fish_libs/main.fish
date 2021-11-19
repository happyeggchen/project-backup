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
