We have serveral configuration we have to go threw, that includes teh follwoing:
* Adding third network adapter for OPT (vyos1 and vyos 2)

![5.png](./images/5.png)

![6.png](./images/6.png)

*  Now we need to set the interfaces for the OPT in vyos 1 and 2
`show interfaces`

![11.png](./images/11.png)
![12.png](./images/12.png)

* adding nat source rule 20 (vyos 1 and vyos 2)
`show nat source rule 20`

![13.png](./images/13.png)

* set up DNS in both vyos systems
`show service`

![14.png](./images/14.png)
* Configure VRRP on both vyos 1 and vyos 2
`show high-availability vrrp`

![15.png](./images/15.png)

**I created a script that does the above:**
Here is the script: [Web-and-Proxy-Redundancy.sh](./Web-and-Proxy-Redundancy.sh)

* After Configuring the Proxy then we should change the Nat (**port forwarding**) rule to this ip 10.0.6.10 on both vyos 1 and vyos 2
`set nat destination rule 10 translation address 10.0.6.10`
`show nat destination rule 10`

![16.png](./images/16.png)









