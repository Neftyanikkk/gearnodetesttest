#!/bin/bash


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


sudo cp gear-node /root
systemctl daemon-reload
systemctl start gear-node
systemctl status gear-node

journalctl -n 100 -f -u gear-node
