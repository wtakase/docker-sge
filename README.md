Docker SGE (Son of Grid Engine)
====

Usage
----
1. Load nfsd module

  ```bash
  modprobe nfsd
  ```

2. Boot NFS servers

  ```bash
  docker run -d --name nfshome --privileged cpuguy83/nfs-server /mnt
  docker run -d --name nfsopt --privileged cpuguy83/nfs-server /mnt
  ```

3. Boot SGE master

  ```bash
  docker run -d -h sgemaster --name sgemaster --privileged --link nfshome:nfshome --link nfsopt:nfsopt wtakase/sge-master
  ```

4. Boot SGE workers

  ```bash
  docker run -d -h sgeworker01 --name sgeworker01 --privileged --link sgemaster:sgemaster --link nfshome:nfshome --link nfsopt:nfsopt wtakase/sge-worker
  docker run -d -h sgeworker02 --name sgeworker02 --privileged --link sgemaster:sgemaster --link nfshome:nfshome --link nfsopt:nfsopt wtakase/sge-worker
  ```

5. Submit job

  ```bash
  docker exec -u sgeuser -it sgemaster bash -c '. /etc/profile.d/sge.sh; echo "/bin/hostname" | qsub'
  docker exec -u sgeuser -it sgemaster cat /home/sgeuser/STDIN.o1
  sgeworker01
  ```
