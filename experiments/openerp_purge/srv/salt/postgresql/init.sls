postgresql-9.1-dbg:
    pkg:
        - name: postgresql-9.1-dbg
        - purged
            
postgresql-server-dev-9.1:
    pkg:
        - name: postgresql-server-dev-9.1
        - purged

postgresql:
    pkg:
        - name: postgresql-9.1
        - purged

pg_clean:
    file.absent:
        - name: /etc/postgresql

pg_common_path:
    file.absent:
        - name: /etc/postgresql-common

#postgres_user_account:
#    user.absent:
#        - name: postgres
#        - purge: True
#        - force: True
#
#        
#postgres_group:
#    group.absent:
#        - name: postgres
#

