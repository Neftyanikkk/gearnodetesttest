#!/bin/bash
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 2
rm /etc/systemd/system/gear-node.service

echo "=================================================="
echo -e "\e[1m\e[32m6. Enter Gear Node name \e[0m"
read -p "Node Name : " NODE_NAME

echo -e "\e[1m\e[92m Node Name: \e[0m" $NODE_NAME

echo "=================================================="

echo -e "\e[1m\e[32m7. Creating service for Gear Node \e[0m"

sudo tee <<EOF >/dev/null /etc/systemd/system/gear-node.service
[Unit]
Description=Gear Node
After=network.target
[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear-node \
        --name '$NODE_NAME' \
        --execution wasm \
        --log runtime \
        --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=on-failure
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

echo "=================================================="

# Enabling services
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable gear-node.service

# Starting services
sudo systemctl restart gear-node.service
