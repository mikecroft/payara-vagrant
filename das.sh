#!/bin/bash - 

set -o nounset                              # Treat unset variables as an error

PORT=${1-4848}
HOST=${2-das}
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

startDomain() {
$ASADMIN start-domain domain1
}

enableSecureAdmin() {

# Set admin password

  curl  -X POST \
    -H 'X-Requested-By: payara' \
    -H "Accept: application/json" \
    -d id=admin \
    -d AS_ADMIN_PASSWORD= \
    -d AS_ADMIN_NEWPASSWORD=$PASSWORD \
    http://localhost:4848/management/domain/change-admin-password
    
 $RASADMIN enable-secure-admin
 $ASADMIN restart-domain domain1

}

createCluster() {

$RASADMIN create-cluster cluster
$RASADMIN create-node-config --nodehost node1 --installdir $PAYARA_HOME node1
$RASADMIN create-node-config --nodehost node2 --installdir $PAYARA_HOME node2

}

createInstance(){

$RASADMIN create-local-instance --cluster cluster i00
$RASADMIN create-local-instance --cluster cluster i01

$RASADMIN start-local-instance --sync  full i00
$RASADMIN start-local-instance --sync  full i01

}

createPasswordFile
startDomain
enableSecureAdmin
createCluster

# don't start instances on DAS because of memory issues
#createInstance
