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
	echo "export APP_NAME=$1" > /tmp/bashrc_server
	cat $ZSH_CUSTOM/plugins/my-cnx/bashrc_server >> /tmp/bashrc_server
	scp /tmp/bashrc_server $host:~/.bashrc
	rm -f /tmp/bashrc_server
	ssh $host
}


