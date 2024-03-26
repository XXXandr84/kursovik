#!/bin/sh
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt update -y
apt install -y kubeadm kubelet kubectl
sh -c "containerd config default > /etc/containerd/config.toml"
systemctl restart containerd.service
systemctl restart kubelet.service
systemctl enable kubelet.service
exit