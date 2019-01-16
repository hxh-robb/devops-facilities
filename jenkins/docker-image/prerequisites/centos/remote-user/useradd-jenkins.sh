#!/usr/bin/env bash

## operator must be root
test "$USER" == "root" || echo "Super-user root is required"
test "$USER" == "root" || exit 1

jenkins_dot_ssh(){
  mkdir -p /home/jenkins/.ssh
  chmod 700 /home/jenkins/.ssh

  cp /root/jenkins.id_rsa.pub /home/jenkins/.ssh/authorized_keys
  chmod 600 /home/jenkins/.ssh/authorized_keys

  cp /root/jenkins.ssh.config /home/jenkins/.ssh/config
  chmod 644 /home/jenkins/.ssh/config
}

## check if jenkins user exists
if [ 1 == $(grep -c "^jenkins:" /etc/passwd) ]; then
  echo "User \"jenkins\" is already exists."
  jenkins_dot_ssh
  exit 0
fi

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"

echo "Creating user \"jenkins\""

adduser jenkins
if [ -n "$1" ] && [ -d "$1" ]; then
  cp -rf /home/jenkins "$1"/jenkins
  rm -rf /home/jenkins
  ln -s "$1"/jenkins /home/jenkins
fi

jenkins_dot_ssh

usermod -aG docker jenkins

chown -R jenkins:jenkins /home/jenkins
if [ -n "$1" ] && [ -d "$1" ]; then
  chown -R jenkins:jenkins "$1"/jenkins
  chcon -R unconfined_u:object_r:user_home_t:s0 "$1"/jenkins/.ssh
  chcon -R -t ssh_home_t "$1"/jenkins/.ssh
fi

echo "alias ll='ls -ahlF'" |sudo tee --append /home/jenkins/.bashrc > /dev/null

echo "User \"jenkins\" is created"
