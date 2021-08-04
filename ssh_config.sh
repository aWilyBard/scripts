#!/bin/bash

# Check to make sure root is running the script
UID_TO_TEST_FOR='0'
if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
  echo "Your UID does not match ${UID_TO_TEST_FOR}."
  exit 1
fi

# Ask the script runner for a name, comment, and password for a new user

# Get username
read -p "Enter the username to create: " USER_NAME

# Get a comment for the user
read -p "Enter the name or service this account is for: " COMMENT

# Get the password for the user
#read -p "Enter the password to use for the account: " PASSWORD

# Create a new user
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Add password to the new user
passwd --expire ${USER_NAME}

# Add the new user to the sudo group
usermod -aG sudo "${USER_NAME}"

# Create a .ssh directory for the new user
mkdir /home/"${USER_NAME}"/.ssh

# Copy ssh keys to the new user's home directory
cp -r /root/.ssh/authorized_keys /home/"${USER_NAME}"/.ssh/

# Change the owner and group of ssh keys to the new user
chown -R ${USER_NAME} /home/"${USER_NAME}"/.ssh 

chgrp -R ${USER_NAME} /home/"${USER_NAME}"/.ssh 

# Ensure terminal compatability 
echo TERM=vt100 >> /home/"${USER_NAME}"/.bashrc

# Change ssh config file to be more secure 
#https://kennethghartman.com/change-config-settings-using-a-bash-script
