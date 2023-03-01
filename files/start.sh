#!/bin/bash

# Check prerequisites
/opt/check_vol.sh || exit $?
/opt/check_db.sh  || exit $?

# Prepare volume
/opt/prep.sh  || exit $?

# Run pentaho server
touch "${PENTAHO_HOME}/.firstboot"
exec  "${PENTAHO_HOME}/tomcat/bin/startup.sh"
