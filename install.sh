#!/bin/bash

folder="$(dirname $0)"
. $folder/config.sh
#
# Install Java
#
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get -y install oracle-java7-installer

#
# Install tomcat7, maven and git
#
#INSTALL_LIST="tomcat7 maven git"
INSTALL_LIST="tomcat7 maven"
apt-get -y install $INSTALL_LIST

sed -i -e "s/#JAVA_HOME.*/JAVA_HOME=\/usr\/lib\/jvm\/java-7-oracle/g" "/etc/default/tomcat7"
sleep 2
service tomcat7 restart

# 
# Original Source:
# git clone https://github.com/UniconLabs/simple-cas4-overlay-template.git
# 
mkdir /etc/cas
chown tomcat7:adm -R /etc/cas
cp $folder/simple-cas4-overlay-template/etc/* /etc/cas
echo $LDAP_SERVER ldapserver | sudo tee -a /etc/hosts
mvn clean package -f $folder/simple-cas4-overlay-template/pom.xml
cp $folder/simple-cas4-overlay-template/target/cas.war /var/lib/tomcat7/webapps/cas.war
