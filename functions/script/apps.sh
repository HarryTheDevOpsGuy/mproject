#
# deploy_tiny_apps(){
#   if [[ ${DEPLOY_TINY_APPS:-false} == true ]]; then
#     log_verbose "Starting tiny apps to build, commit and deploy"
#     for tiny_script in ${BINARY_FILES[@]}; do
#       TINY_APP_NAME="${tiny_script/#*\/}"
#       if [[ ${DEPLOY_TINY_APPS} == 'true'  ]]; then
#         TINY_REPO_URL="${UTILITY_APPS[$TINY_APP_NAME]}"
#         TINY_REPO_DIR="${TMP_DIR}/apps/${TINY_APP_NAME}"
#
#       fi
#
#       prepare_code "${TINY_REPO_DIR}" "${TINY_REPO_URL}" "${TINY_APP_NAME}"
#       encrypt_scripts "${tiny_script}" "${TINY_REPO_DIR}" "${TINY_REPO_DIR}"
#
#       if [[ -f ${SOURCE_REPO_DIR}/${tiny_script}.md ]]; then
#         cp -rf ${SOURCE_REPO_DIR}/${tiny_script}.md ${TINY_REPO_DIR}/README.md
#       fi
#
#       create_release_version "${TINY_REPO_DIR}" "${TINY_REPO_URL}"
#     done
#   fi
#
# }
