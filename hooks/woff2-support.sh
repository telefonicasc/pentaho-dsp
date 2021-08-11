#!/bin/bash
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

set -eoux pipefail

for CONFDIR in "pentaho-cdf" "pentaho-cdf-dd"; do
  export CONFFILE="${PENTAHO_HOME}/pentaho-solutions/system/${CONFDIR}/settings.xml"
  if [ -f "${CONFFILE}" ]; then
    if ! (grep downloadable-formats "${CONFFILE}" | grep woff2); then
      echo "ACTIVANDO soporte de descarga de fuentes WOFF2 en ${CONFFILE}"
      # Agrego la linea delante de la definicion del MimeType pdf, por ejemplo.
      sed -i "s/<downloadable-formats>/<downloadable-formats>woff2,/" "${CONFFILE}"
    fi
  fi
done
