# Help command output
usage(){
echo "\
${MBIN} [OPTION]
-e,   project:apps; project repo name and apps.
-c; copy additional files in target repo.
-V; enable verbose mode
    --init; create new apps configs.
    --plan; clone source and destination repo.
    --build; build project for deployment.
    --sync; sync code from source repo to target repo.
    --create; create new github repo.
    --delete; delete github repo(pending).
-t; test binary files.
-r; to provide release version.
-h, --help; display this help
-v, --version; display version
" | column -t -s ";"
exit 1
}

# Error message
error(){
    echo "${MBIN}: invalid option -- '$1'";
    echo "Try '${MBIN} -h' for more information.";
    exit 1;
}


# Parse command-line options
get_cli_args(){
# Option strings
SHORT=cibtrhvVe:
LONG=init,plan,build,sync,help,version,repo:,create,delete
# read the options
OPTS=$(getopt --options $SHORT --long $LONG --name "$0" -- "$@")
if [ $? != 0 ] ; then echo "Failed to parse options...exiting." >&2 ; exit 1 ; fi
eval set -- "$OPTS"

# extract options and their arguments into variables.
while true ; do
  case "$1" in
    -e )
      project_name=${2/:*/}
      mini_app=${2/*:/}
      export PROJECT_NAME=${project_name,,}
      export APP_NAME=${mini_app,,}
      shift 2
      ;;
    --init|--plan|--build|--sync)
      MODE="${1//--/}"
      shift ;;
    --create|--delete)
      manage_git "${1//--/}"
      shift ;;
    -c )
      SYNC_FILES="true"
      shift
      ;;
    -t )
      TEST_ENCRYPTED_FILE="true"
      shift
      ;;
    -r )
      CREATE_RELEASE="true"
      shift
      ;;
    --repo )
      REPO_NAME="$2"
      shift 2
      ;;
    -h | --help )
      usage
      shift
      ;;
    -v | --version )
      echo "v1.3.0"
      shift
      ;;

    -V )
      verbose=true
      shift
      ;;
    -- )
      shift
      break
      ;;
    *)
      error
      ;;
  esac
done
}
