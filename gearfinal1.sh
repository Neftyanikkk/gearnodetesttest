#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git clang curl libssl-dev llvm libudev-dev
apt install make
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup toolchain add nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
git clone https://github.com/gear-tech/gear.git
cd gear
make node-release

./gear-node
systemctl status gear-node
journalctl -n 100 -f -u gear-node
