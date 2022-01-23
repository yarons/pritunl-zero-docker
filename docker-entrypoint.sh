#!/bin/ash
/root/go/bin/pritunl-zero mongo ${MONGO_URI:-mongodb://mongo:27017/pritunl-zero}
/root/go/bin/pritunl-zero set system bastion_docker_image \"${BASTION_IMAGE:-ghcr.io/yarons/pritunl-bastion}\"
/root/go/bin/pritunl-zero start