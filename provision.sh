#!/bin/bash

##########################################
#
# Setting properties
#

# Payara Version
PAYARA_VERSION=4.1.153

# Payara directory
PAYARA_HOME=/opt/payara/payara-$PAYARA_VERSION


# Payara Edition URLs
case "$PAYARA_VERSION" in 
	4.1.151)
		FULL=http://bit.ly/1CGCtI9
		WEB=http://bit.ly/1DmWTUY
		MINIMAL=http://bit.ly/163XP6f
		EMBEDDED_FULL=http://bit.ly/1zG59ls
		EMBEDDED_WEB=http://bit.ly/1KdVP87
		EMBEDDED_NUCLEUS=http://bit.ly/1ydQTKw
		MULTI_LANGUAGE_FULL=https://bit.ly/1zv1YeB
		MULTI_LANGUAGE_WEB=https://bit.ly/1wVXaZ
	;;
	4.1.152)
		# The below links are to 4.1.152 Patch 1
		FULL=http://bit.ly/1czs5bH
		WEB=http://bit.ly/1A2mXrq
		MINIMAL=http://bit.ly/1ICWv9p
		MICRO=http://bit.ly/1EFXzEA
		EMBEDDED_FULL=http://bit.ly/1A21MpQ
		EMBEDDED_WEB=http://bit.ly/1KMzD61
		MULTI_LANGUAGE_FULL=http://bit.ly/1H4SrdQ
		MULTI_LANGUAGE_WEB=http://bit.ly/1G8NKnd
	;;
	4.1.153)
		# The below links are to 4.1.153
		FULL=http://bit.ly/1I4tz9r
		WEB=http://bit.ly/1IaXo67
		MINIMAL=http://bit.ly/1OQGy0K
		MICRO=http://bit.ly/1JTP36N
		EMBEDDED_FULL=http://bit.ly/1h7MeZ6
		EMBEDDED_WEB=http://bit.ly/1DS74QT
		MULTI_LANGUAGE_FULL=http://bit.ly/1Sk4NKm
		MULTI_LANGUAGE_WEB=http://bit.ly/1H6pcXw
	;;
	PRE-RELEASE)
		# The below links are to the latest successful build
		FULL=http://payara.co.s3-website-eu-west-1.amazonaws.com/payara-prerelease.zip
		WEB=http://payara.co.s3-website-eu-west-1.amazonaws.com/payara-web-prerelease.zip
		MINIMAL=http://payara.co.s3-website-eu-west-1.amazonaws.com/payara-minimal-prerelease.zip
		MICRO=https://s3-eu-west-1.amazonaws.com/payara.co/payara-micro-prerelease.jar
		EMBEDDED_FULL=http://payara.co.s3-website-eu-west-1.amazonaws.com/payara-embedded-all-prerelease.jar
		EMBEDDED_WEB=http://payara.co.s3-website-eu-west-1.amazonaws.com/payara-embedded-web-prerelease.jar
		MULTI_LANGUAGE_FULL=https://s3-eu-west-1.amazonaws.com/payara.co/payara-ml-prerelease.zip
		MULTI_LANGUAGE_WEB=https://s3-eu-west-1.amazonaws.com/payara.co/payara-web-ml-prerelease.zip
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
	echo "Provisioning Payara-$PAYARA_VERSION $PAYARA_ED to $PAYARA_HOME"
	
	echo "running update..."
	sudo apt-get -qqy update                      # Update the repos 
	
	echo "installing openjdk and unzip"
	sudo apt-get -qqy install openjdk-7-jdk       # Install JDK 7 
	sudo apt-get -qqy install unzip               # Install unzip 
	
	echo "Downloading Payara $PAYARA_VERSION"
	wget -q $PAYARA_ED -O temp.zip > /dev/null    # Download Payara 
	sudo mkdir -p $PAYARA_HOME                    # Make dirs for Payara 
	unzip -qq temp.zip -d $PAYARA_HOME            # unzip Payara to dir 
	sudo chown -R vagrant:vagrant $PAYARA_HOME    # Make sure vagrant owns dir 
}


# Copy startup script, and create service
installService() {
	echo "installing startup scripts"
	mkdir -p $PAYARA_HOME/startup                    # Make dirs for Payara 
	cp /vagrant/payara_service-$PAYARA_VERSION $PAYARA_HOME/startup/ 
	chmod +x $PAYARA_HOME/startup/payara_service-$PAYARA_VERSION
	ln -s $PAYARA_HOME/startup/payara_service-$PAYARA_VERSION /etc/init.d/payara 
	
	echo "Adding payara system startup..."
	sudo update-rc.d payara defaults > /dev/null 
	
	echo "starting Payara..."
	
	# Explicitly start payaradomain by default
	case "$PAYARA_VERSION" in
		4.1.151)
			su - vagrant -c 'service payara start domain1'
			;;
		4.1.152)
			su - vagrant -c 'service payara start payaradomain'
			;;
		4.1.153)
			su - vagrant -c 'service payara start payaradomain'
			;;
		PRE-RELEASE)
			su - vagrant -c 'service payara start payaradomain'
			;;
		/*)
			echo "Unknown Payara version, attempting to start domain1..."
			su - vagrant -c 'service payara start domain1'
	esac
}

installPayara

if [ $PAYARA_ED = $WEB                 ] ||
   [ $PAYARA_ED = $FULL                ] ||
   [ $PAYARA_ED = $MULTI_LANGUAGE_FULL ] ||
   [ $PAYARA_ED = $MULTI_LANGUAGE_WEB  ]; then
	installService
fi
