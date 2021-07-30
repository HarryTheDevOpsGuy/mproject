
prepare_code(){
  target_repo_dir="${1}"
  target_repo_url="${2}"
  target_repo_name="${3}"


  if [[ ! -z ${SOURCE_REPO_URL} &&  ! -z ${SOURCE_REPO_NAME} ]]; then

    if [[ -f ${SOURCE_REPO_DIR}/.git/config ]]; then
      log_verbose "Fetching latest code from master branch" "${SOURCE_REPO_DIR}"
      cd ${SOURCE_REPO_DIR}
      git pull origin master
    else
      log_verbose "Cloning Source Repo in" "${SOURCE_REPO_DIR}"
      git clone ${SOURCE_REPO_URL} ${SOURCE_REPO_DIR}
    fi

  fi
  echo;
  #rm -rf ${target_repo_dir}
  if [[ ! -z ${target_repo_url} &&  ! -z ${target_repo_name} ]]; then
    if [[ -f ${target_repo_dir}/.git/config ]]; then
      log_verbose "Fetching latest code from master branch" "${target_repo_dir}"
      cd ${target_repo_dir}
      git pull origin master
    else
      log_verbose "Cloning Destination Repo in" "${target_repo_dir}"
      git clone ${target_repo_url} ${target_repo_dir}
      cd ${target_repo_dir}
      git config user.name "${GIT_USER}"
      git config user.email "${GIT_EMAIL}"
    fi
  fi
}

# ignore_sync(){
#   add_exclude="${1}"
#   check_exclude=$(grep "${add_exclude}" ${EXCLUDE_RULES:-$DEFAULT_EXCLUDE_RULES})
#   if [[ "${check_exclude}" != "${add_exclude}" ]]; then
#     log_alert "Adding file in exclude_rules" "${add_exclude}"
#     echo ${add_exclude} >> ${EXCLUDE_RULES:-$DEFAULT_EXCLUDE_RULES}
#   fi
# }

get_latest_release(){
  target_repo_dir="${1}"
# Create Release for new version
  if [[ -d ${target_repo_dir} ]]; then
    cd ${target_repo_dir}
    git fetch --tags
    export LATEST_TAG=$(git tag | sort -V | tail -1)
    if [[ ! -z ${LATEST_TAG} ]]; then
      RANDOM_NUM=$((1 + RANDOM % 10))
      NEW_TAG="${LATEST_TAG::-1}${RANDOM_NUM}"
      log_success "Most Recent Tag:" "${LATEST_TAG}"
      echo;

      if [[ ${CREATE_RELEASE} == true ]]; then
        echo "if you don't want to create tag/Release. Leave it blank"
        [ ! -z ${RELEASE_VERSION} ] || read -e -t 40 -p "Create New Tag/Release  : " -i ${NEW_TAG} RELEASE_VERSION
      fi

    else
      if [[ ${CREATE_RELEASE} == true ]]; then
        log_alert "Don't have any tag" "Create New one"
        read -e -t 40 -p "Create New Tag/Release  : " -i 'v0.0.1' RELEASE_VERSION
      fi
    fi

    export RELEASE_VERSION
  fi
}

encrypt_scripts(){
  SHELL_PATH="$1"
  target_repo_dir="${2}"

  if [[ -f $(command -v shc) && ! -z ${SOURCE_REPO_DIR} && ! -z ${target_repo_dir}  ]]; then
    filename=$(basename "${SOURCE_REPO_DIR}/${SHELL_PATH}")
    TMP_FILE="${TMP_DIR}/${filename}"
    export  TIMESTAMP=$(date +"%d-%b-%y")
    OUTPUT_FILE="${target_repo_dir}/$(uname -p)/${filename%.*}"
    mkdir -p $(dirname ${OUTPUT_FILE})

    sed 1d ${SOURCE_REPO_DIR}/${SHELL_PATH} | sed '1 i\#!/bin/bash' > ${TMP_FILE}

    get_latest_release ${target_repo_dir}
    if [[ -z ${RELEASE_VERSION} ]]; then
      sed -e 's|{Beta}|'"${LATEST_TAG}"'|g' \
          -e 's|{RELEASE_DATE}|'"${TIMESTAMP}"'|g' \
      -i ${TMP_FILE}
    else
      sed -e 's|{Beta}|'"${RELEASE_VERSION}"'|g' \
          -e 's|{RELEASE_DATE}|'"${TIMESTAMP}"'|g' \
      -i ${TMP_FILE}
    fi

    shc -r -f ${TMP_FILE} -o ${OUTPUT_FILE}
    ret_val=${?}

    if [[ -f ${OUTPUT_FILE} && ${ret_val} == '0' ]]; then
      log_success "File has been Encrypted Succesfully" "${filename}"
      if [[ ${TEST_ENCRYPTED_FILE} == true ]]; then
        log_alert "Checking Binary version" "${OUTPUT_FILE} -v"
        ${OUTPUT_FILE} -v
      fi
    else
       log_error "Something went wrong!!!"
    fi
  fi
}



# code_sync(){
#
# rsync -avz --exclude-from "${EXCLUDE_RULES:-$DEFAULT_EXCLUDE_RULES}" ${SOURCE_REPO_DIR}/ ${DEST_REPO_DIR}/
# }


