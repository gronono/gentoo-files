#!/bin/bash

ROOT_ID=0
PALO_ALTO_MOUNT=/mnt/palo_alto
RECIF_USER=arnaud.brunet
RECIF_DOMAIN=gnc.recif.nc
MOUNT_CREDENTIALS=/root/recif.passwd
CNTLM_CONF=/etc/cntlm.conf
CNTLM_PORT=3128
PROXY=proxy-web.proxy-dmz.gnc:3128
NO_PROXY=localhost,127.0.0.1,127.0.1.1,*.recif.nc,*.appli-gestion.nc,*.gnc,/var/run/docker.sock,10.10.106.0/24,*.valid-gouv.nc,*.gouv.nc,*.dmz.nc


if [ "$(id -u)" != "${ROOT_ID}" ]; then
	echo "Ce script doit être lancé en root" 1>&2
	exit 1
fi

echo "Nouveau mot de passe Recif:"
read -s password

echo "Démontage de ${PALO_ALTO_MOUNT}"
umount ${PALO_ALTO_MOUNT}
if [ $? -ne 0 ]; then
	echo "Impossible de démonter ${PALO_ALTO_MOUNT}" 1>&2
fi

echo "Génération du fichier ${MOUNT_CREDENTIALS}"
cat << EOF > ${MOUNT_CREDENTIALS}
username=${RECIF_USER}
password=${password}
EOF
chmod 600 ${MOUNT_CREDENTIALS}

echo "Remontage de ${PALO_ALTO_MOUNT}"
mount ${PALO_ALTO_MOUNT}
if [ $? -ne 0 ]; then
	echo "Impossible de remonter ${PALO_ALTO_MOUNT}" 1>&2
	exit 2
fi

echo "Génération du hash cntlm"
hash=$(echo ${password} | cntlm -u ${RECIF_USER} -H | grep -v Password)

echo "Génération de ${CNTLM_CONF}"
cat << EOF > ${CNTLM_CONF}
Username ${RECIF_USER}
Domain   ${RECIF_DOMAIN}
Proxy    ${PROXY}
NoProxy  ${NO_PROXY}
Listen   127.0.0.1:${CNTLM_PORT}
EOF
echo "${hash}" >> ${CNTLM_CONF}
chmod 600 ${CNTLM_CONF}

echo "Redemarrage du service cntlm"
/etc/init.d/cntlm restart

echo "Vérification PMU"
curl -s http://pmu.fr | grep ${RECIF_USER} > /dev/null
if [ $? -ne 0 ]; then
	echo "Le proxy devrait affiché une page d'erreur contenant votre nom"
	exit 3
fi

echo "Vérification JIRA"
curl -s http://jira.gouv.nc > /dev/null
if [ $? -ne 0 ]; then
	echo "Vous n'avez pas à JIRA !"
	exit 4
fi

echo "Configuration réussite"

