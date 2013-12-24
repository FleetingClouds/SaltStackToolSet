postgresql:
    pkg:
#        - name: postgresql-9.1
        - installed
    service:
        - running
        - require:
            - pkg: postgresql

postgresql-contrib:
    pkg:
        - installed
            
postgresql.conf:
    file.blockreplace:
        - name: /etc/postgresql/9.1/main/postgresql.conf
        - marker_start: "# START SaltStack managed zone -DO-NOT-EDIT- -------------------------------"
        - marker_end: "# END SaltStack managed zone -----------------------------------------------"
        - prepend_if_not_found: True
        - backup: '.bak'
        - show_changes: True

postgresql.conf-accumulated1:
    file.accumulated:
        - filename: /etc/postgresql/9.1/main/postgresql.conf
        - name: postgresql-accum
        - text: "listen_addresses='{{ grains['ip_interfaces']['eth0'][0]}}'"
        - require_in:
            - file: postgresql.conf

#pg_hba.conf:
#    file.blockreplace:
#        - name: /etc/postgresql/9.1/main/pg_hba.conf
#        - marker_start: "# START SaltStack managed zone -DO-NOT-EDIT-"
#        - marker_end: "# END SaltStack managed zone --"
#        - prepend_if_not_found: True
#        - backup: '.bak'
#        - show_changes: True

postgresql-9.1-dbg:
    pkg:
        - name: postgresql-9.1-dbg
        - installed
        - require:
            - service: postgresql
            
postgresql-server-dev-all:
    pkg:
#        - name: postgresql-server-dev-9.1
        - installed
        - require:
            - service: postgresql

#postgres_service:
#    service.running:
#        - name: postgresql
#        - reload: True
#        - watch: 
#            - file: /etc/postgresql/9.1/main/pg_hba.conf


