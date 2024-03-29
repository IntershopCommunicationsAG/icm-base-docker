#
# Copyright 2021 Intershop Communications AG.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM eclipse-temurin:11.0.13_8-jre

LABEL maintainer="a-team@intershop.de" \
      javaversion="adoptopenjdk jre 11.0.11_9"

RUN apt-get update && apt-get install -yq unison tzdata ca-certificates && \
    # Add groups
    addgroup --gid 150 intershop && useradd -m --uid 150 -g intershop --shell /bin/sh intershop  && \
    # Add directories
    mkdir -p /intershop/logs && mkdir -p /intershop/conf && chown -R intershop:intershop /intershop && \
    #Add environement file
    echo "export JAVA_HOME=/opt/java/openjdk" > /etc/profile.d/02-add-JAVAHOME.sh && \
    echo "export PATH=${JAVA_HOME}/bin:${PATH}" >> /etc/profile.d/02-add-JAVAHOME.sh && \
    cat /opt/java/openjdk/lib/security/java.security | sed -e "s/.*crypto\.policy=.*limited$/crypto\.policy=unlimited/" > /tmp/java.security && \
    cd /tmp && cp -f java.security /opt/java/openjdk/lib/security/ && rm -f /tmp/java.security && update-ca-certificates && \
    curl -o /tmp/waitfordb.tar.gz -L https://github.com/m-raab/waitfordb/releases/download/2.0.9/waitfordb.linux.amd64.tar.gz && \
    tar -zxf /tmp/waitfordb.tar.gz && mv waitfordb /usr/bin/ && rm -f waitfordb.tar.gz && \
    curl -o /tmp/waitforfile.tar.gz -L https://github.com/m-raab/waitforfile/releases/download/1.0.0/waitforfile.linux.amd64.tar.gz && \
    tar -zxf /tmp/waitforfile.tar.gz && mv waitforfile /usr/bin/ && rm -f waitforfile.tar.gz && \
    curl -o /tmp/waitforurl.tar.gz -L https://github.com/m-raab/waitforurl/releases/download/0.0.3/waitforurl.linux.amd64.tar.gz && \
    tar -zxf /tmp/waitforurl.tar.gz && mv waitforurl /usr/bin/ && rm -f waitforurl.tar.gz && \
    curl -o /tmp/cpbuilder.tar.gz -L https://github.com/IntershopCommunicationsAG/cpbuilder/releases/download/0.9/cpbuilder.linux.amd64.tar.gz && \
    tar -zxf /tmp/cpbuilder.tar.gz && mv cpbuilder /usr/bin/ && rm -f cpbuilder.tar.gz && \
    curl -o /tmp/dirdiff.tar.gz -L https://github.com/IntershopCommunicationsAG/dirdiff/releases/download/1.1.0/dirdiff.linux.amd64.tar.gz && \
    tar -zxf /tmp/dirdiff.tar.gz && mv dirdiff /usr/bin/ && rm -f dirdiff.tar.gz && \
    chmod -R 1777 /tmp && \
    # Cleanup the Dockerfile
    apt-get purge -y curl apt-transport-https unzip && \
    apt-get -y autoremove && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME [ "/intershop/conf", \
         "/intershop/logs" ]

CMD /bin/sh