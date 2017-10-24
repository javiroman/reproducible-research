---
- hosts: all
  tasks:
  - name: Enable writing to NFS volumes with SELinux enforcing on each node virt_use_nfs
    command: setsebool -P virt_use_nfs 1
  - name: Enable writing to NFS volumes with SELinux enforcing on each node virt_sandbox_use_nfs
    command: setsebool -P virt_sandbox_use_nfs 1
...

