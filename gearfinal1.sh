#!/bin/bash
apt-get update 
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get install git curl build-essential -y
sudo apt install llvm clang
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup toolchain add nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 1
git clone https://github.com/gear-tech/gear.git
cd gear
cargo build -p gear-node --release
wget -q -O /etc/systemd/system"/gear-node.service" "https://raw.githubusercontent.com/Zhoas/gearnodetesttest/main/gear-node.service"
sudo cp gear-node /root
systemctl daemon-reload
systemctl start gear-node
systemctl status gear-node
journalctl -n 100 -f -u gear-node
