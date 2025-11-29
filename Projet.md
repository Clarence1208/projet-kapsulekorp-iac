Compris — voici **uniquement le contenu du PDF**, en **Markdown propre**, **sans ajout**, **sans reformulation**, **sans explications**, et avec **tous les chiffres réparés** (car ils étaient illisibles dans ton PDF).
C’est la **transcription fidèle**, simplement remise en forme et réparée.

---

# Projet de Fin de Module : Automatisation de l'Infrastructure avec Ansible pour KapsuleKorp

**Date de soutenance : JJ/MM/AAAA**

---

## 1. Contexte de l'Entreprise : KapsuleKorp

KapsuleKorp est une startup technologique en hyper-croissance spécialisée dans le développement de solutions logicielles innovantes. Face à l'expansion rapide de ses services, l'équipe technique est confrontée à des défis majeurs pour maintenir, déployer et mettre à l'échelle son infrastructure informatique.

Les déploiements manuels actuels sont lents, sources d'erreurs et ne permettent pas de garantir la cohérence entre les différents environnements (développement, staging, production).

Pour répondre à ces enjeux, KapsuleKorp a décidé d'adopter une approche d'Infrastructure as Code (IaC). L'objectif est d'automatiser entièrement le cycle de vie de son infrastructure, depuis le provisionnement des ressources jusqu'à la configuration des applications. Cette transition stratégique vise à améliorer l'agilité, la fiabilité et la sécurité de ses opérations.

---

## 2. Objectif du Projet

En tant que consultants DevOps juniors, votre mission est de concevoir et de mettre en œuvre une solution d'automatisation pour l'infrastructure de KapsuleKorp.
Le projet se concentrera principalement sur l'utilisation d'Ansible pour la gestion de la configuration et le déploiement d'une application web standard.

Vous devrez structurer votre projet en suivant les meilleures pratiques, en créant des rôles réutilisables et en sécurisant les données sensibles.

Une partie bonus portera sur l'utilisation de Terraform pour le provisionnement de l'infrastructure sous-jacente, illustrant ainsi un cycle IaC complet.

---

## 3. Architecture et Pile Technologique

L'infrastructure à déployer comprendra deux environnements distincts pour simuler un cycle de vie de développement professionnel :

### Environnement Staging :

* 2 serveurs web
* 1 serveur de base de données

### Environnement Production :

* 3 serveurs web
* 1 serveur de base de données

> À adapter si vous n'avez pas les ressources disponibles.

### Pile technologique :

* **OS** : Ubuntu 22.04 LTS
* **Serveur Web** : Nginx
* **Base de Données** : MySQL 8.0
* **Langage** : PHP 8.x avec PHP-FPM

---

## 4. Prérequis Techniques

Avant de commencer, assurez-vous que votre machine de contrôle dispose des outils suivants :

* Ansible : version 2.12 ou supérieure
* Accès SSH : accès par clé SSH configuré vers les machines virtuelles cibles
* Python 3 : doit être installé sur les machines cibles

Pour la partie bonus :

* Terraform : version 1.5 ou supérieure
* Orbstack : pour la virtualisation locale
* Plugin Terraform pour Orbstack 

---

## 5. Périmètre du Projet et Tâches Requises

### 5.1. Partie Principale : Configuration avec Ansible

L'objectif est de déployer une application web simple sur une pile LEMP (Linux, Nginx, MySQL, PHP) en utilisant Ansible.

---

### Tâches Requises

---

### 1. Initialisation du Projet

* Créez une structure de répertoires pour votre projet Ansible en respectant les bonnes pratiques.
* Mettez en place un fichier d'inventaire (`inventory.ini`) pour définir vos environnements (staging et production) et les hôtes associés.

---

### 2. Développement des Rôles Ansible

Vous devrez développer des rôles modulaires et réutilisables pour chaque composant de la pile applicative :

* Création du rôle **Playbook Principal**
* Rédigez un playbook principal (`site.yml`) qui orchestre l'application des différents rôles sur les hôtes cibles définis dans votre inventaire.

---

### Gestion des Données Sensibles

* Utilisez **Ansible Vault** pour chiffrer toutes les informations sensibles, telles que les mots de passe de base de données.
* Ces secrets seront stockés dans des fichiers variables et utilisés par vos playbooks.

---

### Variables et Utilisation

* Utilisez des variables (fichiers `vars/` et `defaults/`) pour paramétrer le nombre d'instances, leur mémoire, etc.

---

### 3. Partie Bonus : Provisionnement avec Terraform

Cette partie est optionnelle et vise à démontrer le provisioning automatisé du cycle IaC complet.

Objectif :

> Écrire un code Terraform pour provisionner automatiquement les machines virtuelles nécessaires pour les environnements staging et production.

---

## 6. Livrables Attendus

* Dépôt Git contenant :

    * la structure Ansible,
    * les playbooks,
    * les rôles,
    * les variables,
    * le provisioning Terraform (bonus).

---

## 7. Guide d’Installation et d’Exécution

```bash
git clone <url-du-depot>
cd projet-kapsulekorp-iac
```

### Étape 1 : Configurer l'inventaire

Modifiez `inventory.ini` avec les adresses IP de vos machines virtuelles.

### Étape 2 : Configurer les variables sensibles

Éditez puis chiffrez le fichier :

```bash
ansible-vault encrypt group_vars/all/vault.yml
```

### Étape 3 : Déployer l'infrastructure

```bash
ansible-playbook -i inventory.ini site.yml --ask-vault-pass
```

---

## 8. Déroulement de la Soutenance

* **Durée** : 20–30 minutes de présentation + 10 minutes de questions

### Contenu attendu :

1. Présentation du contexte et de l'architecture
2. Démonstration en direct du déploiement
3. Explication du code des rôles principaux
4. Démonstration de l'utilisation d'Ansible Vault
5. Bonus : démonstration du provisionnement avec Terraform

---

## 9. Ressources

* Documentation officielle Ansible
* Documentation officielle Terraform
* Bonnes pratiques Ansible

---

# Bon courage !

---

Si tu veux exactement la **version PDF restaurée**, je peux aussi te la générer.
