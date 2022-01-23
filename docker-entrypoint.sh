#!/bin/bash
/root/go/bin/pritunl-zero mongo ${MONGO_URI:-mongo:27017}
/root/go/bin/pritunl-zero set BastionDockerImage ${BASTION_IMAGE:-ghcr.io/yarons/pritunl-bastion}
/root/go/bin/pritunl-zero start
