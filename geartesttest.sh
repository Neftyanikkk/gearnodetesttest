#!/bin/bash
set -e
sudo apt update && sudo apt upgrade -y
sudo apt-get install dos2unix
sudo apt install -y git clang curl libssl-dev llvm libudev-dev
sudo apt-get install nano
sudo apt install cargo
curl https://sh.rustup.rs -sSf | sh

figlet Welcome
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 1
echo "You have run the Crypton Academy Gear node setup script "

#установка

source ~/.cargo/env

rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

wget https://builds.gear.rs/gear-nightly-linux-x86_64.tar.xz && \
tar xvf gear-nightly-linux-x86_64.tar.xz && \
rm gear-nightly-linux-x86_64.tar.xz && \
chmod +x $HOME/gear-node

cargo build --release
   Compiling gear-node v0.1.0 (/root/gear-node)
    Building [=======================> ] 928/930: gear-node



#сервисник

echo -e "Please enter your node name: "
read nodename


echo "[+] Creating service gear-node"

sudo tee <<EOF >/dev/null /etc/systemd/system/gear-node.service

[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear-node \
        --name $nodename \
        --execution wasm \
        --log runtime
Restart=always
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target

EOF

echo "Install complete! "





sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable gear-node
sudo systemctl restart gear-node

sudo systemctl status gear-node


echo "Your node status =============>"
sudo journalctl -n 100 -f -u gear-node
