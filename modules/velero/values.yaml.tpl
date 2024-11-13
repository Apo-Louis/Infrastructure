configuration:
  backupStorageLocation:
    - name: default
      provider: aws
      bucket: ${bucket_name_velero}
      config:
        region: ${region}

  volumeSnapshotLocation:
    - name: default
      provider: aws
      config:
        region: ${region}

schedules:
  cluster-backup:
    schedule: "${backup_schedule}"
    template:
      ttl: "${backup_ttl}"
      storageLocation: default

serviceAccount:
  server:
    create: true
    name: velero

    annotations:
      eks.amazonaws.com/role-arn: "${velero_irsa_role_arn}"

initContainers:
  - name: velero-plugin-for-aws
    image: "${velero_plugin_image}"
    imagePullPolicy: "${plugin_image_pull_policy}"
    volumeMounts:
      - mountPath: /target
        name: plugins
