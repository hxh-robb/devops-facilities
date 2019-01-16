#!/bin/bash

sudo userdel -r jenkins 2>/dev/null
sudo rm /home/jenkins
sudo rm -rf /sme/jenkins
sudo rm -rf /var/spool/mail/jenkins
