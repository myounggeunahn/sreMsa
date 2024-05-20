## k8s Single Node install on ubuntu24.04
1. Ansible 설치
```
sudo -i 
ANSIBE_VERSION="9.5.1"           # core 2.16.6
pip3 install --break-system-packages netaddr jinja2
pip3 install --break-system-packages ansible==$ANSIBE_VERSION
```

2. key 생성 및 Local 접소 가능하게 하기
```
ssh-keygen -f ~/.ssh/id_rsa -N ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

3. Kubespary Downloads
```
cd
git clone https://github.com/kubernetes-sigs/kubespray
cd ~/kubespray
```

4. Requirement 수정
```
cat >requirements.txt<<EOF
ansible==9.5.1
cryptography
jinja2==3.1.4
jmespath==1.0.1
MarkupSafe==2.1.5
netaddr==1.2.1
pbr==6.0.0
ruamel.yaml==0.18.6
ruamel.yaml.clib==0.2.8
jsonschema
EOF
sudo pip3 install --break-system-packages -r requirements.txt
```

5. inventory 
```
cat > inventory/inventory.ini <<EOF
[all]
vm01 etcd_member_name=etcd1
[kube-master]
vm01

[etcd]
vm01

[kube-node]
vm01

[k8s-cluster:children]
kube-master
kube-node
EOF
```

6. playbook 실행
```
ansible-playbook --flush-cache -u ubuntu -b --become --become-user=root \
      -i inventory/inventory.ini \
      cluster.yml
```

7. test
```
kubectl get no
```
