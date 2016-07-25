for file in `nodemcu-tool fsinfo --json | tail -n +2 | jq .files[].name -r | grep .lc`
do
  echo "removing ${file}"
  nodemcu-tool remove ${file}
done
