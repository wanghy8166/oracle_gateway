FROM centos:centos7.7.1908

WORKDIR /opt/

copy Centos-7.repo                                /opt/
copy p13390677_112040_Linux-x86-64_5of7.zip       /opt/
copy oraInst.loc                                  /opt/
copy tg.rsp                                       /opt/
copy netca.rsp                                    /opt/
copy lsnrctl.sh                                   /opt/
copy listener.ora                                 /opt/
copy tnsnames.ora                                 /opt/
copy install_gateways.sh                          /opt/
copy mysql-connector-odbc-5.3.14-1.el7.x86_64.rpm /opt/
copy psqlodbc-11.01.0000.tar.gz                   /opt/
copy polardb_oracle_odbc.tar.gz                   /opt/
copy odbc.ini                                     /opt/
copy initphoenix.ora                              /opt/
copy initmymssql.ora                              /opt/
copy initmypg.ora                                 /opt/
copy initmypolardbo.ora                           /opt/

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    rm /etc/yum.repos.d/CentOS-* -rf && \
    cp /opt/Centos-7.repo /etc/yum.repos.d/ && \
    yum install -y unzip make unixODBC-devel unixODBC postgresql-devel libtool libaio && \
    yum clean all && \
    /usr/sbin/groupadd -g 501 oinstall && \
    /usr/sbin/groupadd -g 502 dba && \
    /usr/sbin/groupadd -g 503 oper && \
    /usr/sbin/groupadd -g 504 asmadmin && \
    /usr/sbin/groupadd -g 506 asmdba && \
    /usr/sbin/groupadd -g 507 asmoper && \
    /usr/sbin/useradd  -u 502 -g oinstall -G dba,asmdba oracle && \
    echo export ORACLE_HOME="/home/oracle/product/11.2.0/tg_1" >>/home/oracle/.bash_profile && \
    echo export PATH=\$PATH:\$ORACLE_HOME/bin >>/home/oracle/.bash_profile && \
    cp /opt/oraInst.loc /etc/oraInst.loc && \
    /opt/install_gateways.sh && \
    cp /opt/lsnrctl.sh /lsnrctl.sh && \
    rm -rf /home/oracle/product/11.2.0/tg_1/network/admin/listener.ora && \
    cp /opt/listener.ora /home/oracle/product/11.2.0/tg_1/network/admin/listener.ora && \
    cp /opt/tnsnames.ora /home/oracle/product/11.2.0/tg_1/network/admin/tnsnames.ora && \
    cp /opt/odbc.ini     /etc/odbc.ini && \
    cp /opt/initphoenix.ora    /home/oracle/product/11.2.0/tg_1/hs/admin/initphoenix.ora && \
    cp /opt/initmymssql.ora    /home/oracle/product/11.2.0/tg_1/dg4msql/admin/initmymssql.ora && \
    cp /opt/initmypg.ora       /home/oracle/product/11.2.0/tg_1/hs/admin/initmypg.ora && \
    cp /opt/initmypolardbo.ora /home/oracle/product/11.2.0/tg_1/hs/admin/initmypolardbo.ora && \
    rpm -ivh /opt/mysql-connector-odbc-5.3.14-1.el7.x86_64.rpm && \
    tar zxvf /opt/polardb_oracle_odbc.tar.gz && \
    mv target /usr/local/polardb_oracle_odbc && \
    tar zxvf /opt/psqlodbc-11.01.0000.tar.gz && \
    cd psqlodbc-11.01.0000 && \
    ./configure && \
    make && \
    make install && \
    rm -rf /opt/* && \
    rm -rf /var/cache/yum && \
    rm -rf /home/oracle/gateways && \
    /lsnrctl.sh

CMD /lsnrctl.sh && tail -F /home/oracle/product/11.2.0/tg_1/diag/tnslsnr/*/listener/trace/listener.log

