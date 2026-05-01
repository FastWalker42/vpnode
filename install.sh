#!/bin/sh
set -e

mkdir -p /xray && cd /xray

wget -O xray.zip "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"
python3 -c "import zipfile; zipfile.ZipFile('xray.zip').extractall()"
chmod +x xray

# Генерация ключей
./xray x25519 > keys.txt



# Генерация UUID
clients=$(python3 -c "import json, uuid; print(json.dumps([{'id': str(uuid.uuid4()), 'flow': 'xtls-rprx-vision'} for _ in range(10000)]))")
echo "Generated UUIDs: $clients"

cat > /xray/config.json << EOF
{
	"log": {
		"loglevel": "warning"
	},
	"inbounds": [
		{
			"port": 443,
			"protocol": "vless",
			"settings": {
				"clients": $clients,
				"decryption": "none"
			},
			"streamSettings": {
				"network": "tcp",
				"security": "reality",
				"realitySettings": {
					"show": false,
					"dest": "www.samsung.com:443",
					"xver": 0,
					"serverNames": ["www.samsung.com", "samsung.com"],
					"privateKey": "kGBWhXZMMfCklwbPxkr2lbyrWCchdf35iw-ZCbmdx1o",
					"shortIds": ["a1b2c3d4"],
					"spiderX": ""
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom",
			"tag": "direct"
		},
		{
			"protocol": "blackhole",
			"tag": "block"
		}
	],
	"routing": {
		"rules": [
			{
				"type": "field",
				"network": "udp",
				"port": 443,
				"outboundTag": "block"
			}
		]
	}
}
EOF