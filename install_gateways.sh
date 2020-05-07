#!/bin/bash

su - oracle <<EOF
unzip /opt/p13390677_112040_Linux-x86-64_5of7.zip -d /home/oracle/
/home/oracle/gateways/runInstaller -silent -noconfig -waitforcompletion -responseFile /opt/tg.rsp
EOF

#root执行
/home/oracle/product/11.2.0/tg_1/root.sh

su - oracle <<EOF
/home/oracle/product/11.2.0/tg_1/bin/netca -silent -responsefile /opt/netca.rsp
EOF


