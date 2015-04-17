#!/bin/zsh

##
# This is a script that configures a recast plugin host
# so that it has the necessary authentication settings
# to access resources it needs
# currently we have thee access needs:
#   - SVN access to atlas repositories
#   - Grid access
#   - access to the central RECAST node
##

# exit on any error
set -e

#create .ssh directory if needed
mkdir -p ~/.ssh


###
#   KERBEROS FOR CODE ACCESS (SVN)
###
# for kerberos access use my personal 
# credential and forward kerberos authentication
# enables passwordless checkout of code

cat << EOF >> ~/.ssh/config
Host svn.cern.ch
	User lheinric
	GSSAPIAuthentication yes
	GSSAPIDelegateCredentials yes
EOF

#make sure permissions are correct
chmod 600 ~/.ssh/config

###
#   ACCESS TO MAIN RECAST NODE
###

# remove the host key for recast-demo from the known host file
if [ -e ~/.ssh/known_hosts ];then
	ssh-keygen -R recast-demo
fi

# add a fresh host key

ssh-keyscan -t rsa recast-demo >> ~/.ssh/known_hosts


###
#   GRID ACCESS
###

# create a host certificate signing request and private key

openssl req -new -subj "/CN=$(hostname)" -out newcsr.csr -nodes -sha512 -newkey rsa:2048

# quoting alex pearce https://alexpearce.me/2014/10/setting-up-flask-with-apache-and-shibboleth/
# This will create two files, newcsr.csr and privkey.pem. The former
# is the certificate signing request, which you need to copy the contents
# of in to the field on the host certificate request form, and the latter
# is the private key. The private key should be kept secret, as it is the
# proof that the server is who it says it is.