# 3D City Database WFS Docker image
This is the git repo of the (not yet, but hopefully soon to become) [official image](https://docs.docker.com/docker-hub/official_repos/) 
for the [3D City Database (3DCityDB) Web Feature Service(WFS)](https://github.com/3dcitydb/web-feature-service).
It allows for the *instant* creation of a 3DCityDB WFS instance without having to setup and configure an e.g. Apache Tomcat server and deploy the WFS webapp.
The 3DCityDB WFS Docker image was designed to work with [3DCityDB Docker containers](https://github.com/tum-gis/3dcitydb-docker) or any other 3DCityDB instance.
All you need is a [Docker](https://www.docker.com/what-docker) installation and the image provided here.
Detailed information on how to get and setup Docker on your system is provided in the [official documentation](https://docs.docker.com/engine/installation/).

The 3DCityDB WFS Docker image provided here is based on the official [Apache Tomcat Docker image](https://hub.docker.com/_/tomcat/). 
Hence, an OpenJRE Java 8 environment is used. 
A fork based on Oracle Java 8 may be released in the future. 
However, the Oracle Java JRE has to be "bought" for no cost on [Docker Store](https://store.docker.com/images/oracle-serverjre-8) before usage due to licensing conditions which causes some usability constraints.

> **Note:**  
> **Everything you find in this repo is in an early testing stage.**  
> If you experience any problems or see possible enhancements please let me know by creating a new issue [here](https://github.com/tum-gis/3dcitydb-docker/issues).

## Quick start
For a quick run of the 3DCityDB Docker image first either [pull](#tum-gis-registry) (recommended) or [download](#get-docker-image) the ready-to-run 3DCityDB Docker image or create a fresh [build](#how-to-build).
Second, when the 3DCityDB Docker image is available on your system see the documentation and examples on how to [run](#how-to-run-the-3dcitydb-docker-image) the 3DCityDB Docker image.

## Content
* **[Setup and usage](#setup-and-usage)**
  * [Get the 3DCityDB WFS Docker image](#get-docker-image)
    * [TUM-GIS Docker registry](#tum-gis-registry)
    * [Docker image import/export](#docker-import-export) 
* **[How to run the 3DCityDB WFS Docker image](#how-to-run-the-3dcitydb-wfs-docker-image)**
  * [Parameter overview](#parameter-overview)
  * [Usage examples](#usage-examples)
    * [3DCityDB WFS container for arbitrary 3DCityDB instance](#usage-example-arbitrary)
    * [3DCityDB WFS container linked to a 3DCityDB container](#usage-example-linked) 
* **[How to build](#how-to-build)**
  * [Build parameters](#build-parameters)

<a name="get-docker-image"></a>
## Get the 3DCityDB WFS Docker image
The best way of sharing Docker images is with a [Docker registry](https://docs.docker.com/registry/). 
A registry allows for the distribution of Docker images with the [`docker pull`](https://docs.docker.com/engine/reference/commandline/pull/#usage) 
and [`docker push`](https://docs.docker.com/engine/reference/commandline/push/) commands.
The official Docker registry offering 100,000+ free apps is called [Docker Hub](https://hub.docker.com/).

Currently, the 3DCityDB WFS Docker image has not been released to the public, it is not (jet) available on [Docker Hub](https://hub.docker.com/).
Meanwhile, three options are available to get the 3DCityDB WFS Docker image:
* [Pull image from TUM-GIS Docker registry](#tum-gis-registry)
* [Download and import image](#docker-import-export)
* [Build image](#how-to-build)

<a name="tum-gis-registry"></a>
### TUM-GIS Docker registry
The TUM-GIS Docker registry is a Docker registry set up at a server at TUM, Chair of Geoinformatics. 
It is meant for testing purpose and **only reachable within the TUM network**.
Follow the steps below to obtain the 3DCityDB WFS Docker image from there:

1. Import SSL certificate  
First, download the self-signed SSL certificate of the TUM-GIS Docker registry.
Depending on your operating system use the *x509* or *pfx/p12* certificate format.  
   * x509:    [x509 SSL certificate download](https://www.3dcitydb.org/3dcitydb/fileadmin/public/3dcitydb-docker/domain.crt)
   * pfx/p12: [pfx SSL certificate download](https://www.3dcitydb.org/3dcitydb/fileadmin/public/3dcitydb-docker/domain.pfx)

2. Import SSL certificate  
After downloading the SSL certificate, you need to install it on your system. 
The certificate install process varies for different operation system:
   * Windows: Right-click certificate (x509) file and select *Install certificate*.
     Follow the instructions of the install wizard and leave all options at their defaults.
  
   * MAC OSX: A guide for install SSL certificates can be found [here](https://www.sslsupportdesk.com/how-to-import-a-certificate-into-      mac-os/).
   * Other operating systems: Google -> "myOS SSL certificate install"
  
3. Restart Docker  
To make sure the new certificate is known to Docker restart Docker. 
If the certificate seems not to be known after restarting Docker, retry the install process and reboot your system.

4. Pull the 3DCityDB Docker image  
Now you should be able to access the TUM-GIS Docker registry and pull images from it using [`docker pull`](https://docs.docker.com/engine/reference/commandline/pull/#usage).
```bash
docker pull tum-gis-testserver.duckdns.org/3dcitydb-wfs           # latest image (3DCityDB v.3.3.2)
docker pull tum-gis-testserver.duckdns.org/3dcitydb-wfs:v3.3.1    # 3DCityDB v.3.3.1
```
After the image has been pulled successfully you are ready to [run](#how-to-run-the-3dcitydb-docker-image) the image.

<a name="docker-import-export"></a>
### Docker image import/export
To import a Docker image on your local system the docker [`docker load`](https://docs.docker.com/engine/reference/commandline/load/) command can be used.
First, download the 3DCityDB WFS Docker image here:  
DOWNLOAD: [**3DCityDB WFS Docker TESTING image**](https://www.3dcitydb.org/3dcitydb/fileadmin/public/3dcitydb-docker/3dcitydb-wfs.tar.gz)

To find out what images exist on your system run [`docker images`](https://docs.docker.com/engine/reference/commandline/images/). 
You will receive an output similar to this:
```
$: docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
3dcitydb-wfs        v3.3.1              77a8de7511a4        About an hour ago   571 MB
3dcitydb-wfs        latest              fd09441a5d01        About an hour ago   571 MB
3dcitydb-wfs        v3.3.2              fd09441a5d01        About an hour ago   571 MB
3dcitydb            v3.0.0              fe899259546c        2 days ago          719 MB
3dcitydb            latest              b204c582dfd9        2 days ago          719 MB
3dcitydb            v3.3.1              b204c582dfd9        2 days ago          719 MB
bash                latest              a853bea42baa        3 weeks ago         12.2 MB
tomcat              8.5.24-jre8         3dcfe809147d        3 weeks ago         558 MB
postgres            10                  ec61d13c8566        3 weeks ago         287 MB
postgres            10.1                ec61d13c8566        3 weeks ago         287 MB
postgres            latest              ec61d13c8566        3 weeks ago         287 MB
mdillon/postgis     10                  e5b3e97d100b        7 weeks ago         697 MB
mdillon/postgis     latest              e5b3e97d100b        7 weeks ago         697 MB
```

To save and *gzip* compress a Docker image run:
```bash
docker image save <repository[:tag]|image id> | gzip > <archiveName>.tar.gz

# example: 3dcitydb-wfs image
docker image save 3dcitydb-wfs | gzip > 3dcitydb-wfs.tar.gz
# example: postgresql 10.1 image
docker image save postgres:10.1 | gzip > "postgres-10.1.tar.gz"
docker image save ec61d13c8566 | gzip > "postgres-10.1.tar.gz"
```
To share an image, you simply need to provided the archive file.
To import the image on another system run:
```bash
gunzip -c <archiveName> | docker image load

# example: 3dcitydb-wfs image
gunzip -c 3dcitydb-wfs.tar.gz | docker image load
# if super user is required try following for a Ubuntu system:
sudo sh -c 'gunzip -c 3dcitydb-wfs.tar.gz | docker image load'
```
After the import has completed, you are ready to [run](#how-to-run-the-3dcitydb-docker-image) from the image.

<a name="how-to-run-the-3dcitydb-wfs-docker-image"></a>
## How to run the 3DCityDB WFS Docker image
Below some examples on how to run the 3DCityDB WFS Docker image are given. By *running* an image, a *container* is created from it. 
To get familiar with the terms *image* and *container* take a look at the [official Docker documentation](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/).

The `-p <host port:docker port>` switch of the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) 
command allows you to specify on which port the 3DCityDB WFS instance will listen on your host system.
For instance, use `-p 8765:8080` if you want to access the WFS instance on port *8765* of the system hosting the Docker container.

<a name="parameter-overview"></a>
### Parameter overview
To run the 3DCityDB WFS Docker image you need to adapt the environment variables specifying the the connection details 
of the 3DCityDB instance the WFS should operate on.
The table below gives an overview on the currently available configuration parameters. 
If a parameter is omitted in the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) call,
its default value from the table is used.

| Parameter name             | Description                                                      | Default value     |
|----------------------------|----------------------------------------                          |-------------------|
| TOMCAT_MAX_HEAP            | Maximum heap space available for Tomcat (Java -Xmx switch). Format: <size>[g&#124;G&#124;m&#124;M&#124;k&#124;K], as described [here](https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html).    | *1024m*           |                          
| TOMCAT_MAX_HEAP            | Maximum permanent space available for Tomcat (Java -XX:MaxPermSize switch). Format: <size>[g&#124;G&#124;m&#124;M&#124;k&#124;K], as described [here](https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html).    | *512m*            |         
| CITYDB_CONNECTION_TYPE     | Database type, either *PostGIS* or *Oracle*.                     | *PostGIS*         |  
| CITYDB_CONNECTION_SERVER   | Database server hostname or IP address.                          | *citydb-host*     |
| CITYDB_CONNECTION_PORT     | Database server port.                                            | *5432*            |
| CITYDB_CONNECTION_SID      | Database SID (Oracle) or database name (PostGIS).                | *3dcitydb-docker* |
| CITYDB_CONNECTION_USER     | Database user name.                                              | *postgres*        |      
| CITYDB_CONNECTION_PASSWORD | Database user password.                                          | Empty password: ""|

> **Note:**  
> The 3DCityDB WFS Docker image provided here is based on the official 
[Apache Tomcat Docker image](https://hub.docker.com/_/tomcat/). Take a look at the documentation for more settings.

<a name="usage-examples"></a>
### Usage examples
A 3DCityDB WFS Docker container can be set to use an arbitrary 3DCityDB instance. Below two example use cases are given.
The first use case shows how to run the 3DCityDB Docker container and connect it to a 3DCityDB instance on an arbitrary host.

The second use case shows how to run a 3DCityDB WFS Docker container and *link* it to a 3DCityDB Docker container running on the same 
Docker daemon. To get familiar with [Docker container links](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/)
take a look at the official documentation.

<a name="usage-example-arbitrary" />
#### 3DCityDB WFS container for arbitrary 3DCityDB instance
The 3DCityDB WFS container used in the example below is named *citydb-wfs-container* and 
based on the image named *3dcitydb-wfs*.
The example 3DCityDB instance the WFS uses is:
```
Type        PostGIS
Server      my.citydb.host.de
Port        5432
Sid         citydb
User        citydbuser
Password    changeMe!
```

To create and run a 3DCityDB WFS container for the 3DCityDB instance described above use the following commands:
```bash
# list all locally available images
docker images

# run container in foreground mode
docker run --name "citydb-wfs-container" -it -p 8765:8080 \
  -e "CITYDB_CONNECTION_SERVER=my.citydb.host.de" \
  -e "CITYDB_CONNECTION_USER=citydbuser" \
  -e "CITYDB_CONNECTION_PASSWORD=changeMe!" \
  -e "CITYDB_CONNECTION_SID=citydb" \
  3dcitydb-wfs

# run container in foreground mode with interactive bash shell, e.g. for making changes to the container
docker run --name "citydb-wfs-container" -it -p 8765:8080 \
  -e "CITYDB_CONNECTION_SERVER=my.citydb.host.de" \
  -e "CITYDB_CONNECTION_USER=citydbuser" \
  -e "CITYDB_CONNECTION_PASSWORD=changeMe!" \
  -e "CITYDB_CONNECTION_SID=citydb" \
  3dcitydb-wfs bash

# run container in detached (background) mode
docker run --name "citydb-wfs-container" -d -p 8765:8080 \
  -e "CITYDB_CONNECTION_SERVER=my.citydb.host.de" \
  -e "CITYDB_CONNECTION_USER=citydbuser" \
  -e "CITYDB_CONNECTION_PASSWORD=changeMe!" \
  -e "CITYDB_CONNECTION_SID=citydb" \
  3dcitydb-wfs

# Container commands
docker ps -a                  # list all running and stopped containers
docker port citydb-container  # show the port mapping for the container named citydb-container
docker stop citydb-container  # stop a running container
docker start citydb-container # start a stopped container
docker rm citydb-container    # remove a container
```
> **Note:**  
> In the examples above long commands are broken to several lines for readability using bash line continue ("\").

<a name="usage-example-linked" />
#### 3DCityDB WFS container linked to a 3DCityDB container
Let's assume you are hosting a 3DCityDB container and want to add a WFS within the same Docker daemon to it.
This can be done using [Docker container links](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/).
When containers are linked, information about a source container can be sent to a recipient container.
This allows the recipient to see selected data describing aspects of the source container.
For instance, if a 3DCityDB WFS container is linked to a 3DCityDB container, the 3DCityDB WFS running in the WFS container 
can access the 3DCityDB container and query its database to respond to WFS requests.

To establish links, Docker relies on the names of your containers. The example below shows how to create a 3DCityDB container
and a 3DCityDB WFS container linked to it.

> **Note:**  
> In the examples below long commands are broken to several lines for readability using bash line continue ("\").
 
1. *Run 3DCityDB container*  
First, we run a 3DCityDB container, as described [here](https://github.com/tum-gis/3dcitydb-docker#how-to-run-the-3dcitydb-docker-image). 
We name it: *citydb-container*.
In step (2) you will see how this container name is used for linking the WFS container.
```bash
docker run --name "citydb-container" -d -p 1234:5432 \
    -e "POSTGRES_USER=wfsuser" \
    -e "POSTGRES_PASSWORD=wfspw" \
    -e "CITYDBNAME=mycitydb" \
    -e "SRSNAME=urn:adv:crs:DE_DHDN_3GK4*DE_DHN92_NH" \
    -e "SRSNO=31468" \
    3dcitydb
```

2. *Run linked 3DCityDB WFS container*  
Second, we run a 3DCityDB WFS container as described in the examples above. 
Note the usage of the `--link <name or id>:<alias>` switch of [`docker run`](https://docs.docker.com/engine/reference/commandline/run/).
With `<name or id>` we specify the container we want to link to. 
In this example we use the container name of the 3DCityDB container we created in step (1).  
The `<alias>` is an alias for the link name we're creating.
**Important:** The alias is set as *hostname* for the container we are linking to.
Hence, we use the alias as server hostname when running the 3DCityDB WFS container. 
In this example we set *citydb-container-alias* as alias.
```bash
# Note the link alias and the CITYDB_CONNECTION_SERVER parameter having the same value!
docker run --name "citydb-wfs-container" -d -p 8765:8080 \
    --link "citydb-container":"citydb-container-alias" \
    -e "TOMCAT_MAX_HEAP=2048m" \
    -e "TOMCAT_MAX_PERM_SIZE=1024m" \
    -e "CITYDB_CONNECTION_SERVER=citydb-container-alias" \
    -e "CITYDB_CONNECTION_USER=wfsuser" \
    -e "CITYDB_CONNECTION_PASSWORD=wfspw" \
    -e "CITYDB_CONNECTION_SID=mycitydb" \
    3dcitydb-wfs
```

3. Now you should have both a 3DCityDB and a 3DCityDB WFS running. 
If you setup the WFS container according to this example, your WFS can be tested by opening the URL below
in a web browser, where *myDockerHost* needs to be replaced with the hostname/IP address of your Docker host.  
[http://myDockerHost:8764/citydb-wfs/wfs?service=WFS&version=1.1.0&request=GetCapabilities]()  

## How to build
Building an image from the Dockerfile in this repo is easy. 
You simply need to download the source code from this repo and run the 
[`docker build`](https://docs.docker.com/engine/reference/commandline/build/) command. 
Follow the step below to build a 3DCityDB WFS Docker image.

```bash
# 1. Download source code using git. 
git clone https://github.com/tum-gis/3dcitydb-wfs-docker.git
# 2. Change to the source folder you just cloned.
cd 3dcitydb-wfs-docker
# 3. Build a docker image tagged as 3dcitydb-wfs.
docker build -t 3dcitydb-wfs .
```

If the build succeeds, you are ready to run the image as described above.
To list all locally available images run [`docker images`](https://docs.docker.com/engine/reference/commandline/images/). 

<a name="build-parameters"></a>
### Build parameters
To build a Docker image with a specific 3DCityDB WFS version or a custom web app context path, 
the [`docker build --build-arg`](https://docs.docker.com/engine/reference/commandline/build/) parameter can be used.

**Note:** This feature has only been tested with 3DCityDB WFS version *3.3.1* so far.

| Parameter name          | Description                            | Default value     |
|-------------------------|----------------------------------------|-------------------|
| citydb_wfs_version      | Version of the 3DCityDB WFS            | *3.3.2*           |
| citydb_wfs_context_path | Context path of the 3DCityDB WFS. [http://[host][:port]/[context-path]/]() | *citydb-wfs* |

Build example:
```bash
docker build \
    --build-arg "citydb_wfs_version=3.3.1" \
    --build-arg "citydb_wfs_context_path=wfs" \
    -t 3dcitydb-wfs:v3.3.1 .
```
> **Note:**  
> In the example above long commands are broken to several lines for readability using bash line continue ("\").
 
