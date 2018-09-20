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
ARG citydb_wfs_context_path="citydb-wfs"
ENV CITYDB_WFS_CONTEXT_PATH=${citydb_wfs_context_path}

ARG citydb_wfs_version='v4.0.0'
ENV CITYDB_WFS_VERSION=${citydb_wfs_version}

ARG RUNTIME_PACKAGES="xmlstarlet openjdk-8-jre"
ARG BUILD_PACKAGES="ca-certificates git openjdk-8-jdk"

# Setup build deps
RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends ${BUILD_PACKAGES}

# Clone 3DCityDB WFS
RUN set -x && \
  git clone -b "${CITYDB_WFS_VERSION}" --depth 1 https://github.com/3dcitydb/web-feature-service.git wfs_temp

# Build 3DCityDB WFS WAR
RUN set -x && \
  cd wfs_temp && chmod u+x ./gradlew && ./gradlew installDist

# Extract WAR to Tomcat apps folder and copy libs
RUN set -x && \
  cd wfs_temp && \
  unzip 'build/install/3DCityDB-Web-Feature-Service/citydb-wfs.war' -d "/usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH}" && \
  ls -lA build/install/3DCityDB-Web-Feature-Service/lib && \
  mv build/install/3DCityDB-Web-Feature-Service/lib/*.jar /usr/local/tomcat/lib/

# Remove build deps
RUN set -x && \
  cd .. && apt-get purge -y --auto-remove ${BUILD_PACKAGES}

# Setup runtime deps
RUN set -x && \
  apt-get install -y --no-install-recommends ${RUNTIME_PACKAGES}

# Cleanup
RUN set -x && \
  rm -r wfs_temp && \
  rm -rf /var/lib/apt/lists/*
  
# Setup 3DCityDB WFS container entrypoint #####################################
COPY citydb-wfs.sh /usr/local/bin/
RUN ln -s usr/local/bin/citydb-wfs.sh / # backwards compat
RUN chmod u+x /usr/local/bin/citydb-wfs.sh

ENTRYPOINT ["citydb-wfs.sh"]
CMD ["catalina.sh","run"]
