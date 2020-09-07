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

export CONFFILE="${PENTAHO_HOME}/pentaho-solutions/system/ImportHandlerMimeTypeDefinitions.xml"
export FONTDATA="application/vnd.ms-fontobject:eot application/x-font-ttf:ttf application/font-woff:woff application/font-woff2:woff2 application/font-sfnt:otf"

for FONTDESC in ${FONTDATA}; do
  IFS=: read MIMETYPE EXTENSION <<< ${FONTDESC}
  if ! grep "${MIMETYPE}" "${CONFFILE}"; then
    echo "ACTIVANDO soporte de fuente ${EXTENSION} (MimeType ${MIMETYPE})"
    # Agrego la linea delante de la definicion del MimeType pdf, por ejemplo.
    sed -i "/<MimeTypeDefinition mimeType=\"text\/pdf\"/i <MimeTypeDefinition mimeType=\"${MIMETYPE}\" hidden=\"true\"><extension>${EXTENSION}</extension></MimeTypeDefinition>\n" "${CONFFILE}"
  else
    echo "COMPROBADO soporte de fuente ${EXTENSION} (MimeType ${MIMETYPE})"
  fi
done

