postgresql:
    pkg:
        - installed
    service:
        - running
        - require:
            - pkg: postgresql

postgresql-contrib:
    pkg:
        - installed
            
postgresql.conf:
    file:
        - blockreplace
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

postgresql-9.1-dbg:
    pkg:
        - name: postgresql-9.1-dbg
        - installed
        - require:
            - service: postgresql
            
postgresql-server-dev-all:
    pkg:
        - installed
        - require:
            - service: postgresql

prerequisites:
    pkg.installed:
        - pkgs:
            - python-pip
            - libpq-dev
            - python-dev

