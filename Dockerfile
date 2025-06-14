FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH server dan SSH client (untuk tunnel serveo)
RUN apt update && apt install -y \
    openssh-server autossh curl wget vim python3

# Konfigurasi SSH server (password login)
RUN mkdir -p /run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config \
    && echo 'PubkeyAuthentication no' >> /etc/ssh/sshd_config \
    && echo "root:craxid" | chpasswd

# Script entrypoint untuk menjalankan SSH server dan Serveo tunnel
RUN echo '#!/bin/bash' > /entrypoint.sh \
    && echo "/usr/sbin/sshd" >> /entrypoint.sh \
    && echo "sleep 3" >> /entrypoint.sh \
    && echo "echo 'Membuat tunnel ke Serveo...'" >> /entrypoint.sh \
    && echo "ssh -o StrictHostKeyChecking=no -R 0:localhost:22 serveo.net" >> /entrypoint.sh \
    && chmod +x /entrypoint.sh

EXPOSE 22
CMD ["/entrypoint.sh"]
