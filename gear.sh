#!/bin/bash
sudo apt install curl
curl -s https://raw.githubusercontent.com/cryptongithub/init/main/logo.sh | bash && sleep 2

echo -e "\e[1m\e[32m1. Installing required dependencies... \e[0m" && sleep 1
sudo apt update
sudo apt install curl git clang libssl-dev llvm libudev-dev -y
cd $HOME
rm -rf gear

echo "=================================================="

echo -e "\e[1m\e[32m2. Installing Rust... \e[0m" && sleep 1
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

echo "=================================================="

echo -e "\e[1m\e[32m3. Clone https://github.com/gear-tech/gear.git \e[0m" && sleep 1
git clone https://github.com/gear-tech/gear.git
cd gear

echo "=================================================="

echo -e "\e[1m\e[32m4. Compile... \e[0m" && sleep 1
cargo build -p gear-node --release

echo "=================================================="

echo -e "\e[1m\e[32m5. Copy node to /usr/bin/gear-node ... \e[0m" && sleep 1
sudo rm -rf /usr/bin/gear-node
sudo cp $HOME/gear/target/release/gear-node /usr/bin/gear-node 

echo "=================================================="
echo -e "\e[1m\e[32m6. Enter Gear Node name \e[0m"
read -p "Node Name : " NODE_NAME

echo -e "\e[1m\e[92m Node Name: \e[0m" $NODE_NAME

echo "=================================================="

echo -e "\e[1m\e[32m7. Creating service for Gear Node \e[0m"

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
        --log runtime \
        --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=on-failure
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

echo "=================================================="

# Enabling services
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable gear-node.service

# Starting services
sudo systemctl restart gear-node.service

echo "=================================================="

echo -e "\e[1m\e[32mNode Started \e[0m"

