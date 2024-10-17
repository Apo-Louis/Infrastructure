output "kubeconfig" {
  value = join("\n", [
    "apiVersion: v1",
    "clusters:",
    "- cluster:",
    "    server: ${module.eks.cluster_endpoint}",
    "    certificate-authority-data: ${module.eks.cluster_certificate_authority_data}  # Supprime base64encode()",
    "  name: ${module.eks.cluster_name}",
    "contexts:",
    "- context:",
    "    cluster: ${module.eks.cluster_name}",
    "    user: ${module.eks.cluster_name}",
    "  name: ${module.eks.cluster_name}",
    "current-context: ${module.eks.cluster_name}",
    "kind: Config",
    "preferences: {}",
    "users:",
    "- name: ${module.eks.cluster_name}",
    "  user:",
    "    exec:",
    "      apiVersion: \"client.authentication.k8s.io/v1beta1\"",
    "      command: \"aws\"",
    "      args:",
    "        - \"eks\"",
    "        - \"get-token\"",
    "        - \"--cluster-name\"",
    "        - \"${module.eks.cluster_name}\""
  ])
  description = "Kubeconfig file content for the EKS cluster"
  sensitive   = true
}
