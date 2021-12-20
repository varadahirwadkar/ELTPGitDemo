#!/bin/sh

run_script() {
  if [ ! -d "versions" ];
    then
        mkdir  "versions"
  fi

  for x in 6 7 8 9 10
  do
  VERSION=`curl -X GET "https://quay.io/api/v1/repository/vahirwad/ocp_builds/tag/?onlyActiveTags=true" | jq '.tags | sort_by(.start_ts) | .[].name'  | grep 4.$x | grep "ppc64le" | tail -1 |  tr -d '"'`
  if [ "$(cat versions/4.$x.txt)" != "$VERSION" ] && [ "$VERSION" != "" ];
  then
  echo $VERSION > versions/4.$x.txt
  fi
  done
}

setup_git() {
  git checkout -b master
  git config --global user.email "${GH_EMAIL}"
  git config --global user.name "${GH_NAME}"
}

commit_files() {
  git add . versions
  git commit --message "Update OCP versions"
}

upload_files() {
  git remote add origin-page https://${GH_TOKEN}@github.com/varadahirwadkar/ELTPGitDemo > /dev/null 2>&1
  git push --quiet --set-upstream origin-page master
}

run_script
setup_git
commit_files
upload_files
