# 3D City Database WFS Docker image

This repo contains a Dockerfile for the [3D City Database (3DCityDB) Web Feature Service (WFS)](https://github.com/3dcitydb/web-feature-service). It allows for the *instant* creation of a 3DCityDB WFS instance without having to setup and configure e.g. an Apache Tomcat server and deploy the WFS webapp. The 3DCityDB WFS Docker image was designed to work with [3DCityDB PostGIS Docker containers](https://github.com/tum-gis/3dcitydb-docker-postgis) or any other 3DCityDB instance. The WFS image works with any exisiting 3DCityDB, both *Oracle* or *PostGIS* version are supported.

To get the image visit the [tumgis/3dcitydb-wfs](https://hub.docker.com/r/tumgis/3dcitydb-wfs/) Dockerhub page.

The image provided here is based on the official [Apache Tomcat Docker image](https://hub.docker.com/_/tomcat/) and OpenJDK Java 8. An image based on Oracle Java  cannot be provided here due to licensing conditions.

> **Note:** The content in this repo is in development stage.
> If you experience any problems or have a suggestion/improvement please let me know by creating an [issue](https://github.com/tum-gis/3dcitydb-wfs-docker/issues) or make a contribution with a [pull request](https://github.com/tum-gis/3dcitydb-wfs-dockers/pulls).

## News

* Build status: [![Build Status](https://img.shields.io/travis/tum-gis/3dcitydb-wfs-docker/master.svg?label=master)](https://travis-ci.org/tum-gis/3dcitydb-wfs-docker) [![Build Status](https://img.shields.io/travis/tum-gis/3dcitydb-wfs-docker/devel.svg?label=devel)](https://travis-ci.org/tum-gis/3dcitydb-wfs-docker#devel)
* 2018/09: 3DCityDB WFS v4.0.0 update

## Features

* [Docker Compose](https://docs.docker.com/compose/) file for running a 3DCityDB and a linked 3DCityDB WFS container with a single command

## More 3DCityDB Docker Images

Check out the Docker images for the *3D City Database* and the *3D City Database Web-Map-Client* too:

* [3DCityDB Docker image](https://github.com/tum-gis/3dcitydb-postgis-docker/)
* [3DCityDB Web-Map-Client image](https://github.com/tum-gis/3dcitydb-web-map-docker/)

## Content

* [News](#news)
* [Features](#features)
* [More 3DCityDB Docker Images](#more-3dcitydb-docker-images)
* [Content](#content)
* [Image versions/tags](#image-versionstags)
* [What is the 3D City Database Web Feature Service](#what-is-the-3d-city-database-web-feature-service)
* [How to use this image](#how-to-use-this-image)
  * [Quickstart](#quickstart)
    * [Linux Bash](#linux-bash)
    * [Windows CMD](#windows-cmd)
    * [Test your WFS](#test-your-wfs)
* [Environment variables](#environment-variables)
* [Usage examples](#usage-examples)
  * [3DCityDB WFS with arbitrary 3DCityDB instance](#3dcitydb-wfs-with-arbitrary-3dcitydb-instance)
  * [3DCityDB WFS and 3DCityDB container linking](#3dcitydb-wfs-and-3dcitydb-container-linking)
    * [Run 3DCityDB container](#run-3dcitydb-container)
    * [Run linked 3DCityDB WFS container](#run-linked-3dcitydb-wfs-container)
    * [3DCityDB and linked 3DCityDB WFS with Docker Compose](#3dcitydb-and-linked-3dcitydb-wfs-with-docker-compose)
* [How to build](#how-to-build)
  * [Build parameters](#build-parameters)

## Image versions/tags

* **latest** - Latest stable version based on latest version of the 3DCityDB WFS. Built from [master](https://github.com/tum-gis/3dcitydb-wfs-docker/tree/master) branch.
* **devel** - Development version containing latest features. Based on latest version of the 3DCityDB WFS. Built from [devel](https://github.com/tum-gis/3dcitydb-wfs-docker/tree/devel) branch. **Note: Visit the Github page of the devel branch branch for the [documentation of the latest features](https://github.com/tum-gis/3dcitydb-wfs-docker/tree/devel).**
* **v3.3.0**, **v3.3.1**, **v3.3.2**, **v4.0.0** - Same content as **latest** image, but built with a specific version (**vX.X.X**) of the 3DCityDB WFS.

Use `docker pull tumgis/3dcitydb-wfs:TAG` to download the latest version of the image with the specified `TAG` to your system.

## What is the 3D City Database Web Feature Service

The OGC Web Feature Service (WFS) interface for the 3D City Database enables web-based access to the city objects stored in the database. WFS clients can directly connect to this standardized and open interface for requesting 3D content across the web using platform-independent calls. Users of the 3D City Database are therefore no longer limited to using the [Importer/Exporter](https://github.com/3dcitydb/importer-exporter) tool for data retrieval. The Web feature services allows clients to only retrieve the city objects they are seeking, rather than retrieving a file that contains the data they are seeking and possibly much more.

The 3D City Database WFS interface is implemented against the latest version 2.0 of the [OGC Web Feature Service standard](http://www.opengeospatial.org/standards/wfs) and hence is compliant with ISO 19142:2010. Previous versions of the WFS standard are not supported. The implementation currently satisfies the `Simple WFS` conformance class. The development of the WFS is led by the company [virtualcitySYSTEMS](http://www.virtualcitysystems.de/) which offers an extended version of the WFS with additional functionalities that go beyond the Simple WFS class (e.g., thematic and spatial filter capabilities and transaction support). This additional functionality may be fed back to the open source project in future releases.

![3DCityDB](https://www.3dcitydb.org/3dcitydb/fileadmin/default/templates/images/logo.jpg "3DCityDB logo")
> [3DCityDB Official Homepage](https://www.3dcitydb.net/)  
> [3DCityDB WFS Github](https://github.com/3dcitydb/web-feature-service)  
> [3DCityDB Github](https://github.com/3dcitydb/3dcitydb)  
> [CityGML Official Homepage](https://www.citygml.org/)  
> [3DCityDB and CityGML Hands-on Tutorial](https://www.gis.bgu.tum.de/en/projects/3dcitydb/#c1425)

## How to use this image

In this section you will find information on how to work with the 3DCityDB WFS Docker image. For a comprehensive description of all *environment variables* and *usage examples* look further below. For building your own image scroll down to the *build* section at the bottom.

### Quickstart

To quickly get a 3DCityDB WFS instance running on Docker adapt the environment variable `-e` switches and the `-p` switch in the example below according to your needs. Use the environment variables to set the connection credentials for the 3DCityDB instance the WFS should use as data source.
The `-p <host port:docker port>` switch of the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) command allows you to specify on which port the 3DCityDB WFS instance will listen on your host system. For instance, use `-p 8765:8080` if you want to access the WFS instance on port *8765* of the system hosting the WFS Docker container.

#### Linux Bash

```bash
docker run --name "citydb-wfs-container" -it -p 8080:8080 \
    -e "CITYDB_CONNECTION_TYPE=PostGIS" \
    -e "CITYDB_CONNECTION_SERVER=my.citydb.host.de" \
    -e "CITYDB_CONNECTION_PORT=5432" \
    -e "CITYDB_CONNECTION_SID=citydb" \
    -e "CITYDB_CONNECTION_USER=postgres" \
    -e "CITYDB_CONNECTION_PASSWORD=postgres" \
  tumgis/3dcitydb-wfs
```

#### Windows CMD

```bat
docker run --name "citydb-wfs-container" -it -p 8080:8080^
    -e "CITYDB_CONNECTION_TYPE=PostGIS"^
    -e "CITYDB_CONNECTION_SERVER=my.citydb.host.de"^
    -e "CITYDB_CONNECTION_PORT=5432"^
    -e "CITYDB_CONNECTION_SID=citydb"^
    -e "CITYDB_CONNECTION_USER=postgres"^
    -e "CITYDB_CONNECTION_PASSWORD=postgres"^
  tumgis/3dcitydb-wfs
```

> **Note:**
> In the examples above long commands are broken to several lines for readability using the Bash (`\`) or CMD (`^`) line continuation.  

#### Test your WFS

When the 3DCityDB WFS has started successfully there are two ways to access the service. We assume the hostname and port of your Docker host are `my-docker-host`:`8080`. The *interactive browser interface* for sending `POST` requests is available here:  
`http://my-docker-host:8080/citydb-wfs/wfsclient`  
The *OGC WFS interface* for `GET`requests is available here:  
`http://my-docker-host:8080/citydb-wfs/wfs?`

To test if your WFS is operational issue a `getCapabilities` request. You can either use the `GET` method or send a `POST` request. To issue a `GET` request open the following URL in your browser:  
`http://my-docker-host:8080/citydb-wfs/wfs?SERVICE=WFS&REQUEST=GetCapabilities`

To send a `POST` request copy the following `XML` to the web interface *WFS Request* field and hit the *send* button.

```xml
<?xml version="1.0" ?>
<GetCapabilities
   service="WFS"
   xmlns="http://www.opengis.net/wfs/2.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.opengis.net/wfs/2.0
                       http://schemas.opengis.net/wfs/2.0/wfs.xsd"
/>
```

## Environment variables

To run the 3DCityDB WFS Docker image you need to adapt the environment variables specifying the the connection details of the 3DCityDB instance the WFS should operate on. The table below gives an overview on the currently available configuration parameters. If a parameter is omitted in the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) call, its default value from the table is used.

| Parameter name             | Description                                                      | Default value     |
|----------------------------|----------------------------------------                          |-------------------|
| TOMCAT_MAX_HEAP            | Maximum heap space available for Tomcat (Java -Xmx switch). Format: &lt;size&gt;[g&#124;G&#124;m&#124;M&#124;k&#124;K], as described [here](https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html).    | *1024m*           |
| CITYDB_CONNECTION_TYPE     | Database type, either *PostGIS* or *Oracle*.                     | *PostGIS*         |  
| CITYDB_CONNECTION_SERVER   | Database server hostname or IP address.                          | *localhost*     |
| CITYDB_CONNECTION_PORT     | Database server port.                                            | *5432*            |
| CITYDB_CONNECTION_SID      | Database SID (Oracle) or database name (PostGIS).                | *citydb* |
| CITYDB_CONNECTION_USER     | Database user name.                                              | *postgres*        |
| CITYDB_CONNECTION_PASSWORD | Database user password.                                          | *postgres*|

> **Note:**  
> The 3DCityDB WFS Docker image provided here is based on the official [Apache Tomcat Docker image](https://hub.docker.com/_/tomcat/). Take a look at the documentation for configuration options for Tomcat.

## Usage examples

Below some examples on how to run the 3DCityDB WFS Docker image are given. By *running* an image, a *container* is created from it. To get familiar with the terms *image* and *container* take a look at the [official Docker documentation](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/).

A 3DCityDB WFS Docker container can be setup to use an arbitrary 3DCityDB instance. Below three example use cases are given.  
The first use case shows how to run a 3DCityDB WFS Docker container for a 3DCityDB instance on an arbitrary host.  
The second use case shows how to run a 3DCityDB WFS and Docker container and *link* it to a 3DCityDB Docker container running on the same Docker daemon. To get familiar with [Docker container links](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/) take a look at the official documentation.  
The third use case show how to run the containers of use case tow in a single command using [Docker Compose](https://docs.docker.com/compose/).

### 3DCityDB WFS with arbitrary 3DCityDB instance

The 3DCityDB WFS container used in the example below is named *citydb-wfs-container* and based on the image named *tumgis/3dcitydb-wfs*. We want our WFS to be accessible on port `8765`.

```text
Type        Oracle
Hostname    my.citydb.host.de
Port        1521
SID         citydb
User        citydbuser
Password    changeMe!
```

To run a 3DCityDB WFS container for the 3DCityDB instance described above use the following commands. Take a look at the *Quickstart* section above to learn how to access your WFS when it's running.

```bash
# run container in foreground mode
docker run --name "citydb-wfs-container" -it -p 8765:8080 \
    -e "CITYDB_CONNECTION_TYPE=Oracle" \
    -e "CITYDB_CONNECTION_SERVER=my.citydb.host.de" \
    -e "CITYDB_CONNECTION_PORT=1521" \
    -e "CITYDB_CONNECTION_USER=citydbuser" \
    -e "CITYDB_CONNECTION_PASSWORD=changeMe!" \
    -e "CITYDB_CONNECTION_SID=citydb" \
  tumgis/3dcitydb-wfs

# run container in foreground mode with interactive bash shell, e.g. for making changes to the container
docker run --name "citydb-wfs-container" -it -p 8765:8080 \
    -e "CITYDB_CONNECTION_TYPE=Oracle" \
    -e "CITYDB_CONNECTION_SERVER=my.citydb.host.de" \
    -e "CITYDB_CONNECTION_PORT=1521" \
    -e "CITYDB_CONNECTION_USER=citydbuser" \
    -e "CITYDB_CONNECTION_PASSWORD=changeMe!" \
    -e "CITYDB_CONNECTION_SID=citydb" \
  tumgis/3dcitydb-wfs bash

# run container in detached (background) mode
docker run --name "citydb-wfs-container" -dit -p 8765:8080 \
    -e "CITYDB_CONNECTION_TYPE=Oracle" \
    -e "CITYDB_CONNECTION_SERVER=my.citydb.host.de" \
    -e "CITYDB_CONNECTION_PORT=1521" \
    -e "CITYDB_CONNECTION_USER=citydbuser" \
    -e "CITYDB_CONNECTION_PASSWORD=changeMe!" \
    -e "CITYDB_CONNECTION_SID=citydb" \
  tumgis/3dcitydb-wfs

# Some useful docker commands for this container
docker logs citydb-container    # Retrieve the log of the container, useful for debugging
docker ps -a                    # list all running and stopped containers
docker port citydb-container    # show the port mapping for the container
docker stop citydb-container    # stop the container
docker start citydb-container   # start the container
docker rm citydb-container      # remove a container
docker rm -fv citydb-container  # remove the container with all its data !! DANGERZONE !!
docker exec -it citydb-container bash  # get an interactive bash shell on a running container
```

> **Note:**  
> In the examples above long commands are broken to several lines for readability using bash line continue ("\").

### 3DCityDB WFS and 3DCityDB container linking

Let's assume want to host a 3DcityDB and a 3DcityDB WFS form the same host using Docker. This can be done using [Docker container links](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/). When containers are linked, information about a source container can be sent to a recipient container. This allows the recipient to see selected data describing aspects of the source container.
For instance, if a 3DCityDB WFS container is linked to a 3DCityDB container, the 3DCityDB WFS running in the WFS container can access the 3DCityDB container and query its database to respond to WFS requests. To establish links, Docker relies on *container names*. The example below shows how to create a 3DCityDB container and a 3DCityDB WFS container linked to it.

#### Run 3DCityDB container

First, we run a 3DCityDB container, as described [here](https://github.com/tum-gis/3dcitydb-docker-postgis#usage-examples). We name it: *citydb-container* unsing the `--name` switch of [`docker run`](https://docs.docker.com/engine/reference/commandline/run/). In step (2) you will see how this *container name* is used for linking the WFS container.

  ```bash
  docker run --name "citydb-container" -d -p 1234:5432 \
      -e "POSTGRES_USER=wfsuser" \
      -e "POSTGRES_PASSWORD=wfspw" \
      -e "CITYDBNAME=mycitydb" \
      -e "SRID=31468" \
      -e "SRSNAME=urn:adv:crs:DE_DHDN_3GK4*DE_DHN92_NH" \
    tumgis/3dcitydb-postgis
  ```

#### Run linked 3DCityDB WFS container

Second, we run a 3DCityDB WFS container as described in the examples above. Note the usage of the `--link <container name or id>:<alias>` switch of [`docker run`](https://docs.docker.com/engine/reference/commandline/run/). With `<container name or id>` we specify the container we want to link to. In this example we use the container name of the 3DCityDB container we created in step (1). The `<alias>` is an alias for the link name we're creating.  
>**Important:** The alias is set as *hostname* for the container we are linking to. Hence, we can "talk" to the 3DCityDB container from the WFS container using that hostname.  

  In this example we set *citydb-container-alias* as `alias`.

  ```bash
  # Note the link alias and the CITYDB_CONNECTION_SERVER parameter having the same value!
  
  docker run --name "citydb-wfs-container" -d -p 8765:8080 \
      --link "citydb-container:citydb-container-alias" \
      -e "TOMCAT_MAX_HEAP=2048m" \
      -e "CITYDB_CONNECTION_SERVER=citydb-container-alias" \
      -e "CITYDB_CONNECTION_USER=wfsuser" \
      -e "CITYDB_CONNECTION_PASSWORD=wfspw" \
      -e "CITYDB_CONNECTION_SID=mycitydb" \
    tumgis/3dcitydb-wfs
  ```

Now you have a 3DCityDB and a 3DCityDB WFS runing! Take a look at the *Quickstart* section above to learn how to access your WFS when it's running.

#### 3DCityDB and linked 3DCityDB WFS with Docker Compose

Docker Compose is a tool for defining and running multi-container Docker applications. To learn more about Compose refer to the [official documentation](https://docs.docker.com/compose/). With Compose, you use a `YAML` file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.

In this repository a Compose `YAML` for running a 3DcityDB container with a linked 3DCityDB WFS container is provided. To use it, first clone this repository to your Docker host. Second, edit the environment of both the 3DCityDB and the 3DCityDB WFS service in the `docker-compose.yml` file.

When editing `docker-compose.yml` make sure to provide the correct 3DCityDB server credentials in the `command` section of the 3DCityDB WFS service. Use the *link alias* as hostname for the 3DCityDB container (see explanation in example use case 2)!

To start the 3DCityDB + 3DCityDB WFS services run [`docker-compose up`](https://docs.docker.com/compose/reference/up/). To remove the services use [`docker-compose down`](https://docs.docker.com/compose/reference/down/). More [Docker Compose](https://docs.docker.com/compose/) commands are available in the [official documentation](https://docs.docker.com/compose/reference/overview/).

```bash
# 1. Clone this repo using git:
git clone https://github.com/tum-gis/3dcitydb-wfs-docker.git
cd 3dcitydb-wfs-docker  # switch to cloned directory
git checkout devel      # for now, switch to devel branch

# 2. Edit docker-compose.yml according to your needs

# 3. Run 3DCityDB and 3DCityDB WFS services
docker-compose up

# 4. Remove services if not needed anymore
docker-compose down
```

## How to build

To build a 3DCityDB Docker image from the Dockerfile in this repo yourself you simply need to download the source code from this repo and run the [`docker build`](https://docs.docker.com/engine/reference/commandline/build/) command. Follow the step below to build a 3DCityDB WFS Docker image or use the [`build.sh`](https://github.com/tum-gis/3dcitydb-wfs-docker/blob/master/build.sh) script.

```bash
# 1. Download source code using git.
git clone https://github.com/tum-gis/3dcitydb-wfs-docker.git
# 2. Change to the source folder you just cloned.
cd 3dcitydb-wfs-docker
# 3. Build a docker image tagged as 3dcitydb-wfs.
docker build -t tumgis/3dcitydb-wfs .
```

If the build succeeds, you are ready to run the image as described above. To list all locally available images run [`docker images`](https://docs.docker.com/engine/reference/commandline/images/).

### Build parameters

To build a Docker image with a custom *Tomcat base image*, a specific *3DCityDB WFS version*, or a custom *web app context path*, the [`docker build --build-arg`](https://docs.docker.com/engine/reference/commandline/build/) parameter is used.

| Parameter name          | Description                            | Default value     |
|-------------------------|----------------------------------------|-------------------|
| baseimage_tag           | Tag of the Tomcat base image to use. A list of all available tags is available [here](https://hub.docker.com/_/tomcat/). | *8.5-jre8* |
| citydb_wfs_version      | Version of the 3DCityDB WFS            | *v4.0.0*           |
| citydb_wfs_context_path | Context path of the 3DCityDB WFS. `http://[host][:port]/[context-path]/` | *citydb-wfs* |

> **Note:**  
> Currently, only 3DCityDB WFS versions `v3.3.0`, `v3.3.1`, `v3.3.2` and `v4.0.0` are supported. The image has been successfully tested with the `tomcat-8.5jre8` base image. According to the [official documentation](https://github.com/3dcitydb/web-feature-service#system-requirements), the 3DcityDB WFS requires Java 8. Java 7 or earlier are not supported.

Build example:

```bash
docker build \
    --build-arg "baseimage_tag=8.5.28-jre8" \
    --build-arg "citydb_wfs_version=3.3.1" \
    --build-arg "citydb_wfs_context_path=wfs" \
  -t tumgis/3dcitydb-wfs:v3.3.1 .
```
