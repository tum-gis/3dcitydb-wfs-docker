# 3DCityDB WFS Dockerfile #####################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb/web-feature-service
###############################################################################
# Base image
ARG baseimage_tag="8.5-jre8"
FROM tomcat:${baseimage_tag}
# Maintainer ##################################################################
#   Bruno Willenborg
#   Chair of Geoinformatics
#   Department of Civil, Geo and Environmental Engineering
#   Technical University of Munich (TUM)
#   <b.willenborg@tum.de>
MAINTAINER Bruno Willenborg, Chair of Geoinformatics, Technical University of Munich (TUM) <b.willenborg@tum.de>

# Setup 3DCityDB WFS ##########################################################
ARG citydb_wfs_context_path="citydb-wfs"
ENV CITYDB_WFS_CONTEXT_PATH=${citydb_wfs_context_path}

ARG citydb_wfs_version="v3.3.2"
ENV CITYDB_WFS_VERSION=${citydb_wfs_version}

COPY lib/*.jar 3dcitydb-wfs/

RUN set -x \
  && RUNTIME_PACKAGES="xmlstarlet  openjdk-8-jdk" \
  && BUILD_PACKAGES="ca-certificates git" \
  && apt-get update \
  && apt-get install -y --no-install-recommends $BUILD_PACKAGES $RUNTIME_PACKAGES \
  && git clone -b "${CITYDB_WFS_VERSION}" --depth 1 https://github.com/3dcitydb/web-feature-service.git wfs_temp \
  && cd wfs_temp && chmod u+x ./gradlew && ./gradlew war \
  && unzip build/libs/citydb-wfs.war -d /usr/local/tomcat/webapps/${CITYDB_WFS_CONTEXT_PATH} \
  && cd .. && apt-get purge -y --auto-remove $BUILD_PACKAGES \
  && cp 3dcitydb-wfs/*.jar /usr/local/tomcat/lib/ \
  && apt-get install -y --no-install-recommends openjdk-8-jre \
  && rm -r 3dcitydb-wfs wfs_temp \
  && rm -rf /var/lib/apt/lists/*
  
# Setup 3DCityDB WFS container entrypoint #####################################
COPY citydb-wfs.sh /usr/local/bin/
RUN ln -s usr/local/bin/citydb-wfs.sh / # backwards compat
RUN chmod u+x /usr/local/bin/citydb-wfs.sh

ENTRYPOINT ["citydb-wfs.sh"]
CMD ["catalina.sh","run"]
