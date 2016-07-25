#!/usr/bin/env bash

echo
echo "Syncing.."
gulp

echo
echo "Rebooting.."
nodemcu-tool --silent run commands/reboot.lua terminal

echo
echo "Starting terminal"
nodemcu-tool --silent terminal
