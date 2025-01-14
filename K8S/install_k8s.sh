#!/bin/sh
sudo su << EOF
sudo swapoff -a
sudo sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab
sudo setenforce 0
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
EOF
sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
EOF
sudo su << EOF
sudo yum update -y
sudo yum install docker -y
sudo yum install -y kubeadm kubelet kubectl
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl enable kubelet
sudo systemctl start kubelet
EOF
sudo reboot