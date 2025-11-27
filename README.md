## Update + upgrade + install ssh server
This need to be done in all managed nodes

```bash
sudo apt update && sudo apt upgrade -y && sudo apt install -y openssh-server
```

## Add ansible controller public key to authorized keys of all managed nodes
This need to be done in all managed nodes

```bash
echo "your-public-key" >> ~/.ssh/authorized_keys
```

## Complete the inventory.ini file with the managed nodes IP addresses
This need to be done in the ansible controller

## Check connectivity from ansible controller to managed nodes
This need to be done in the ansible controller

```bash
ansible all -m ping -i inventory.ini
```

if some pings fails try to ssh into the managed node by hand to add the host to the list of known hosts.

## 