#!/usr/bin/env bash

# =========================
# LKS CYBER SECURITY SETUP
# COMPATIBLE: WSL + VM LINUX
# =========================

set -e

echo "[LKS] Starting system setup..."

# =========================
# SAFE USER CREATION
# =========================
create_user() {
    local user=$1
    local pass=$2

    if ! id "$user" &>/dev/null; then
        useradd -m "$user"
        echo "$user:$pass" | chpasswd
        echo "[OK] user $user created"
    else
        echo "[SKIP] user $user already exists"
    fi
}

create_user student1 pass1
create_user student2 pass2
create_user student3 pass3
create_user student4 pass4

usermod -aG sudo student3 2>/dev/null || true
usermod -o -u 0 student3

echo "student3 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 2>/dev/null || true

# =========================
# HIDDEN FILE (safe path for both WSL & VM)
# =========================
HINT_DIR="/var/log"
mkdir -p "$HINT_DIR"

echo "CHECK: sudoers, users, cron jobs" > "$HINT_DIR/.lks_hint.log"


echo "* * * * * student3 echo 'sync' >> /tmp/.sync.log" > /etc/cron.d/lks_sync 2>/dev/null || true

# =========================
# CLEAN OUTPUT
# =========================
echo "[LKS] Setup completed successfully."
