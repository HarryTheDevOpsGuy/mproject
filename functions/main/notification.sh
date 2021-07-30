
# All kind of the log informations variables.
log_info() {
  local description="${1}"
  local color="${2:-$NC}"
  echo -e "${color}INFO :: ${description}${NC}"
}

log_error () {
local msg=$1
echo -e "${RED} ${msg} ${NC} ${2}"
}

log_warning () {
local msg=$1
echo -e "${YELLOW} ${msg} ${NC} ${2}"
}

log_success () {
local msg=$1
echo -e "${GREEN} ${msg} ${NC} ${2}"
}

log_alert () {
local msg=$1
echo -e "${YELLOW} ${msg} ${NC} ${2}"
}

log_verbose () {
  if [[ ${verbose} == true ]]; then
    local msg=$1
    echo -e "${YELLOW} ${msg} ${NC} ${2}"
  fi
}
