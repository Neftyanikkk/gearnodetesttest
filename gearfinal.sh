#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git clang curl libssl-dev llvm libudev-dev

echo "Press 1 when the selection window appears"
curl https://sh.rustup.rs -sSf | sh
source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

#добавить названия ноды

wget https://builds.gear.rs/gear-nightly-linux-x86_64.tar.xz && \
tar xvf gear-nightly-linux-x86_64.tar.xz && \
rm gear-nightly-linux-x86_64.tar.xz && \
chmod +x $HOME/gear-node
cargo build -–release



tee <<EOF >/dev/null /etc/systemd/system/gear-node.service 
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear-node \
        --name gearnodecrypton \
        --execution wasm \
        --log runtime
Restart=on-failure
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
