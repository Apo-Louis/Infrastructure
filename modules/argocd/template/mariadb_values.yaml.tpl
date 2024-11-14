mariadb:

  service:
    name: '${db_host}'

  pvc:
    size: '${pvc_size}'
    storageClass: '${storage_class}'

  env:
    MARIADB_USER: '${db_user}'
    MARIADB_PASSWORD: '${db_password}'
    MARIADB_DATABASE: '${db_name}'
    MARIADB_ROOT_PASSWORD: '${db_root_password}'

