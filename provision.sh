#!/bin/bash

##########################################
#
# Setting properties
#

# Payara Version
PAYARA_VERSION=4.174

# Payara directory
PAYARA_ROOT=/opt/payara/server
PAYARA_HOME=$PAYARA_ROOT/$PAYARA_VERSION


# Payara Edition URLs
case "$PAYARA_VERSION" in 
	4.174)
		FULL=https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+4.1.2.174/payara-4.1.2.174.zip
		WEB=https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+4.1.2.174/payara-web-4.1.2.174.zip
	;;
	4.181)
		FULL=   # Not released yet
		WEB=    # Not released yet
	;;
	5.181)
		FULL=   # Not released yet
		WEB=    # Not released yet
	;;
	4-NIGHTLY)
		# The below links are to the latest successful build
		FULL=https://s3-eu-west-1.amazonaws.com/payara.fish/payara-prerelease.zip
		WEB=https://s3-eu-west-1.amazonaws.com/payara.fish/payara-web-prerelease.zip
	;;
	5-NIGHTLY)
		# The below links are to the latest successful build
		FULL=https://s3-eu-west-1.amazonaws.com/payara.fish/payara-5-prerelease.zip
		WEB=https://s3-eu-west-1.amazonaws.com/payara.fish/payara-5-web-prerelease.zip
	;;
\*)
	echo "unknown version number"
esac

# Payara edition (Full, Web, Micro, etc., from above list)
PAYARA_ED=$FULL

#
#
##########################################


# Download and unzip to /opt/payara
installPayara() {
	echo "Provisioning Payara $PAYARA_VERSION $PAYARA_ED to $PAYARA_HOME"
	
	echo "running update..."
	sudo apt-get -qqy update                      # Update the repos 
	
	echo "installing openjdk and unzip"
	sudo apt-get -qqy install openjdk-8-jdk       # Install JDK 7 
	sudo apt-get -qqy install unzip               # Install unzip 
	
	echo "Downloading Payara $PAYARA_VERSION"
	wget -q $PAYARA_ED -O temp.zip > /dev/null    # Download Payara quietly
	sudo mkdir -p $PAYARA_ROOT                    # Make dirs for Payara 
	unzip -qq temp.zip -d $PAYARA_ROOT            # unzip Payara to dir 
	sudo chown -R vagrant:vagrant $PAYARA_ROOT    # Make sure vagrant owns dir 
	mv $PAYARA_ROOT/payara41 $PAYARA_HOME
}


# Copy startup script, and create service
installService() {
	echo "installing startup scripts"

	$PAYARA_HOME/bin/asadmin create-service --name payara_domain1 domain1
	$PAYARA_HOME/bin/asadmin create-service --name payara_payaradomain payaradomain
	
	echo "starting Payara..."
	
	# Explicitly start payaradomain by default
	sudo service /etc/init.d/GlassFish_payaradomain start 
}

installPayara
# installService

$PAYARA_HOME/bin/asadmin start-domain

