#!/bin/bash
sudo apt update 
sudo apt install curl -y && apt install jq -y
clear
if git > /dev/null 2>&1; then
	echo ''
else
  sudo apt install git
  echo 'Гит установлен'
fi
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 3

if docker > /dev/null 2>&1; then
	echo ''
else
  curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
fi

echo "=+=+=+=+=+=++=+=++=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+="
