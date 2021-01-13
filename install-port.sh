#!/usr/bin/env bash
set -euo pipefail

# Check
command -v port > /dev/null 2>&1 || { echo "I can't find the port command, exiting"; exit 1; }

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo /opt/local/bin/port install "$1";

exit 0
