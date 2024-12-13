github:
  wp_repo: ${wordpress_repo}
  token: ${wordpress_repo_token}
  # commit: # <-- this variable is dynamic and is update via the jenkins pipeline
mariadb:
  global:
    defaultStorageClass: ${storage_class}
  enabled: true
  auth:
    rootPassword: ${mariadb_root_password}
    database: ${database_name}
    username: ${database_username}
    password: ${database_password}
  primary:
    persistence:
      storageClass: ${storage_class}
      enabled: true
      size: ${mariadb_volume_size}

wordpress:
  replicaCount: 1
  siteTitle: ${wordpress_site_title}
  adminUser: ${wordpress_admin_user}
  adminPassword: ${wordpress_admin_password}
  adminEmail: ${wordpress_admin_email}

  image:
    pullPolicy: IfNotPresent
    imagePullSecrets: ${docker_image_pull_secrets}

  service:
    type: ClusterIP
    port: 80
  ingress:
    enabled: true
    ingressClassName: ${ingress_class}
    annotations:
      cert-manager.io/cluster-issuer: ${cluster_issuer}
      nginx.ingress.kubernetes.io/proxy-body-size: "64m"
    hosts:
      - host: ${wordpress_hostname}
        paths:
          - path: /
            pathType: Prefix
    tls:
      - hosts:
          - ${wordpress_hostname}
        secretName: ${wordpress_tls_secret_name}

  resources:
    limits:
      cpu: "500m"
      memory: "512Mi"
    requests:
      cpu: "200m"
      memory: "256Mi"
  nodeSelector: {}
  tolerations: []
  affinity: {}
  hpa:
    enabled: true

    minReplicas: 1
    maxReplicas: 10
    targetCPUUtilizationPercentage: 80
    targetMemoryUtilizationPercentage: 80
  pvc:
    size: 5Gi
    accessMode: ReadWriteMany
    storageClass: ${storage_class}
    volumeMode: Filesystem
    annotations: {}

