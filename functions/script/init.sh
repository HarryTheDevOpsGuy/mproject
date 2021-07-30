
init_project(){
  mkdir -p ${PROJECT_CONFIG_DIR}/${PROJECT_NAME}
  if [[ ! -f ${PROJECT_CONFIG} ]]; then
    echo "#!/usr/bin/env bash
# This is your Project config file
SOURCE_REPO_NAME='msend'
SOURCE_REPO_URL='git@bitbucket.org:DevOps-Expert/msend.git'
#verbose=true

# Destination repo.
declare -A UTILITY_APPS=(
['msend']='git@github.com:harry41/msend.git'
['mcert']='git@github.com:HarryTheDevOpsGuy/mcert.git'
['mlog']='git@github.com:HarryTheDevOpsGuy/mlog.git'
['msysmon']='git@github.com:HarryTheDevOpsGuy/msysmon.git'
)" > ${PROJECT_CONFIG}
  fi
}
