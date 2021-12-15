#!/bin/sh

run_script() {
  for x in 6 7 8 9 10
  do
  VERSION=`curl -X GET "https://quay.io/api/v1/repository/openshift-release-dev/ocp-release/tag/?onlyActiveTags=true" | jq '.tags | sort_by(.start_ts) | .[].name'  | grep 4.$x | grep "ppc64le"  | grep -v multi | tail -1 |  tr -d '"'`
  if [ "$(cat versions/4.$x.txt)" != $VERSION ];
  then
  echo $VERSION > versions/4.$x.txt
  fi
  done
}


run_script
