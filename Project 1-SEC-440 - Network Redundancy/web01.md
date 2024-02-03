# web01 configuration
* Befor you start add your Lan from the Edit Settings, as shown below:
![16.png](./Images/16.png)
* Resting the Password:
  on power on click on "e", you will see something like that:
  
  ![17.png](./Images/17.png)

  Search for the following `rhgb quiet` and replace it with `init=/bin/bash` after that press `ctrl x`:
  ![18.png](./Images/18.png)

When you see a bash prompt, we need to get read-write permission to do that run the following command `mount -o remount,rw /` 

![19.png](./Images/19.png)

* Network configuration
  I added the following:
  ![21.png](./Images/21.png)
![22.png](./Images/22.png)
ping test:

![chrome_Q97ycGazpk.png](../../../../Documents/ShareX/Screenshots/2024-01/chrome_Q97ycGazpk.png)

Run the follwoing commands on both vyos1 and vyos2 for ports forwarding:
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
![24.png](./Images/24.png)
![25.png](./Images/25.png)

# Two-Factor Authentcation 

* Installing epel:
  ```
  sudo yum search epel
  sudo yum install epel-release
  sudo yum install google-authenticator qrencode-libs
  yum install google-authenticator
  google-authenticator
  ```
  and finsih up the rest of the steps:
  
![26.png](./Images/26.png)

Openssh using MFA:
```
sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.bak
sudo nano /etc/pam.d/sshd
```
Now we going to add the follwing lines in the end of the file:
```
auth       required     pam_google_authenticator.so
```
![27.png](./Images/27.png)

Now we have to change the challengeResponseAuthentication in the /etc/ssh/sshd_config no to yes, as shown below:

![28.png](./Images/28.png)

Testing:

![29.png](./Images/29.png)


# Apache
I ran the following commands to update the system, isntalling httpd, starting the serice and setting up the firewall:
```
sudo yum update
yum install httpd
systemctl start httpd
systemctl enable httpd.service
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```
![30.png](./Images/30.png)

































