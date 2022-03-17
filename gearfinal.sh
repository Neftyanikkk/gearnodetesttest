#!/bin/bash

curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 1
echo -e '\n\e[42mYour node name:'
read n
nodename=$n
git clone https://github.com/gear-tech/gear.git
cd gear
cargo build -p gear-node --release

cp /root/gear/target/release/gear-node /root/

sudo tee <<EOF >/dev/null /etc/systemd/system/gear-node.service
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear-node \
        --name $nodename \
        --execution wasm \
        --log runtime \
        --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=on-failure
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF



sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable gear-node
sudo systemctl restart gear-node

sudo systemctl status gear-node

sudo journalctl -n 100 -f -u gear-node

