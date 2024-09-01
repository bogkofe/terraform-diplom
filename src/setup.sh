#!/bin/bash
sudo useradd -m -s /bin/bash admins
echo 'admins ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/admins

# Создаем директорию .ssh для пользователя admins
sudo mkdir -p /home/admins/.ssh
sudo chown admins:admins /home/admins/.ssh
sudo chmod 700 /home/admins/.ssh

# Добавляем публичный ключ в authorized_keys для пользователя admins
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8hSq3x1m8WIuqKY5kuU70v6+h49Qh8lsr+5cZ6Ow84nxpsg8LTNjBTmFcROJ6kXRc/Eh/RWtCQLahFsZ8bmNseipqF8Jp87Y9ImL4czW3Ufhd50wFxeMFtZKH7zyFXE9y+cTmP8oosJml0XkllWh25/OT+Y0mxG08G7DF7eT0p9KLlUXne1Ezc1SY6Ncpuw0UVhyYTT9Qq8FFRI86CMxAXwooZ8E9PeLB4AUjlyqjHv6vwUa1GVWcuu3UTrFXz1hy/BgH1bWjgVdUr6P4FnAQdCxHE9B8FP6efOfBH1v9zdc0b5JxQg8J6O6BMeCw+A7POHtiSvkHjvwjksBZpXbMAGiU9t0V/OpilVHUnZqeEvkNUEbX6BHkcg6Zo2OwOgrHKDii3c01WT6ZTFbOx0bS3LmcLCXqkaZkqE5MQL6GEnMcWtib9O5URTbHmNgAYBij8eAOJQyjXbJ5vr+YBHpmbUZr9lmNSMkWNQk32nE6szS+7QhRzj8ziqjSJvtEKKM= admins@s1' | sudo tee -a /home/admins/.ssh/authorized_keys
sudo chown admins:admins /home/admins/.ssh/authorized_keys
sudo chmod 600 /home/admins/.ssh/authorized_keys
