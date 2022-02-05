#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git clang curl libssl-dev llvm libudev-dev


 echo "Press 1 "
# Install
curl https://sh.rustup.rs -sSf | sh
# Configure
source ~/.cargo/env

rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

cd
git clone https://github.com/gear-tech/gear.git
cd gear/node
cargo build -–release


cd /etc/systemd/system

sudo tee <<EOF >/dev/null /etc/systemd/system/SERVICEGear.service
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
Restart=always
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF


sudo cp gear-node /root
systemctl daemon-reload
systemctl start gear-node
systemctl status gear-node


journalctl -n 100 -f -u gear-node
