#!/bin/bash
apt-get update 
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get install git curl build-essential -y
sudo apt install llvm clang
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 1
cd
git clone https://github.com/gear-tech/gear.git
cd gear/node
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
        --name gear-node \
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
