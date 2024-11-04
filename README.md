
# Projet Infrastructure DevOps sur AWS

Ce projet propose une infrastructure cloud automatisée utilisant **Terraform** pour déployer et gérer différentes applications sur **AWS**. L'architecture est organisée autour de plusieurs environnements (dev, staging, prod) avec des modules réutilisables pour des services essentiels comme **ALB**, **ArgoCD**, et **Cert-Manager**. 

## ⚠️ Statut : En cours de développement

Le projet est en cours de finalisation et répondra aux exigences suivantes :  

- **VPC** : OK  
- **EKS** : OK  
- **kubeconfig distant** : OK (récupération des informations nécessaires pour se connecter au cluster)  
- **Outputs Terraform** : OK (intégration avec d'autres providers comme Helm et Kubernetes)  
- **Cert-manager** : OK  
- **AWS Load Balancer Controller** : OK, mais problème d'accès pour les Ingress lors de la création des routes  
- **ArgoCD** : OK, mais nécessite un proxy via `kubectl` pour l'accès (Ingress non fonctionnel)  

### Objectifs à finaliser pour la production (AWS) :
1. Ajouter un **addon** pour la persistance des données (par ex. pour les bases de données).
2. Gérer les accès pour **Grafana/Prometheus** avec un service account et des permissions IAM.
3. Déterminer le système de gestion des credentials : **Vault** ou **Sealed Secrets** ?
4. Automatiser le déploiement d'applications via **ArgoCD** (WordPress, MariaDB).
5. Explorer des outils de sécurité comme **KubeArmor** ou similaires.

### Automatisation du déploiement K3s (Machine on-premises) :
L'objectif est également d'automatiser le déploiement de K3s et des outils suivants sur une machine **datascientest** :
- **Jenkins**
- **Harbor**
- **Grafana / Prometheus**
- **Cert-manager**
- **K3S**
- **Nginx-ingress**

## Structure du projet

```bash
.
├── environnements/          # Déploiements par environnement (dev, staging, prod)
│   ├── dev/                 # Environnement de développement
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── staging/             # Environnement intermédiaire (pré-production) on premise
│   │   ├── main.tf
│   │   └── variables.tf
│   └── prod/                # Environnement de production
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
│       ├── terraform.tfstate
│       ├── terraform.tfstate.backup
│       └── variables.tf
├── modules/                 # Modules Terraform réutilisables
│   ├── alb/                 # Application Load Balancer (AWS ALB)
│   │   ├── alb-policy.json
│   │   ├── iam.tf
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── argocd/              # Déploiement d'ArgoCD pour la gestion GitOps
│   │   ├── main.tf
│   │   └── values.yaml
│   └── cert-manager/        # Gestion des certificats avec Cert-Manager
│       ├── issuers.tf
│       ├── main.tf
│       ├── secrets.tf
│       ├── values.yaml
│       └── variables.tf
└── README.md                # Documentation du projet
```

## Fonctionnalités principales

- **Gestion multi-environnements** : Chaque environnement (dev, staging, prod) possède ses propres fichiers Terraform pour un déploiement distinct.
- **Modules réutilisables** : Les modules sont partagés entre les environnements pour éviter la duplication et faciliter la maintenance.
  - **ALB** : Configuration d'un Load Balancer avec IAM.
  - **ArgoCD** : Déploiement pour une gestion GitOps automatisée.
  - **Cert-Manager** : Gestion automatique des certificats SSL/TLS.
- **Infrastructure-as-Code** : La totalité de l'infrastructure est définie et versionnée en code.

## Prérequis

- **Terraform** ≥ 1.0
- **AWS CLI** configuré avec des accès suffisants
- **kubectl** (si ArgoCD est utilisé)
- **ArgoCD** et **Cert-Manager** dans les clusters Kubernetes correspondants

## Commandes de base

1. **Initialiser Terraform** dans un environnement :  
   ```bash
   terraform init
   ```

2. **Planifier le déploiement** :  
   ```bash
   terraform plan
   ```

3. **Appliquer le déploiement** :  
   ```bash
   terraform apply
   ```

4. **Détruire les ressources** :  
   ```bash
   terraform destroy
   ```

## Astuces : 

Acceder à argoCD
``` Bash
kubectl port-forward service/my-argo-cd-argocd-server -n argocd 8080:443
```

Voir le mdp générer lors de l'installation pour le user admin
``` Bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Ressources

ALB : 
https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/

ArgoCD :
https://artifacthub.io/packages/helm/argo/argo-cd

## Retour Lewis

- Faire comme si on déployé pour une entreprise.(dev, prod, staging sur le cloud provider directement)

- Simplifier le code et éviter les dossiers d'environnement mais plutôt utilisé du conditionnel (if, else) pour determiné les ressources à déployer en fonc de l'environnement choisis.
https://aws.amazon.com/fr/blogs/containers/migrating-amazon-eks-clusters-from-gp2-to-gp3-ebs-volumes/

- OVH : on peut utilisé ovh pour la partie DNS et certificat SSL (  )
  - Delegation ou Route 53 
  - Ou autonomie via le provider OVH

- Utilisé Nginx Ingress Controller

- Pour ArgoCD : Deployer les applications WP et DB (les config du wokflow)

- Jenkins / Harbor : A la mano, sur un k3s
  - 

- Addons : EBS GP3 pour stockage persistant faire des outputs de l'arn ou backup vilero.https://aws.amazon.com/fr/blogs/containers/migrating-amazon-eks-clusters-from-gp2-to-gp3-ebs-volumes/

- Gestions des secrets ?
  - sealed-secrets


### 20h30 : Debrief with Lewis

- Le code Terraform sera que pour la prod mais devra construire.

- Construire la persistence de données via le serveur aws Grafana / Prometheus



- A faire : 

- [ ] Revoir la constructiuon du code avec du conditionnel
- [ ] Utiliser nginx ingress
- [ ] Construire via terraform wordpress & db (avec argocd)
- [ ] Ajouter l'addon gp3
- [ ] Ajouter KubeArmor via helm chart
- [ ] Utiliser sealed-secrets pour les secrets


### 04/11 Point avec Lewis

- Utiliser Gatekeeper pour la politique de sécurité (K8s)
  - Restreindre les registery d'images docker privées 
- Utiliser kubearmor pour la sécurité des conteneurs

- Cosign : 0 Trust
- Velero : 
  - Capacité à backup et à restaurer
- Wordpress / mariadb 
  - Utiliser un seul dépot wordpress
  - Faire un dependancy pour la base de donnée dans le chart