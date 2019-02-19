#!/bin/bash
# setup-lnxcfg-user
# create lnxcfg user for Ansible automation
# and configuration management

# create lnxcfg user
getentUser=$(/usr/bin/getent passwd lnxcfg)
if [ -z "$getentUser" ]
then
  echo "User lnxcfg does not exist.  Will Add..."
  /usr/sbin/groupadd -g 2002 lnxcfg
  /usr/sbin/useradd -u 2002 -g 2002 -c "Ansible Automation Account" -s /bin/bash -m -d /home/lnxcfg lnxcfg

echo "lnxcfg:<PUT IN YOUR OWN lnxcfg PASSWORD>" | /sbin/chpasswd

mkdir -p /home/lnxcfg/.ssh

fi

# setup ssh authorization keys for Ansible access 
echo "setting up ssh authorization keys..."

cat << 'EOF' >> /home/lnxcfg/.ssh/authorized_keys
<PUT IN YOUR OWN .ssh/id_rsa.pub SSH RSA KEY>
EOF

chown -R lnxcfg:lnxcfg /home/lnxcfg/.ssh
chmod 700 /home/lnxcfg/.ssh

# setup sudo access for Ansible
if [ ! -s /etc/sudoers.d/lnxcfg ]
then
echo "User lnxcfg sudoers does not exist.  Will Add..."
cat << 'EOF' > /etc/sudoers.d/lnxcfg
User_Alias ANSIBLE_AUTOMATION = %lnxcfg
ANSIBLE_AUTOMATION ALL=(ALL)      NOPASSWD: ALL
EOF
chmod 400 /etc/sudoers.d/lnxcfg
fi

# disable login for lnxcfg except through 
# ssh keys
cat << 'EOF' >> /etc/ssh/sshd_config
Match User lnxcfg
        PasswordAuthentication no
        AuthenticationMethods publickey

EOF

# restart sshd
systemctl restart sshd

# end of script