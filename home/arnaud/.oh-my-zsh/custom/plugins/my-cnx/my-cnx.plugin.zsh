# ssh raccourci pour le taf
cnx() {
	case $2 in
                integ)  dns=integ.gnc ;;
                qualif) dns=qualif.gnc ;;
                *)      dns=$2 ;;
        esac
	if [[ $1 == srv* ]];
	then
		host=$1.$dns
	else
	        host=$1-backend.$dns
	fi

	grep -rnw "${ZSH_CUSTOM}/plugins/my-cnx/autocomplete_list.txt" -e $1 > /dev/null 2>&1
	err=$?
	if [ $err != 0 ]; then
	    # ajout et tri du fichier
	    echo "Ajout Nouvelle Entree: ${1}";
	    echo "${1}" >> ${ZSH_CUSTOM}/plugins/my-cnx/autocomplete_list.txt;
	    sort -o ${ZSH_CUSTOM}/plugins/my-cnx/autocomplete_list.txt ${ZSH_CUSTOM}/plugins/my-cnx/autocomplete_list.txt
  	fi
	
	echo "export APP_NAME=$1" > /tmp/bashrc_server
	cat ${ZSH_CUSTOM}/plugins/my-cnx/bashrc_server >> /tmp/bashrc_server
	scp /tmp/bashrc_server $host:~/.bashrc
	rm -f /tmp/bashrc_server
	ssh $host
}

