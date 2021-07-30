
create_github_repo(){
    REPO_NAME="$1"
    log_success "Repo Name : ${REPO_NAME}" "Action : Create New Repo"
    [ ! -z ${CONF_REPO} ]||read -e -t 180 -p "Would you like to create new repo : " -i "yes" CONF_REPO
    if [[ ${CONF_REPO} == yes ]]; then
      curl -H "Authorization: token ${GHKEY}" https://api.github.com/user/repos -d "{\"name\":\"${REPO_NAME}\"}"
    fi
    exit 1

}

manage_git(){
  case ${1} in
    create )
      create_github_repo "${REPO_NAME}"
      ;;
    delete )
      echo "delete_github_repo ${REPO_NAME}"
      ;;
  esac
}
