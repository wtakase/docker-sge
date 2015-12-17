Docker SGE (Son of Grid Engine)
====

Usage
----
* Boot NFS servers
```bash
docker run -d --name nfshome --privileged cpuguy83/nfs-server /exports
docker run -d --name nfsopt --privileged cpuguy83/nfs-server /exports
```

* Boot SGE master
```
docker run -d -h sgemaster --name sgemaster --privileged --link nfshome:nfshome --link nfsopt:nfsopt wtakase/sge-master
```

* Boot SGE worker
```
docker run -d -h sgeworker --name sgeworker --privileged --link sgemaster:sgemaster --link nfshome:nfshome --link nfsopt:nfsopt wtakase/sge-worker
```

* Register worker node
```
docker exec -it sgemaster bash -c 'source /opt/sge/default/common/settings.sh; qconf -ah sgeworker; qconf -as sgeworker'
```

* Execute worker node install script
```
docker exec -it sgeworker bash -c 'cd /opt/sge; ./inst_sge -x -auto ./install_sge_worker.conf -nobincheck -noremote'
```

* Submit simple job
```
docker exec -u sgeuser -it sgemaster bash -c 'source /opt/sge/default/common/settings.sh; echo "date; hostname" >> ~/test.sh; chmod u+x ~/test.sh; qsub ~/test.sh'
```

* Check output
```
docker exec -u sgeuser -it sgemaster cat /home/sgeuser/test.sh.o1
Thu Dec 17 00:48:54 UTC 2015
sgeworker
```
