## Introduction

This container provides an extended image for ICM container.
It is based on the offical adoptopenjdk container.

The Dockerfile is maintained at GitHub (https://github.com/IntershopCommunicationsAG/icm-base-docker).

## Adjustments
### Additional Binaries
- `unison` for file synchronization
- `tzdata` contains timo zone information
- `ca-certificates` updates certificates
- `waitfordb` checks the availability of a MSSQL database (https://github.com/m-raab/waitfordb). You can use this also with Oracle, but in this case you have to install Oracle instant client
    ```
    RUN apt-get update && apt-get install curl unzip &&\
        curl -o /tmp/instantclient-basic-linux.x64-19.5.0.0.0dbru.zip https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-basic-linux.x64-19.5.0.0.0dbru.zip &&\
        mkdir /opt/oracle && unzip /tmp/instantclient-basiclite-linux.x64-19.5.0.0.0dbru.zip -d /opt/oracle

    ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_19_5:/lib:/lib64
    ```
- `waitforfile` checks the availability of a file (https://github.com/m-raab/waitforfile)
- `waitforurl` checks the reachability of an url (https://github.com/m-raab/waitforurl)
- `cpbuilder` creates a classpath from differen project folders (https://github.com/IntershopCommunicationsAG/cpbuilder)
- `dirdiff` compares two directories and stores files and directories they differ (https://github.com/IntershopCommunicationsAG/dirdiff)

### Additional User / Group
- Group
  - Name: intershop
  - ID: 150

- User
  - Name: intershop
  - ID: 150

### Additional Environment
Add JAVA_HOME to environment with profile configuration.
Path was extended with JAVA_HOME.

### Additional Directories / Volumes
- /intershop
- /intershop/conf (Volume)
- /intershop/logs (Volume)

### Comment
`curl` and dependencies have been removed from the installation

## License

Copyright 2014-2021 Intershop Communications.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
