#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git clang curl libssl-dev llvm libudev-dev
apt install make
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
