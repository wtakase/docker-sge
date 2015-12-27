Docker SGE (Son of Grid Engine)
====

Kubernetes All-in-One Usage
----
1. Setup Kubernetes cluster, DNS service, and SGE cluster with number of SGE workers

  Be sure `KUBE_SERVER` set correctly
  ```bash
  export KUBE_SERVER=xxx.xxx.xxx.xxx; ./kubernetes/setup_all.sh 20
  ```

2. Submit Job

  ```bash
  kubectl exec sgemaster -- sudo su sgeuser bash -c '. /etc/profile.d/sge.sh; echo "/bin/hostname" | qsub'
  kubectl exec sgemaster -- sudo su sgeuser bash -c 'cat /home/sgeuser/STDIN.o1'
  ```

3. Add SGE workers

  ```bash
  ./kubernetes/add_sge_workers.sh 10
  ```

Kubernetes Sted-by-Step Usage
----
1. Setup Kubernetes cluster

  ```bash
  ./kubernetes/setup_k8s.sh
  ```

2. Setup DNS service

  Be sure `KUBE_SERVER` set correctly

  ```bash
  export KUBE_SERVER=xxx.xxx.xxx.xxx; ./kubernetes/setup_dns.sh
  ```

3. Check DNS service
  * Boot test client

  ```bash
  kubectl create -f ./kubernetes/skydns/busybox.yaml
  ```

  * Check normal lookup

  ```bash
  kubectl exec busybox -- nslookup kubernetes
  ```

  * Check reverse lookup
  ```bash
  kubectl exec busybox -- nslookup 10.0.0.1
  ```

  * Check pod name lookup

  ```bash
  kubectl exec busybox -- nslookup busybox.default
  ```

4. Setup SGE cluster with number of SGE workers

  ```bash
  ./kubernetes/setup_sge.sh 10
  ```

5. Submit job

  ```bash
  kubectl exec sgemaster -- sudo su sgeuser bash -c '. /etc/profile.d/sge.sh; echo "/bin/hostname" | qsub'
  kubectl exec sgemaster -- sudo su sgeuser bash -c 'cat /home/sgeuser/STDIN.o1'
  ```

6. Add SGE workers

  ```bash
  ./kubernetes/add_sge_workers.sh 10
  ```

Simple Docker Command Usage
----
1. Load nfsd module

  ```bash
  modprobe nfsd
  ```

2. Boot NFS servers

  ```bash
  docker run -d --name nfshome --privileged cpuguy83/nfs-server /exports
  docker run -d --name nfsopt --privileged cpuguy83/nfs-server /exports
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
  ```
