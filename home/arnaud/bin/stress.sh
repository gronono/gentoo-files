#! /bin/bash

#
# Permet de lancer un petit stress sur une URL spécifique
# Inspiré de
# http://servermonitoringhq.com/blog/how_to_quickly_stress_test_a_web_server
#

#
# Variables globales
#
# Valeurs par défaut des options facultatives
SEQ=10
PROCESS=10
# Nom du script
SCRIPT=$(basename "$0")
# Liste des PIDs des process CURL lancé en parrallèle
PIDLIST=""
# Nombre de process CURL en erreur
FAIL="0"

usage() {
cat <<-EOF
Usage: ${SCRIPT} [h] --url=<ulr> [--seq=<seq>] [--process=<process>]
  --url     url à tester
  --seq     Nombre de requêtes envoyés en squentiel par chaque process (defaut: 10)
  --process Nombre de process parrallèle lancé (defaut: 10)
EOF
}

parse_args() {
  local OPTIND
  args=$(getopt -o h --long help,url:,seq:,process: -n "${SCRIPT}" -- "$@")
  if [ $? != 0 ] ; then (>&2 usage); exit 1; fi
  eval set -- "$args"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -u|--url)     URL="$2"; shift 2 ;;
      -s|--seq)     SEQ="$2"; shift 2 ;;
      -p|--process) PROCESS="$2"; shift 2 ;;
      -h|--help)    usage; exit 0 ;;
      --) break ;;
      *) (>&2 echo "Unknow argument $1"; usage); exit 1 ;;
    esac
  done

  if [[ -z "${URL}" ]]; then
    (>&2 echo "Missing arguments"; usage); exit 1
  fi
}

# URL doit finir par ? ou & suivant s'il y a des query-params ou pas
normalize_URL() {
  if [[ ${URL} != *"?"* ]]; then
    URL="${URL}?"
  else
    URL="${URL}&"
  fi
}

stress() {
  for i in $(seq 1 "${PROCESS}")
  do
    curl --silent --fail --output /dev/null "${URL}[1-$SEQ]" &
    PIDLIST="${PIDLIST} $!"
  done
}

# Attend que les process se finissent
waiting() {
  for job in ${PIDLIST}
  do
    echo "Waiting process ${job}"
    if ! wait "${job}"; then
      FAIL=$((FAIL + 1))
    fi
  done
}

result() {
  if [ "${FAIL}" == "0" ]; then
    echo "YAY!"
    exit 0
  else
    echo "FAIL! (${FAIL})"
    exit ${FAIL}
  fi
}

#
# Main
#
parse_args "$@"
normalize_URL
stress
waiting
result
