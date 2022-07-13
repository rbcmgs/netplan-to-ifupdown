# Reverting from netplan to ifupdown on Ubuntu

Note: You MUST, of course, adapt the values according to your system (network, interface name…)

Reinstall the ifupdown package:
```
apt-get update
apt-get install ifupdown
```
 
Configure your `/etc/network/interfaces` file with configuration stanzas such as:
```
auto lo
iface lo inet loopback

auto ens18
iface ens18 inet static
 address 192.168.1.100
 netmask 255.255.255.0
 broadcast 192.168.1.255
 gateway 192.168.1.1
 dns-nameservers 8.8.8.8 8.8.4.4
 ```
 
Make the configuration effective (no reboot needed):
```
ifdown --force ens18 lo && ifup -a
systemctl unmask networking
systemctl enable networking
systemctl restart networking
```
 
Disable and remove the unwanted services:
```
systemctl stop systemd-networkd.socket systemd-networkd \
networkd-dispatcher systemd-networkd-wait-online
```
```
systemctl disable systemd-networkd.socket systemd-networkd \
networkd-dispatcher systemd-networkd-wait-online
```
```
systemctl mask systemd-networkd.socket systemd-networkd \
networkd-dispatcher systemd-networkd-wait-online
```
```
apt-get --assume-yes purge nplan netplan.io
```

DNS Resolver

Because Ubuntu Bionic Beaver (18.04) make use of the DNS stub resolver as provided by SYSTEMD-RESOLVED.SERVICE(8), you SHOULD also add the DNS to contact into the `/etc/systemd/resolved.conf` file. For instance:

```
[Resolve]
DNS=8.8.8.8
FallbackDNS=8.8.4.4
```

and then restart the systemd-resolved service once done:
```
systemctl restart systemd-resolved
```
