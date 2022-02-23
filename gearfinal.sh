#!/bin/bash

curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 1


sudo apt update && sudo apt upgrade -y
sudo apt install -y git clang curl libssl-dev llvm libudev-dev
apt install make
apt install cargo

rustup toolchain add nightly
rustup target add wasm32-unknown-unknown --toolchain nightly


git clone https://github.com/gear-tech/gear.git
cd gear
make node-release

sudo tee <<EOF >/dev/null /etc/systemd/system/gear-node.service
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart= /gear-node \
        --name gear-node \
        --execution wasm \
        --log runtime
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

