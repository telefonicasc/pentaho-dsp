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

export CONFDIR="${PENTAHO_HOME}/pentaho-solutions/system"
if grep "requestParameterAuthenticationEnabled=true" "${CONFDIR}/security.properties"; then
  exit 0
fi

echo "HABILITANDO autenticacion por parametros en URL"
cd "${CONFDIR}"

# Remove the line if it exists
sed -i '/requestParameterAuthenticationEnabled/d' security.properties
# Make sure to add a newline before the new parameter,
# the default file dees not end with one.
cat >> security.properties <<EOF

# Added by pentaho-dsp in order to enable embedding of Pentaho widgets in iframes.
requestParameterAuthenticationEnabled=true
EOF
