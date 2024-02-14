We have serveral configuration we have to go threw, that includes teh follwoing:
* Adding third network adapter for OPT (vyos1 and vyos 2)
* Now we need to set the interfaces for the OPT in vyos 1 and 2
* adding nat source rule 20 (vyos 1 and vyos 2)
* set up DNS in both vyos systems
* Configure VRRP on both vyos 1 and vyos 2
* After Configuring the Proxy then we should change the Nat (**port forwarding**) rule to this ip 10.0.6.10 on both vyos 1 and vyos 2