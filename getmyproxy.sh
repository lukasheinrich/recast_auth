#!/bin/zsh
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh
scriptdir=$(dirname $0)

if ! type "voms-proxy-init" > /dev/null;then
localSetupEmi
fi
export X509_USER_CERT=$scriptdir/host.cert
export X509_USER_KEY=$scriptdir/privkey.pem

if [ ! $(stat --format=%a "$X509_USER_KEY") -eq 400 ];then
  echo "warning: permissions on private key: $X509_USER_KEY are not correct. should be 400";
fi
  

myproxy-logon -l lheinric -k "recast_$(hostname)" -n --voms atlas
voms-proxy-info --all
