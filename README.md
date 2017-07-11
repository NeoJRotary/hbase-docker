# HBASE 1.3.1 Cluster in Docker
> with Zookeeper 3.4.10

Build from [hadoop-docker](https://github.com/NeoJRotary/hadoop-docker)

### Quick Setup
- Download HBase binary release from [official releases](http://www.apache.org/dyn/closer.cgi/hbase/) and extract to repository folder
- Download Zookeeper release from [official releases](http://zookeeper.apache.org/releases.html#download) and extract to repository folder
- Delete `hbase/docs` to decrease file size
- Delete `zookeeper/docs` to decrease file size
- Follow [hadoop-docker](https://github.com/NeoJRotary/hadoop-docker) to build `hadoop` image and setup docker network
- Run `docker build -t hbase .`
- Run two slave nodes  
`docker run --name hbase-n2 --net hadoop --ip 172.18.1.2 -e MYID="2" -d -it hbase`  
`docker run --name hbase-n3 --net hadoop --ip 172.18.1.3 -e MYID="3" -d -it hbase`
- Run master node  
 `docker run --name hbase-n1 --net hadoop --ip 172.18.1.1 -e ROLE="namenode" -e MYID="1" -p 50070:50070 -p 8088:8088 -p 19888:19888 -p 16010:16010 -p 8880:8880 -it hbase`
- Browse Web UI `http://localhost:16010`
- REST API is running at `http://localhost:8880`

### ENV VAR
- MYID : Zookeeper MYID. Start from 1.  

See [hadoop-docker](https://github.com/NeoJRotary/hadoop-docker) for other ENV VAR.  

### Zookeeper Configuration
System will auto-setup configuration files by `regionservers`. ( or you can just hard-coding your files )  
About server list in `zoo.cfg`, system will auto create it. Remeber to set env `MYID` by the order in  `regionservers`.
  
Read [zookeeper doc/r3.4.10](https://zookeeper.apache.org/doc/r3.4.10/) for detail  

### HBase Configuration
System will auto-setup configuration files by `regionservers`. ( or you can just hard-coding your files )  
  
Read [hbase book](http://hbase.apache.org/book.html) for detail  

### HOSTS
Follow [hadoop-docker](https://github.com/NeoJRotary/hadoop-docker) to setup hadoop hosts.  
  
ENV mode also work for HBase. It will create `regionservers` by your `$HOSTS` then do other configuration.  
Master container example :   
`docker run --name hbase-n1 --net hadoop --ip 172.18.1.1 -h hbase-n1.hadoop -e ROLE="namenode" -e MYID="1" -e MODE="ENV" -e HOSTS="hbase-n1.hadoop,hbase-n2.hadoop,hbase-n3.hadoop" -p 50070:50070 -p 8088:8088 -p 19888:19888 -p 16010:16010 -p 8880:8880 -it hbase`

### REST API
Our default port settings in `hbase-site.xml` is 8880 and 8885.
