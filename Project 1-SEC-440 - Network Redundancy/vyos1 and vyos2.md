# vyos1 configuration
* Go to vcenter and click on the edit settings and add the netwrok adapter 2, as shown below:

![2.png](./Images/2.png)

* Now we need to setup the hostname and the interfaces for eth0 and eth1. I used the following commands below to do that
```
config
set system host-name vyos1-HasanHashim
set interfaces ethernet eth0 address 10.0.17.15/24
set interfaces ethernet eth0 description "WAN"
set interfaces ethernet eth1 address 10.0.5.2/24
set interfaces ethernet eth1 description "LAN"

```
![3.png](./Images/3.png)

* We need to setup the default gateway and DNS server, as shown below:

  ```
  set protocols static route 0.0.0.0/0 next-hop 10.0.17.2
  set system name-server 10.0.17.2
  show interfaces  
  ```
  ![4.png](./Images/4.png)
* NAT Rules
```
    set nat source rule 10 outbound-interface eth0
    set nat source rule 10 source address 10.0.5.0/24
    set nat source rule 10 description "Lan to Wan"
    set nat source rule 10 translation address masquerade
    commit
    save
    show nat source rule 10
```
![5.png](./Images/5.png)
* DNS Forewarding
  ```
    set service dns forwarding listen-address 10.0.5.1
    set service dns forwarding allow-from 10.0.5.0/24
    set service dns forwarding system
    set service ssh listen address 0.0.0.0
    commit
    save
    show service
    ping google.com
  ```
![6.png](./Images/6.png)
![7.png](./Images/7.png)
* taking a snapshot:
  ![8.png](./Images/8.png)
# vyos2 configuration 
* Go to edit settings and add your LAN in the adapter 2, as shown below:

![9.png](./Images/9.png)

* Setting up the interfaces and defualt gatway and DNS
```
    set interfaces ethernet eth0 address 10.0.17.75/24
	set interfaces ethernet eth0 description "To WAN"
    set interfaces ethernet eth1 address 10.0.5.3/24
	set interfaces ethernet eth1 description "To LAN"
    
    set protocols static route 0.0.0.0/0 next-hop 10.0.17.2
    set system name-server 10.0.17.2
	commit
	save
```
![10.png](./Images/10.png)
![11.png](./Images/11.png)
* NAT rules
```
    
    set nat source rule 10 source address 10.0.5.0/24
	set nat source rule 10 outbound-interface eth0
	set nat source rule 10 description "Lan to Wan"
    set nat source rule 10 translation address masquerade
	show nat source rule 10
    commit
    save
    
```
![12.png](./Images/12.png)

* DNS and SSH
  ```
    set service dns forwarding listen-address 10.0.5.1
    set service dns forwarding allow-from 10.0.5.0/24
    set service dns forwarding system
    set service ssh listen address 0.0.0.0
    ping hashimtech.com
  ```
![13.png](./Images/13.png)
![14.png](./Images/14.png)

* poweroff and take a snapshot
  ![15.png](./Images/15.png)

# port forwarding/SSH
For this part I ran the follwoing commands on both vyos1 and vyos2 for ports forwarding:
```
conf
set nat destination rule 10 description "WEB01 on WAN (HTTP)"
set nat destination rule 10 destination port 80
set nat destination rule 10 inbound-interface eth0
set nat destination rule 10 protocol tcp
set nat destination rule 10 translation address 10.0.5.100
set nat destination rule 10 translation port 80

set nat destination rule 20 description "WEB01 on WAN (SSH)"
set nat destination rule 20 destination port 22
set nat destination rule 20 inbound-interface eth0
set nat destination rule 20 protocol tcp
set nat destination rule 20 translation address 10.0.5.100
set nat destination rule 20 translation port 22


commit
save
show nat destination rule 10
show nat destination rule 20
```

# VRRP
* Vyos1
Here are the command that I used to set up the vrrp in the vyos1:
https://raw.githubusercontent.com/hasanhashim1/SEC-440/main/test.sh
```
configure
set high-availability vrrp group WAN vrid 10
set high-availability vrrp group WAN interface eth0
set high-availability vrrp group WAN priority '200'
set high-availability vrrp group WAN address 10.0.17.105/24

set high-availability vrrp group LAN vrid 20
set high-availability vrrp group LAN interface eth1
set high-availability vrrp group LAN priority '200'
set high-availability vrrp group LAN address 10.0.5.1/24

show high-availability vrrp
commit
save
```
![31.png](./Images/31.png)
* Vyos2
```
configure
set high-availability vrrp group LAN vrid 20
set high-availability vrrp group LAN interface eth1
set high-availability vrrp group LAN priority '100'
set high-availability vrrp group LAN address 10.0.5.1/24

set high-availability vrrp group WAN vrid 10
set high-availability vrrp group WAN interface eth0
set high-availability vrrp group WAN priority '100'
set high-availability vrrp group WAN address 10.0.17.105/24

show high-availability vrrp
commit
save
```
![32.png](./Images/32.png)
















