FROM sasah/oracle-server-jre

ENV M2_HOME="/usr/maven" \
    MAVEN_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=Europe/Moscow"

RUN MAVEN_VERSION="3.3.9" && \

    apk --no-cache add --virtual .build-deps \
        wget \
        ca-certificates \
        gnupg && \

    cd /tmp && \
    wget -nv https://www.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
        https://www.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5 \
        https://www.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.asc \
        https://www.apache.org/dist/maven/KEYS && \

    echo "  apache-maven-${MAVEN_VERSION}-bin.tar.gz" >> apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5 && \
    md5sum -c apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5 && \

    gpg --import KEYS && \
    gpg --verify --trust-model always apache-maven-${MAVEN_VERSION}-bin.tar.gz.asc apache-maven-${MAVEN_VERSION}-bin.tar.gz && \

    tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir -p /usr/maven && \
    cd /tmp/apache-maven-${MAVEN_VERSION} && \
    mv -v * /usr/maven && \

    rm -rvf /usr/maven/LICENSE \
        /usr/maven/NOTICE \
        /usr/maven/README.txt \

        /usr/maven/bin/mvnDebug \
        /usr/maven/bin/mvnyjp \
        /usr/maven/bin/mvn.cmd \
        /usr/maven/bin/mvnDebug.cmd && \

    ln -sv /usr/maven/bin/mvn /usr/bin/ && \

    apk del .build-deps && \
    rm -rvf /tmp/* /root/.gnupg
