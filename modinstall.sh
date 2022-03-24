#!/bin/bash
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 2
rm /etc/systemd/system/gear-node.service

echo "=================================================="
echo -e "\e[1m\e[32m6. Enter Gear Node name \e[0m"
read -p "Node Name : " NODE_NAME

echo -e "\e[1m\e[92m Node Name: \e[0m" $NODE_NAME

echo "=================================================="

echo -e "\e[1m\e[32m7. Creating service for Gear Node \e[0m"

echo "[Unit]
Description=Gear Node

[Service]
User=$USER
Type=simple
ExecStart=gear-node --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'  --name '$NODE_NAME'
Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target
" > $HOME/gear-node.service

sudo mv $HOME/gear-node.service /etc/systemd/system

echo "=================================================="

# Enabling services
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable gear-node.service

# Starting services
sudo systemctl restart gear-node.service
