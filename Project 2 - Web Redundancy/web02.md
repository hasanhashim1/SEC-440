![1.png](./images/1.png)


![2.png](./images/2.png)

![3.png](./images/3.png)



```
sudo yum update
yum install httpd
systemctl start httpd
systemctl enable httpd.service
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```

```
nano /var/www/html/index.html
Hello from web02-hasan to SEC-440
```
![4.png](./images/4.png)

