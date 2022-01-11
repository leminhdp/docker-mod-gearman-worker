#!/bin/bash
# if [ -z "$HOSTGROUP" ]; then
	# echo "Variable HOSTGROUP not defined, please start your container with -e HOSTGROUP=SOMEHOSTGROUP"
	# exit 2
# fi
# if [ -z "$SERVER" ]; then
        # echo "Variable SERVER not defined, please start your container with -e SERVER=GEARMANSERVER:GEARMAN_PORT. hint: port is usually 4730"
        # exit 2
# fi

# #Changing defaults
# sed -i "s/identifier\=LB2/identifier\=$HOSTGROUP/" /etc/mod_gearman2/worker.conf
# sed -i "s/hostgroups\=LB2/hostgroups\=$HOSTGROUP/" /etc/mod_gearman2/worker.conf
# sed -i "s/server\=foobar/server\=$SERVER/" /etc/mod_gearman2/worker.conf

#Starting supervisord
#/usr/bin/supervisord
#service NRPE
#/bin/bash -c "/usr/sbin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -f"
/usr/bin/mod_gearman_worker --config=/etc/mod_gearman/worker.conf --pidfile=/var/mod_gearman/mod_gearman_worker.pid
