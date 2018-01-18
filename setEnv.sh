#!/bin/bash - 


PORT=4848
HOST=das
PAYARA_VERSION=181
PAYARA_HOME=/opt/payara/server/$PAYARA_VERSION
NODE_HOME=$PAYARA_HOME/glassfish/nodes/
ASADMIN=$PAYARA_HOME/glassfish/bin/asadmin
RASADMIN="$ASADMIN --user admin --passwordfile=$PAYARA_HOME/pfile --port $PORT --host $HOST"
