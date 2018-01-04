#!/bin/sh
# 3DCityDB WFS Docker ENTRYPONT ###############################################

# Print commands and their arguments as they are executed
set -e;

# Update tomcat opts ##########################################################
if [ -z ${TOMCAT_MAX_HEAP+x} ]; then
  export TOMCAT_MAX_HEAP=1024m;
fi

if [ -z ${TOMCAT_MAX_PERM_SIZE+x} ]; then
  export TOMCAT_MAX_PERM_SIZE=512m;
fi

export CATALINA_OPTS="-Djava.awt.headless=true 
  -Dfile.encoding=UTF-8 
  -server -Xms1024m -Xmx${TOMCAT_MAX_HEAP}
  -XX:PermSize=${TOMCAT_MAX_PERM_SIZE}
  -XX:MaxPermSize=${TOMCAT_MAX_PERM_SIZE}
  -XX:+DisableExplicitGC"

# Set default env #############################################################
echo
echo "# Setting up 3DCityDB WFS environment ... ######################################"
if [ -z ${CITYDB_CONNECTION_TYPE+x} ]; then
  export CITYDB_CONNECTION_TYPE=PostGIS;
  echo "NOTE: Environment variable not set, using default value:"
  echo "   CITYDB_CONNECTION_TYPE=$CITYDB_CONNECTION_TYPE"
  echo "   To change this setting run e.g.:"
  echo "     docker run -e \"CITYDB_CONNECTION_TYPE=Oracle\" 3dcitydb-wfs"
fi

if [ -z ${CITYDB_CONNECTION_SERVER+x} ]; then
  export CITYDB_CONNECTION_SERVER=citydb-host;
  echo
  echo "NOTE: Environment variable not set, using default value:"
  echo "   CITYDB_CONNECTION_SERVER=$CITYDB_CONNECTION_SERVER"
  echo "   To change this setting run e.g.:"
  echo "     docker run -e \"CITYDB_CONNECTION_SERVER=my.other.host\" 3dcitydb-wfs"
fi

if [ -z ${CITYDB_CONNECTION_PORT+x} ]; then
  export CITYDB_CONNECTION_PORT=5432;
  echo
  echo "NOTE: Environment variable not set, using default value:"
  echo "   CITYDB_CONNECTION_PORT=$CITYDB_CONNECTION_PORT"
  echo "   To change this setting run e.g.:"
  echo "     docker run -e \"CITYDB_CONNECTION_PORT=1234\" 3dcitydb-wfs"
fi

if [ -z ${CITYDB_CONNECTION_SID+x} ]; then
  export CITYDB_CONNECTION_SID="3dcitydb-docker";
  echo
  echo "NOTE: Environment variable not set, using default value:"
  echo "   CITYDB_CONNECTION_SID=$CITYDB_CONNECTION_SID"
  echo "   To change this setting run e.g.:"
  echo "     docker run -e \"CITYDB_CONNECTION_SID=citydb\" 3dcitydb-wfs"
fi

if [ -z ${CITYDB_CONNECTION_USER+x} ]; then
  export CITYDB_CONNECTION_USER="postgres";
  echo
  echo "NOTE: Environment variable not set, using default value:"
  echo "   CITYDB_CONNECTION_USER=$CITYDB_CONNECTION_USER"
  echo "   To change this setting run e.g.:"
  echo "     docker run -e \"CITYDB_CONNECTION_USER=otheruser\" 3dcitydb-wfs"
fi

if [ -z ${CITYDB_CONNECTION_PASSWORD+x} ]; then
  export CITYDB_CONNECTION_PASSWORD="";
  echo
  echo "NOTE: Environment variable not set, using default value:"
  echo "   CITYDB_CONNECTION_PASSWORD=$CITYDB_CONNECTION_PASSWORD"
  echo "   To change this setting run e.g.:"
  echo "     docker run -e \"CITYDB_CONNECTION_PASSWORD=changeMe!!\" 3dcitydb-wfs"
fi
echo
echo "# Setting up 3DCityDB WFS environment ...done! #################################"

# Insert database credentials into 3dcitydb-wfs WEB-INF/config.xml ############
echo 
echo "# Writing 3DCityDB WFS WEB-INF/config.xml ... ##################################"
xmlstarlet ed -L -N n="http://www.3dcitydb.org/importer-exporter/config" \
 -u "/n:wfs/n:database/n:connection/n:type" -v "$CITYDB_CONNECTION_TYPE" "/usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH}/WEB-INF/config.xml"
xmlstarlet ed -L -N n="http://www.3dcitydb.org/importer-exporter/config" \
 -u "/n:wfs/n:database/n:connection/n:server" -v "$CITYDB_CONNECTION_SERVER" "/usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH}/WEB-INF/config.xml"
xmlstarlet ed -L -N n="http://www.3dcitydb.org/importer-exporter/config" \
 -u "/n:wfs/n:database/n:connection/n:port" -v "$CITYDB_CONNECTION_PORT" "/usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH}/WEB-INF/config.xml"
xmlstarlet ed -L -N n="http://www.3dcitydb.org/importer-exporter/config" \
 -u "/n:wfs/n:database/n:connection/n:sid" -v "$CITYDB_CONNECTION_SID" "/usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH}/WEB-INF/config.xml"
xmlstarlet ed -L -N n="http://www.3dcitydb.org/importer-exporter/config" \
 -u "/n:wfs/n:database/n:connection/n:user" -v "$CITYDB_CONNECTION_USER" "/usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH}/WEB-INF/config.xml"
xmlstarlet ed -L -N n="http://www.3dcitydb.org/importer-exporter/config" \
 -u "/n:wfs/n:database/n:connection/n:password" -v "$CITYDB_CONNECTION_PASSWORD" "/usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH}/WEB-INF/config.xml"

echo "# Writing 3DCityDB WFS WEB-INF/config.xml ...done! #############################"
 
# Switch to catalina.sh run
exec "$@"
