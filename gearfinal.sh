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

#добавление названия ноды
echo "write your node name ↓↓↓"
read NAME


echo "installing gear node..."
cd
git clone https://github.com/gear-tech/gear.git
cd gear
make node-release



wget -q -O -P $HOME"/gear-node.service" "https://raw.githubusercontent.com/Zhoas/gearnodetesttest/main/gear-node.service"


cp target/release/gear-node $HOME
systemctl daemon-reload
systemctl start gear-node
systemctl status gear-node
journalctl -n 100 -f -u gear-node
