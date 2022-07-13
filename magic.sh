apt-get update
apt-get install ifupdown -y

cat > /etc/network/interfaces << 'EOF'
auto lo
iface lo inet loopback

auto ens32
iface ens32 inet dhcp

EOF

ifdown --force ens18 lo && ifup -a
systemctl unmask networking
systemctl enable networking
systemctl restart networking

systemctl stop systemd-networkd.socket systemd-networkd \
networkd-dispatcher systemd-networkd-wait-online

systemctl disable systemd-networkd.socket systemd-networkd \
networkd-dispatcher systemd-networkd-wait-online

systemctl mask systemd-networkd.socket systemd-networkd \
networkd-dispatcher systemd-networkd-wait-online

apt-get --assume-yes purge nplan netplan.io
