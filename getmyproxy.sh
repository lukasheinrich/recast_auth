#!/bin/zsh
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh
scriptdir=$(dirname $0)

if ! type "voms-proxy-init" > /dev/null;then
localSetupEmi
fi
X509_USER_CERT=$scriptdir/host.cert X509_USER_KEY=$scriptdir/privkey.pem myproxy-logon -l lheinric -k recast_proxy -n --voms atlas
voms-proxy-info --all
