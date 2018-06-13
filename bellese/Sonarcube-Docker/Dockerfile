FROM sonarqube:7.0-alpine

ENV SONAR_VERSION=7.0 \
    SONARQUBE_HOME=/opt/sonarqube \
    # Database configuration
    # Defaults to using H2
    SONARQUBE_JDBC_USERNAME=postgressonar \
    SONARQUBE_JDBC_PASSWORD=postgressonar \
    SONARQUBE_JDBC_URL=postgres-sonarcube.cbh1hokggf1a.us-east-1.rds.amazonaws.com:5432




RUN set -x \
    && cd /opt/sonarqube \
    && mkdir extensions/ \
    && mkdir extensions/plugins \
    && cd $SONARQUBE_HOME/extensions/plugins \
    && wget https://github.com/SonarQubeCommunity/sonar-pmd/releases/download/2.6/sonar-pmd-plugin-2.6.jar
  



VOLUME "$SONARQUBE_HOME/data"

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
ENTRYPOINT ["./bin/run.sh"]



