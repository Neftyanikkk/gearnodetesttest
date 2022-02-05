#!/bin/bash
su
sudo apt update && sudo apt upgrade -y
sudo apt install -y git clang curl libssl-dev llvm libudev-dev


curl https://sh.rustup.rs -sSf | sh
source ~/.cargo/env


rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

#добавление названия ноды
echo "write your node name ↓↓↓"
read NAME


echo "installing gear node..."
wget https://builds.gear.rs/gear-nightly-linux-x86_64.tar.xz && \
tar xvf gear-nightly-linux-x86_64.tar.xz && \
rm gear-nightly-linux-x86_64.tar.xz && \
chmod +x $HOME/gear-node

cargo build --release
   Compiling gear-node v0.1.0 (/root/gear-node)
    Building [=======================> ] 928/930: gear-node
    
    

    tee <<EOF >/dev/null /etc/systemd/system/$NAME.service
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear-node -name papadritta -execution wasm -log runtime
Restart=always
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target

EOF



systemctl daemon-reload
systemctl enable minima_$PORT
systemctl start minima_$PORT
