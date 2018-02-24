#!/usr/bin/env bash

readlink_bin="${READLINK_PATH:-readlink}"
if ! "${readlink_bin}" -f test &> /dev/null; then
  __DIR__="$(dirname "$("${readlink_bin}" "${0}")")"
else
  __DIR__="$(dirname "$("${readlink_bin}" -f "${0}")")"
fi

# required libs
source "${__DIR__}/.bash/functions.shlib"

set -E
trap 'throw_exception' ERR

required_roles=(
  NINEJKH.libre2
  NINEJKH.git
  NINEJKH.ruby
  lifeofguenter.nodejs
  lifeofguenter.nginx
)

usage() {
cat <<EOF
Usage: ${0##*/} OPTIONS
test role

    -h            display this help and exit
    -i STRING     target host to run against (default: 127.0.0.1)
    -P STRING     path to playbook
    -T            turbo mode
    -u STRING     connect as this user (default: current user)
EOF
}

OPTIND=1
while getopts "hi:P:Tu:" opt; do
  case "${opt}" in
    h )
      usage
      exit 0
      ;;
    i )
      TARGET_HOST="${OPTARG}"
      ;;
    P )
      PLAYBOOK_FILE="${OPTARG}"
      ;;
    T )
      TURBO_MODE=1
      ;;
    u )
      CONNECT_USER="${OPTARG}"
      ;;
    '?' )
      usage >&2
      exit 1
      ;;
  esac
done
shift "$((OPTIND-1))"

ansible_playbook_args=()

if [[ ! -z "${TRAVIS}" ]]; then
  unset GEM_HOME
  unset GEM_PATH
  unset GOROOT

  ansible_playbook_args+=( "--syntax-check" )
fi

if [[ -z "${TARGET_HOST}" ]]; then
  TARGET_HOST="127.0.0.1"
  CONNECTION="local"
fi

if [[ -z "${CONNECT_USER}" ]]; then
  CONNECT_USER="$(whoami)"
fi

if [[ -z "${CONNECTION}" ]]; then
  CONNECTION="smart"
fi

if [[ -z "${PLAYBOOK_FILE}" ]]; then
  PLAYBOOK_FILE="${__DIR__}/tests/test.yml"
fi

role_root="$(pwd)"

if [[ -z "${TURBO_MODE}" ]] || [[ ! -d .roles ]]; then
  consolelog "installing requirements"
  for required_role in  "${required_roles[@]}"; do
    ansible-galaxy install "${required_role}"
  done
fi

consolelog "running role as playbook #1"
ansible-playbook \
  --inventory="${TARGET_HOST}," \
  --user="${CONNECT_USER}" \
  --extra-vars="role_root=${role_root}" \
  --connection="${CONNECTION}" \
  "${ansible_playbook_args[@]}" \
  "${PLAYBOOK_FILE}"

if [[ -z "${TURBO_MODE}" ]]; then
  consolelog "running role as playbook #2"
  ansible-playbook \
    --inventory="${TARGET_HOST}," \
    --user="${CONNECT_USER}" \
    --extra-vars="role_root=${role_root}" \
    --connection="${CONNECTION}" \
    "${ansible_playbook_args[@]}" \
    "${PLAYBOOK_FILE}"
fi

if [[ "${CONNECTION}" == "local" ]] && [[ -z "${TRAVIS}" ]]; then
  echo "127.0.0.1 gitlab" | sudo tee -a /etc/hosts
  curl -if http://gitlab

  cd /home/git/gitlab
  sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
  sudo -u git -H bundle exec rake gitlab:check RAILS_ENV=production
fi
