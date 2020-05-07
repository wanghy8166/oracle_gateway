#!/bin/bash

su - oracle <<EOF
lsnrctl stop
lsnrctl start
EOF
