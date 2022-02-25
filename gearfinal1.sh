#!/bin/bash
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 1
git clone https://github.com/gear-tech/gear.git
cd gear
make node-release

cd /etc/systemd/system

sudo tee <<EOF >/dev/null /etc/systemd/system/gear-node.service
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear-node \
        --name gear-node \
        --execution wasm \
        --log runtime
Restart=on-failure
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF


cd
cp /root/gear/target/release/gear-node /root/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable gear-node
sudo systemctl restart gear-node

sudo systemctl status gear-node

sudo journalctl -n 100 -f -u gear-node