code_build(){
  log_verbose "running ${FUNCNAME}."
  if [[ ${PROJECT_NAME} != ${APP_NAME} ]]; then
    MINI_PROJECT_DIR="tools"
    BIN_FILE="${MINI_PROJECT_DIR}/${APP_NAME}"
    README_FILE="${SOURCE_REPO_DIR}/${MINI_PROJECT_DIR}/${APP_NAME}.md"
  else
    BIN_FILE="${APP_NAME}"
    README_FILE="${SOURCE_REPO_DIR}/README.md"

  fi

  if [[ -f ${README_FILE} ]]; then
    cp -rf ${README_FILE} ${DEST_REPO_DIR}/README.md
  fi

  if [[ -f ${INCLUDE_FILES} && ${SYNC_FILES:-false} == true ]]; then
    while IFS=',' read source dest;
    do
      if [[ -f ${SOURCE_REPO_DIR}/${source} ]]; then
        log_success "${SOURCE_REPO_DIR}/${source}" "${DEST_REPO_DIR}/${dest}"
        echo "cp -rf ${SOURCE_REPO_DIR}/${source} ${DEST_REPO_DIR}/${dest}"
      fi

    done < ${INCLUDE_FILES}
  fi


  log_alert "Encrypting file" "${BIN_FILE}"
  encrypt_scripts "${BIN_FILE}" "${DEST_REPO_DIR}"




  #
  # if [[ ${#BINARY_FILES[@]} -gt 0 ]]; then
  #   for bin_file in ${BINARY_FILES[@]}; do
  #     log_alert "Encrypting file" "${bin_file}"
  #     #ignore_sync "${bin_file}"
  #     encrypt_scripts "${bin_file}" "${DEST_REPO_DIR}"
  #     #deploy_tiny_apps "${bin_file}"
  #   done
  # elif [[ ${#ENCRYPT_FILES[@]} -gt 0 && ${ENCRYPTION:-false} == "true" ]]; then
  #   for encrypt_file in ${ENCRYPT_FILES[@]}; do
  #     log_alert "Encrypting file" "${encrypt_file}"
  #     #ignore_sync "${encrypt_file}"
  #     encrypt_scripts "${encrypt_file}" "${DEST_REPO_DIR}"
  #   done
  # fi
  # #  code_sync

}


create_release_version(){
   target_repo_dir="${1}"
   target_repo_url="${2}"

   REPO_OWNER="${target_repo_url/#*:}"
   #REPO_OWNER=HarryTheDevOpsGuy/mcert
   REPO_OWNER=${REPO_OWNER%.*}
   APP_NAME="${REPO_OWNER/#*\/}"

   cd ${target_repo_dir}

    if [[ ${CREATE_RELEASE} == true ]]; then
      if [[ -z ${RELEASE_VERSION} ]]; then
        get_latest_release "${target_repo_dir}"
      fi

      if [[ ! -z ${RELEASE_VERSION} ]]; then
        sed -e 's|{RELEASE_VER}|'"${RELEASE_VERSION}"'|g' \
            -e 's|{RELEASE_DATE}|'"${TIMESTAMP}"'|g' \
            -e "s|harry41/mSend/raw|${REPO_OWNER}/raw|g" \
            -e "s|{REPO_OWNER}|${REPO_OWNER}|g" \
            -e "s|tools/${APP_NAME}|${APP_NAME}|g" \
            -i README.md
      fi

      RELEASE_COMMIT="Created New Release - Version ${RELEASE_VERSION}"
    else
      git checkout -- README.md
    fi

    if [[ -z ${RELEASE_COMMIT} ]]; then
      RELEASE_COMMIT="Code Sync from source repo"
    fi

    git status|tee ${TMP_DIR}/${PROJECT_NAME}.txt
    GIT_CHANGE=$(tail -1 ${TMP_DIR}/${PROJECT_NAME}.txt | awk -F',' '{print $1}')
    GIT_PUSH=$(awk -F'"' 'FNR==3 {print $2}' ${TMP_DIR}/${PROJECT_NAME}.txt)

    if [[ ${GIT_CHANGE} == 'nothing to commit' ]]; then
      log_success "Repository already up to date"
      exit 1
    fi


    echo;
    [ ! -z ${COMMIT_MSG} ] || read -e -p "Your commit message  : " -i "${RELEASE_COMMIT}" COMMIT_MSG
    git add -A
    git commit -m "${COMMIT_MSG:-$RELEASE_COMMIT}"
    if [[ ${CREATE_RELEASE} == 'true' && ! -z ${RELEASE_VERSION} ]]; then
      git tag -a -m "Version ${RELEASE_VERSION}, a bugfix release" ${RELEASE_VERSION}
    fi


    if [[ ${verbose} == "true" ]]; then
      git diff HEAD~1 HEAD
    else
      git diff --stat HEAD~1 HEAD
    fi

    [ ! -z ${CONF_YES} ] || read -e -t 180 -p "Are you ready to push this code into public repo : " -i "yes" CONF_YES
    if [[ ${CONF_YES} == "yes" ]]; then
      log_alert "Pushing code in" "${target_repo_url}"
       git push -u origin master --tags
    else
      log_alert "Nothing pushed into public repo" "${target_repo_url}"
    fi

    unset RELEASE_VERSION

}
