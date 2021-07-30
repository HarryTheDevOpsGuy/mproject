load_dynamic_vars(){
  export PROJECT_CONFIG="${PROJECT_CONFIG_DIR}/${PROJECT_NAME}/${PROJECT_NAME}.config"
  export DEFAULT_EXCLUDE_RULES="${PROJECT_CONFIG_DIR}/${PROJECT_NAME}/exclude_rules.txt"
  export INCLUDE_FILES="${PROJECT_CONFIG_DIR}/${PROJECT_NAME}/${APP_NAME}_files.txt"

  if [[ ! -z ${SOURCE_REPO_NAME} ]]; then
    export SOURCE_REPO_DIR="${TMP_DIR}/source/${SOURCE_REPO_NAME}"
  fi

  if [[ ${#UTILITY_APPS[@]} -gt 0 ]]; then
    export DEST_REPO_URL="${UTILITY_APPS[$APP_NAME]}"
    export DEST_REPO_DIR="${TMP_DIR}/dest/${APP_NAME}"
  fi

  if [[ -z ${DEST_REPO_URL} ]]; then
    log_error "Unable to get deploy repository ${#UTILITY_APPS[@]}|${DEST_REPO_DIR}"
    exit 1
  fi


  # if [[ ! -z ${DEST_REPO_NAME} ]]; then
  #   export DEST_REPO_DIR="${TMP_DIR}/dest/${DEST_REPO_NAME}"
  # fi


}
