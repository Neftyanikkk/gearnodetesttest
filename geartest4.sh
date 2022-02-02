#!/bin/bash

echo -e '\e[40m\e[91m'
echo -e '  ____                  _                    '
echo -e ' / ___|_ __ _   _ _ __ | |_ ___  _ __        '
echo -e '| |   |  __| | | |  _ \| __/ _ \|  _ \       '
echo -e '| |___| |  | |_| | |_) | || (_) | | | |      '
echo -e ' \____|_|   \__  |  __/ \__\___/|_| |_|      '
echo -e '            |___/|_|                         '
echo -e '    _                 _                      '
echo -e '   / \   ___ __ _  __| | ___ _ __ ___  _   _ '
echo -e '  / _ \ / __/ _  |/ _  |/ _ \  _   _ \| | | |'
echo -e ' / ___ \ (_| (_| | (_| |  __/ | | | | | |_| |'
echo -e '/_/   \_\___\__ _|\__ _|\___|_| |_| |_|\__  |'
echo -e '                                       |___/ '
echo -e '\e[0m'

su
sudo apt update
sudo apt install -y git clang curl libssl-dev llvm libudev-dev
curl https://sh.rustup.rs -sSf | sh

echo "Press 1"
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
touch gear-node.service
sudo nano gear-node.service



echo "[+] Creating service gear-node"

wget -q -O /etc/systemd/system"/gear.service" "https://raw.githubusercontent.com/Zhoas/gearnodetesttest/main/gear.service"

echo "Install complete! "


sudo cp gear-node /root
systemctl daemon-reload
systemctl start gear-node
systemctl status gear-node

journalctl -n 100 -f -u gear-node
