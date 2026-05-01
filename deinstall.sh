#!/bin/sh
set -e

# Остановить Xray, если запущен
pkill -f "/xray/xray" || true

# Если успели сделать systemd-сервис — отключить и удалить
if [ -f /etc/systemd/system/xray.service ]; then
    systemctl stop xray || true
    systemctl disable xray || true
    rm -f /etc/systemd/system/xray.service
    systemctl daemon-reload
fi

# Удалить директорию со всем содержимым
rm -rf /xray

echo "Готово. Xray и все файлы удалены."