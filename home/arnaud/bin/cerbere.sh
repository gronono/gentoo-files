#!/bin/bash

script=$(basename "$0")

function usage() {
cat <<-EOF
Usage: ${script} [h] --client=<client> --backend=<backend> --redirect=<redirect>
  --backend  URL du backend ex: http://localhost:7372
  --client   client_id dans Gemini
  --redirect URL de redirection ex: http://localhost:4200

EOF
}

function parse_args() {
  local OPTIND
  args=$(getopt -o h --long help,backend:,client:,redirect: -n "${script}" -- "$@")
  if [ $? != 0 ] ; then (>&2 usage); exit 1; fi
  eval set -- "$args"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -b|--backend)  backend="$2"; shift 2 ;;
      -c|--client)   client="$2"; shift 2 ;;
      -r|--redirect) redirect="$2"; shift 2 ;;
      -h|--help)     usage; exit 0 ;;
      --) break ;;
      *) (>&2 echo "Unknow argument $1"; usage); exit 1 ;;
    esac
  done
	
  if [[ -z "${backend}" || -z "${client}" || -z "${redirect}" ]]; then
    (>&2 echo "Missing arguments"; usage); exit 1
  fi
}

function get_code() {
  xdg-open "https://gemini.shadow-dmz.gnc/authorize?response_type=code&client_id=${client}&redirect_uri=${redirect}"
  read -p "Code ? " code
}

function authentificate() {
  echo "Authentification..."
  token=$(curl -sS -X POST --data "{\"code\":\"${code}\",\"clientId\":\"${client}\", \"redirectUri\": \"${redirect}\"}" --header 'Content-Type: application/json' ${backend}/api/cerbere/auth/gemini | jq -r '.token')
  if [ $? != 0 ] ; then echo "Erreur lors de l'authentification"; exit 1; fi
}

function sample() {
  echo 'Exemple d'"'"'appel '"'"'curl -vv -H "Authorization: Bearer '"${token}"'" "'"${backend}"'/api/''"'
}

parse_args "$@"
get_code
authentificate
sample

