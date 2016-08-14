#!/usr/bin/env bash
for file in `nodemcu-tool fsinfo --silent --json | tail -n +2 | jq .files[].name -r | grep *.lc`
do
  echo "removing ${file}"
  nodemcu-tool --silent remove ${file}
done
