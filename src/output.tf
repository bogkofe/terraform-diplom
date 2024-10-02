output "bastion_external_ip" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  description = "External IP address of the Bastion server."
}

output "k8s_node_internal_ips" {
  value = [
    for instance in yandex_compute_instance_group.k8s_node_group.instances : instance.network_interface[0].ip_address
  ]
  description = "Internal IP addresses of the Kubernetes nodes."
}

resource "null_resource" "run_inventory_script" {
  depends_on = [
    yandex_compute_instance_group.k8s_node_group,
    yandex_compute_instance.bastion,
    yandex_lb_network_load_balancer.k8s_lb
  ]

  provisioner "local-exec" {
    command = "python3 kubespray_inventory.py"
  }
}
