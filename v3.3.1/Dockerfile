# 3DCityDB WFS Dockerfile #####################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb/web-feature-service
###############################################################################
# Base image
ARG baseimage_tag="8.5-jre8"
FROM tomcat:${baseimage_tag}

# Labels ######################################################################
LABEL maintainer="Bruno Willenborg"
LABEL maintainer.email="b.willenborg(at)tum.de"
LABEL maintainer.organization="Chair of Geoinformatics, Technical University of Munich (TUM)"
LABEL source.repo="https://github.com/tum-gis/3dcitydb-wfs-docker"

# Setup 3DCityDB WFS ##########################################################
ARG citydb_wfs_version='v3.3.1'
ENV CITYDB_WFS_VERSION=${citydb_wfs_version}

ARG citydb_wfs_context_path="citydb-wfs"
ENV CITYDB_WFS_CONTEXT_PATH=${citydb_wfs_context_path}

ARG RUNTIME_PACKAGES="postgresql-client-10 xmlstarlet ca-certificates"

# Setup build deps
RUN set -x && \
  echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -y --no-install-recommends ${RUNTIME_PACKAGES}
  
# Download and upack 3DCityDB WFS
RUN set -x && \
  wget -nv "https://github.com/3dcitydb/web-feature-service/releases/download/${CITYDB_WFS_VERSION}/citydb-wfs-$(echo ${CITYDB_WFS_VERSION} | sed 's/v//g').zip" -O 3dcitydb-wfs.zip && \
  mkdir -p 3dcitydb-wfs && unzip -j -d 3dcitydb-wfs 3dcitydb-wfs.zip "*/citydb-wfs.war" "*/lib/*.jar" && \
  cp 3dcitydb-wfs/*.jar /usr/local/tomcat/lib/ && \
  unzip 3dcitydb-wfs/citydb-wfs.war -d /usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH}
  
# Cleanup
RUN set -x && \
  rm -rf /var/lib/apt/lists/*  && \
  rm 3dcitydb-wfs.zip && \
  rm -r 3dcitydb-wfs

# Setup 3DCityDB WFS container entrypoint #####################################
COPY citydb-wfs.sh /usr/local/bin/
RUN ln -s usr/local/bin/citydb-wfs.sh / # backwards compat
RUN chmod u+x /usr/local/bin/citydb-wfs.sh

# wait-for-psql script
COPY wait-for-psql.sh /usr/local/bin/
RUN ln -s usr/local/bin/wait-for-psql.sh / # backwards compat
RUN chmod u+x /usr/local/bin/wait-for-psql.sh

ENTRYPOINT ["citydb-wfs.sh"]
CMD ["catalina.sh","run"]
