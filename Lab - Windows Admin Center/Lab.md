# Lab - Windows Admin Center

## Pre-Lab Configuration:
You have some new systems - please do the following:

### AD01
*   Make sure system is on your LAN Network
*   Before configuring Networking, use sconfig to turn updates to Manual
*   Set Timezone to be EST
*   Set the Hostname to be AD01
*   IP is 10.0.5.5/24
*   Install AD/DS, providing a domain of yourname.local
*   DHCP is a good idea (On your LAN only), you can either integrate that within AD or on one of your linux lan systems
*   Create a named Domain Admin and a named Domain User
### FS01
*   Make sure system is on your LAN Network
*   Before configuring Networking, use sconfig to turn updates to Manual
*   Set Timezone to be EST
*   Set the Hostname to be FS01
*   IP Address is 10.0.5.7
*   Joined to yourname.local
### WKS1
*   Make sure system is on your LAN Network
*   Joined to your domain
*   DHCP is a nice touch but not required\

## LAB - Windows Admin Center**
## AD01
First thing we need to do is to set the network for ad01 to our LAN:

![1.png](./Images/1.png)

Use powershell/admin to run the following commands:
```
sconfig
5
M
```
These command is to set the update manual:

![2.png](./Images/2.png)

Changing the hostname to `AD01`:

![3.png](./Images/3.png)

Set up the IP address and dns:
if you don't know how to do that use the following link:
https://arris.my.salesforce-sites.com/consumers/articles/General_FAQs/Windows-10-TCP-IP-Configuration

![4.png](./Images/4.png)

Install the AD/DS and create a domain, in my case the domain will be `hasan.local`:
If you don't know how to do it use the following link:
https://www.ibm.com/docs/en/storage-scale-bda?topic=support-install-configure-active-directory

![5.png](./Images/5.png)
![6.png](./Images/6.png)
![7.png](./Images/7.png)

DHCP is a good idea (On your LAN only), you can either integrate that within AD or on one of your linux lan systems

![8.png](./Images/8.png)
![9.png](./Images/9.png)

Create an admin user using the domain that you just created, in my case I create user called `hasan-adm@hasan.local`:

![10.png](./Images/10.png)
![11.png](./Images/11.png)

## FS01

![12.png](./Images/12.png)
![13.png](./Images/13.png)
![14.png](./Images/14.png)
![15.png](./Images/15.png)
![16.png](./Images/16.png)
![17.png](./Images/17.png)
![18.png](./Images/18.png)
![19.png](./Images/19.png)
![20.png](./Images/20.png)
![21.png](./Images/21.png)
![22.png](./Images/22.png)
![23.png](./Images/23.png)
![24.png](./Images/24.png)
![25.png](./Images/25.png)
![26.png](./Images/26.png)
![27.png](./Images/27.png)
![28.png](./Images/28.png)
![29.1.png](./Images/29.1.png)
![29.png](./Images/29.png)
![30.png](./Images/30.png)
![31.png](./Images/31.png)
![32.png](./Images/32.png)
![33.png](./Images/33.png)
![34.png](./Images/34.png)
![35.png](./Images/35.png)
![36.png](./Images/36.png)
![37.png](./Images/37.png)
![38.png](./Images/38.png)
![39.png](./Images/39.png)
![40.png](./Images/40.png)
![41.png](./Images/41.png)
![42.png](./Images/42.png)
![43.png](./Images/43.png)
![44.png](./Images/44.png)
![45.png](./Images/45.png)
![46.png](./Images/46.png)
![47.png](./Images/47.png)
![48.png](./Images/48.png)
![49.png](./Images/49.png)
![50.png](./Images/50.png)
![51.png](./Images/51.png)
![52.png](./Images/52.png)
![53.png](./Images/53.png)
![54.png](./Images/54.png)
![55.png](./Images/55.png)
![56.png](./Images/56.png)





































