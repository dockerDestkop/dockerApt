#!/bin/bash

# Créer un réseau Bridge
sudo docker network create nginx_bridge --driver bridge

# Créer un réseau Overlay
sudo docker swarm init
sudo docker network create nginx_overlay --driver overlay --subnet=192.168.2.0/24

# Créer un réseau Macvlan
sudo docker network create -d macvlan \
  --subnet=192.168.3.0/24 \
  --gateway=192.168.3.1 \
  -o parent=eth0 nginx_macvlan

# Lancer un conteneur sur le réseau Bridge
sudo docker run --network nginx_bridge --name nginx_bridge_container -d nginx

# Lancer un conteneur sur le réseau None
sudo docker run --network none --name nginx_none_container -d nginx

# Lancer un conteneur sur le réseau Overlay
sudo docker service create --name nginx_overlay_container --network nginx_overlay nginx

# Lancer un conteneur sur le réseau Macvlan
sudo docker run --network nginx_macvlan --name nginx_macvlan_container -d nginx