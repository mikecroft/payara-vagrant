#!/bin/bash - 

set -o nounset                              # Treat unset variables as an error

PORT=${1-4848}
HOST=${2-node2}
PAYARA_VERSION=4.174
PAYARA_ROOT=/opt/payara/server
PAYARA_HOME=$PAYARA_ROOT/$PAYARA_VERSION
NODE_HOME=$PAYARA_HOME/glassfish/nodes/
ASADMIN=$PAYARA_HOME/glassfish/bin/asadmin
RASADMIN="$ASADMIN --user admin --passwordfile=$PAYARA_HOME/pfile --port $PORT --host $HOST"
PASSWORD=admin


createPasswordFile() {

cat << EOF > pfile
AS_ADMIN_PASSWORD=$PASSWORD
AS_ADMIN_SSHPASSWORD=payara
EOF

cp pfile $PAYARA_HOME

}

createInstance(){

$RASADMIN create-local-instance --node node2 --cluster cluster i20
$RASADMIN create-local-instance --node node2 --cluster cluster i21

$RASADMIN start-local-instance --node node2 --nodedir $NODE_HOME --sync full i20
$RASADMIN start-local-instance --node node2 --nodedir $NODE_HOME --sync full i21

}

mkdir -p $NODE_HOME
createPasswordFile
createInstance

