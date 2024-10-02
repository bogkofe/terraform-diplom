import json
import os
import yaml
import shutil

# Получаем информацию из Terraform
terraform_output_nodes = os.popen('terraform output -json k8s_node_internal_ips').read()
terraform_output_bastion = os.popen('terraform output -json bastion_external_ip').read()

nodes = json.loads(terraform_output_nodes)
bastion_ip = json.loads(terraform_output_bastion)

# Шаблон инвентори
inventory = {
    "all": {
        "hosts": {},
        "vars": {
            "ansible_ssh_common_args": f'-o ProxyCommand="ssh -W %h:%p -q ubuntu@{bastion_ip}"',
            "ansible_user": "ubuntu",
            "ansible_private_key_file": "/home/admins/.ssh/id_rsa"
        },
        "children": {
            "kube_control_plane": {
                "hosts": {}
            },
            "kube_node": {
                "hosts": {}
            },
            "etcd": {
                "hosts": {}
            },
            "k8s_cluster": {
                "children": {
                    "kube_control_plane": {},
                    "kube_node": {}
                }
            },
            "calico_rr": {
                "hosts": {}
            }
        }
    }
}

# Заполнение инвентори файла
for idx, internal_ip in enumerate(nodes):
    host_data = {
        "ansible_host": internal_ip,  # Внутренний IP в качестве ansible_host
        "ip": internal_ip,
        "access_ip": internal_ip
    }

    inventory['all']['hosts'][f'node{idx + 1}'] = host_data

    if idx == 0:
        # Нода 1 - это мастер и etcd
        inventory['all']['children']['kube_control_plane']['hosts'][f'node{idx + 1}'] = {}
        inventory['all']['children']['etcd']['hosts'][f'node{idx + 1}'] = {}
    else:
        # Остальные ноды - это воркеры
        inventory['all']['children']['kube_node']['hosts'][f'node{idx + 1}'] = {}

# Запись в файл inventory.yml
output_file_path = 'inventory.yml'
with open(output_file_path, 'w') as f:
    yaml.dump(inventory, f, default_flow_style=False, sort_keys=False)

# Чистим пустые скобки
with open(output_file_path, 'r') as f:
    lines = f.readlines()

with open(output_file_path, 'w') as f:
    for line in lines:
        f.write(line.replace('{}', ''))

print("Inventory файл успешно создан: hosts.yml")

# Копируем структуру и перемещаем файл
shutil.copytree('../../kubespray/inventory/sample', '../../kubespray/inventory/kube_cluster', dirs_exist_ok=True)
shutil.move(output_file_path, '../../kubespray/inventory/kube_cluster/hosts.yaml')

print("Файл hosts.yaml успешно перемещен в ../../kubespray/inventory/kube_cluster")
