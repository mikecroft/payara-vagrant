#!/bin/bash - 


PORT=4848
HOST=das
PAYA_HOME=/opt/payara/payara-4.1.153/payara41/
NODE_HOME=$PAYA_HOME/glassfish/nodes/
ASADMIN=$PAYA_HOME/glassfish/bin/asadmin
RASADMIN="$ASADMIN --user admin --passwordfile=$PAYA_HOME/pfile --port $PORT --host $HOST"
