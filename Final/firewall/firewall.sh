sudo -i 
yum install vim firewalld -y
service NetworkManager stop

chkconfig NetworkManager off

sudo cp /vagrant/firewall/sysctl.conf /etc/sysctl.conf

service firewalld restart

firewall-cmd --zone=dmz --add-interface=eth2 --permanent
firewall-cmd --zone=internal --add-interface=eth1 --permanent

firewall-cmd --direct --permanent --add-rule ipv4 filter FORWARD 0 -i eth1 -o eth2 -j ACCEPT
firewall-cmd --direct --permanent --add-rule ipv4 filter FORWARD 0 -i eth2 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT

firewall-cmd --zone=dmz --add-service=http --permanent
firewall-cmd --zone=internal --add-service=http --permanent

firewall-cmd --zone=dmz --add-forward-port=port=80:proto=tcp:toport=80:toaddr=192.168.50.10 --permanent
firewall-cmd --zone=dmz --add-forward-port=port=80:proto=udp:toport=80:toaddr=192.168.50.10 --permanent

firewall-cmd --zone=dmz --add-forward-port=port=8080:proto=tcp:toport=8080:toaddr=192.168.50.10 --permanent
firewall-cmd --zone=dmz --add-forward-port=port=8080:proto=udp:toport=8080:toaddr=192.168.50.10 --permanent

firewall-cmd --zone=dmz --add-masquerade --permanent

firewall-cmd --zone=internal --add-masquerade --permanent

firewall-cmd --reload
service NetworkManager restart
service firewalld restart