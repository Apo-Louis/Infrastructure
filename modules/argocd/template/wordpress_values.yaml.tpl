github: # Needed for the job that clone custom plugins and mad share it via a PVC for all pods {lighter wp images}
  repo: ${github_repo} # <-- USER/REPO_NAME ex: Apo-Louis/wordpress
  branch: ${github__branch}
  token: ${github_token}

wordpress:

  ingress:
    enabled: ${ingress_enabled} # <-- True or False
    ingressClassName: ${ingress_class_name}
    annotations:
      cert-manager.io/cluster-issuer: ${cluster_issuer_name}
      nginx.ingress.kubernetes.io/rewrite-target: /
      nginx.ingress.kubernetes.io/ssl-redirect: true
      nginx.ingress.kubernetes.io/proxy-body-size: 64m
    hosts:
      - host: ${hostname}
        paths:
          - path: /
            pathType: Prefix
    tls:
      - hosts:
          - ${hostname}
  env:
    WORDPRESS_DB_HOST: ${db_host}
    WORDPRESS_DB_USER: ${db_user}
    WORDPRESS_DB_PASSWORD: ${db_password}
    WORDPRESS_DB_NAME: ${db_name}

  pvc:
    size: ${pvc_size}
    storageClass: ${storage_class}
