# Copyright 2020 Telefónica Soluciones de Informática y Comunicaciones de España, S.A.U.
#
# This file is part of Pentaho DSP.
#
# Pentaho DSP is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Pentaho DSP is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Orion Context Broker. If not, see http://www.gnu.org/licenses/.
#
# For those usages not covered by this license please contact with
# sc_support at telefonica dot com

FROM fivecorp/pentaho-env:v8.3.6

LABEL maintainer=telefonicasc

# Add config hooks to /opt
USER root
ADD hooks /opt/hooks/

# Add source code to /home/pentaho
USER pentaho
ADD . /home/pentaho

# Initialize local mvn repo and go offline, so we don't need Internet
# access in the destination machine.
RUN cd /home/pentaho && mvn -B initialize && mvn -B dependency:go-offline

# dependency:go-offline is not enough, it won't download all jars.
# we have to build the package to make sure to get them.
RUN cd /home/pentaho && mvn -B package && mvn -B clean
