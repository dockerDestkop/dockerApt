#!/bin/bash

# Vérifier si l'utilisateur a les permissions nécessaires
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté avec des privilèges root ou via sudo."
  exit 1
fi

# Créer le fichier avec les commandes Docker
OUTPUT_FILE="docker_network_commands.txt"
echo "Création du fichier $OUTPUT_FILE avec les commandes Docker pour les réseaux."

cat << EOF > $OUTPUT_FILE
# Commandes pour créer différents types de réseaux Docker

# 1. Bridge Network
# Crée un réseau bridge personnalisé
sudo docker network create my_bridge_network --driver bridge

# 2. Host Network
# Lance un conteneur en utilisant le réseau Host
sudo docker run --network host --name my_container nginx

# 3. None Network
# Lance un conteneur sans réseau
sudo docker run --network none --name my_container nginx

# 4. Overlay Network
# Passer Docker en mode Swarm (si ce n'est pas encore fait)
sudo docker swarm init

# Crée un réseau Overlay
sudo docker network create --driver overlay --subnet=192.168.1.0/24 my_overlay_network

# Lance un service utilisant le réseau Overlay
sudo docker service create --name my_service --network my_overlay_network nginx

# 5. Macvlan Network
# Crée un réseau Macvlan
sudo docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=eth0 macvlan_network

# Lance un conteneur sur le réseau Macvlan
sudo docker run --network macvlan_network --name my_container nginx

# 6. Plugins Tiers (Exemple avec Weave)
# Installer un plugin réseau (Weave)
sudo docker plugin install weaveworks/net-plugin:latest_release

# Crée un réseau avec le plugin
sudo docker network create --driver=weave my_custom_network

# Lance un conteneur
sudo docker run --network my_custom_network --name my_container nginx

# Outils supplémentaires
# Lister les réseaux
sudo docker network ls

# Inspecter un réseau
sudo docker network inspect my_network

# Supprimer un réseau
sudo docker network rm my_network

# Ajouter une image et créer un conteneur simple
# Pull de l'image Nginx
sudo docker pull nginx

# Lancer un conteneur Nginx
sudo docker run -d --name nginx_container -p 80:80 nginx
EOF

# Vérifier si le fichier a été créé avec succès
if [ -f "$OUTPUT_FILE" ]; then
  echo "Le fichier $OUTPUT_FILE a été créé avec succès."
  echo "Contenu du fichier :"
  cat $OUTPUT_FILE
else
  echo "Erreur : Le fichier $OUTPUT_FILE n'a pas pu être créé."
  exit 1
fi

# Ajouter une instruction pour éditer le fichier avec nano
echo "Vous pouvez éditer le fichier avec la commande suivante :"
echo "nano $OUTPUT_FILE"
