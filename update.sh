#!/usr/bin/env bash
set -eou pipefail

# Structure taken from the old saveosx script

# selfupdate etc
go() {
  echo "UPDATING ==>"
  saferun sudo port -v selfupdate &&
  echo "UPGRADING ==>"
  saferun sudo port -Rv upgrade outdated &&
  echo "CLEANING ==>"
  saferun sudo port -v clean installed &&
  while [[ -n $(port echo leaves inactive) ]]
  do
    echo "REMOVING LEAVES ==>"
    saferun sudo port -v uninstall leaves inactive
  done
  echo "RECLAIMING ==>"
  saferun sudo port -v reclaim -d &&
  echo "REV-UPGRADING ==>"
  saferun sudo port -v rev-upgrade
}

# Sanity checks
sanity() {
    # Ensure the user is running this script on OS X
  if [ $(uname -s) != "Darwin" ]; then
	  echo "This script is for use with OS X!"
	  exit 1
  fi

  command -v port > /dev/null 2>&1 || { echo "I can't find the port command, exiting"; exit 1; }
}

# Safe run function to ensure commands are executed successfully
saferun() {
    typeset cmnd="$*"
    typeset ret_code

    eval  $cmnd
    ret_code=$?
    
    if [ $ret_code != 0 ]; then
	   echo -e "It looks like there was an issue running: $*\n\nExiting..."
	   exit $?
    fi
}

main() {
	sanity
	go
}

# Actual run
main $@
