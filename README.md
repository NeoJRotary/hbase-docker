# HBASE 1.3.1 Cluster in Docker
> with Zookeeper 3.4.10

Build from [hadoop-docker](https://github.com/NeoJRotary/hadoop-docker)

### Quick Setup
- Download HBase binary release from [official releases](http://www.apache.org/dyn/closer.cgi/hbase/) and extract to repository folder
- Download Zookeeper release from [official releases](http://zookeeper.apache.org/releases.html#download) and extract to repository folder
- Delete `hbase/docs` to decrease file size
- Delete `zookeeper/docs` to decrease file size
- Follow [hadoop-docker](https://github.com/NeoJRotary/hadoop-docker) to build `hadoop` image
- Run `docker build -t hbase .`
- Create new docker network `docker network create --subnet 172.18.0.0/16 hadoop`
- Run two slave container  
`docker run --name hbase-s1 --net hadoop --ip 172.18.1.1  -e HOSTNAME="slave01" -e ZK_MYID="1" -it hbase /hbase.sh`  
`docker run --name hbase-s2 --net hadoop --ip 172.18.1.2  -e HOSTNAME="slave02" -e ZK_MYID="2" -it hbase /hbase.sh`
- Run master container  
 `docker run --name hbase-m --net hadoop --ip 172.18.1.0 -p 8085:8085 -p 16010:16010 -p 9095:9095 -p 50070:50070 -p 8088:8088 -p 19888:19888 -e HOSTNAME="master" -e ZK_MYID="0" -e FORMAT="true" -it hbase /hbase.sh`
- Browse Web UI `http://localhost:16010`

### Zookeeper Configuration
Please read [doc/r3.4.10](https://zookeeper.apache.org/doc/r3.4.10/)  
If you want to change myid, remember to set env "ZK_MYID" in docker command

### HBase Configuration
Please read [book](http://hbase.apache.org/book.html)  

### HOSTS
Follow [hadoop-docker](https://github.com/NeoJRotary/hadoop-docker) to setup hadoop hosts first.  
Update `zoo.cfg`, `regionservers` and `hbase-site.xml`
