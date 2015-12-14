#!/bin/bash - 

set -o nounset                              # Treat unset variables as an error

PORT=${1-4848}
HOST=${2-das}
PAYA_HOME=/opt/payara/payara-4.1.153/payara41/
NODE_HOME=$PAYA_HOME/glassfish/nodes/
ASADMIN=$PAYA_HOME/glassfish/bin/asadmin
RASADMIN="$ASADMIN --user admin --passwordfile=$PAYA_HOME/pfile --port $PORT --host $HOST"
PASSWORD=admin


createPasswordFile() {

cat << EOF > pfile
AS_ADMIN_PASSWORD=$PASSWORD
AS_ADMIN_SSHPASSWORD=payara
EOF

cp pfile $PAYA_HOME

}

createInstance(){

$RASADMIN create-local-instance --node node1 --cluster cluster i10
$RASADMIN create-local-instance --node node1 --cluster cluster i11

$RASADMIN start-local-instance --node node1 --nodedir $NODE_HOME --sync full i10
$RASADMIN start-local-instance --node node1 --nodedir $NODE_HOME --sync full i11

}

createPasswordFile
createInstance
