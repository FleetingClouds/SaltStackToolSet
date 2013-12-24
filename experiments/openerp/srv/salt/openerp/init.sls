include:
    - postgresql
    
# ####
#   Ensure openerp data base is accessible over the net
# ##
#
pg_hba.conf:
    file.blockreplace:
        - name: /etc/postgresql/9.1/main/pg_hba.conf
        - marker_start: "# START SaltStack managed zone -DO-NOT-EDIT-"
        - marker_end: "# END SaltStack managed zone --"
        - prepend_if_not_found: True
        - backup: '.bak'
        - show_changes: True

pg_hba.conf-accumulated1:
    file.accumulated:
        - filename: /etc/postgresql/9.1/main/pg_hba.conf
        - name: pg_hba-accum
        - text: "host    {{ pillar['openerp_dbname'] }}         {{ pillar['openerp_dbuser'] }}         {{ grains['ip_interfaces']['eth0'][0] }}/24\tmd5"
        - require_in:
            - file: pg_hba.conf

# ####
#   Add an OpenERP group to the machine
# ##
#
openerp_group:
    group.present:
        - name: openerp

# ####
#   Add an OpenERP user to the machine
# ##
#
openerp_user_account:
    user.present:
        - name: openerp
        - fullname: OpenERP
        - home: {{ pillar['openerp_installation_path'] }}/openerp-7
        - groups:
            - openerp
        
# ####
#   Place OpenERP runtime where it belongs
# ##
#
{{ pillar['openerp_installation_path'] }}/openerp-7.0-{{ pillar['openerp_archive_version'] }}:
    archive.extracted:
        - name: {{ pillar['openerp_installation_path'] }}
        - source: http://nightly.openerp.com/7.0/nightly/deb/openerp_7.0-{{ pillar['openerp_archive_version'] }}-1.tar.gz
        - source_hash: http://nightly.openerp.com/7.0/nightly/deb/openerp_7.0-{{ pillar['openerp_archive_version'] }}-1.dsc
        - archive_format: tar
        - tar_options: z
        - if_missing: {{ pillar['openerp_installation_path'] }}/openerp-7.0-{{ pillar['openerp_archive_version'] }}

# ####
#   Set OpenERP home directory ownership and permissions
# ##
#
openerp_directory_ownership:
    file.directory:
        - name: {{ pillar['openerp_installation_path'] }}/openerp-7.0-{{ pillar['openerp_archive_version'] }}
        - user: openerp
        - group: openerp
        - dir_mode: 755
        - file_mode: 644
        - recurse:
            - user
            - group
            - mode

# ####
#   Make a symbolic link to it for easier management
# ##
#
openerp_symlink:
    file.symlink:
        - name: {{ pillar['openerp_installation_path'] }}/openerp-7/server
        - target: {{ pillar['openerp_installation_path'] }}/openerp-7.0-{{ pillar['openerp_archive_version'] }}
        - makedirs: True

# ####
#   Configure OpenERP from pillar data
# ##
#
{{ pillar['openerp_configuration_path'] }}/openerp-server.conf:
    file.managed:
        - source: salt://openerp/openerp-server.conf
        - makedirs: True
        - template: jinja
        - user: openerp
        

#
#OpenERP package install:
#    pkg.installed:
#        - skip_verify: True
#        - names:
#            - openerp

openerp:
    postgres_user:
        - present
        - name: {{ pillar['openerp_dbuser'] }}
        - password: {{ pillar['openerp_dbpassword'] }}
        - createdb: True
#        - user: postgres
        - require:
            - service: postgresql

openerpdb:
    postgres_database.present:
        - name: {{ pillar['openerp_dbname'] }}
        - encoding: UTF8
        - lc_ctype: en_US.UTF8
        - lc_collate: en_US.UTF8
        - template: template0
        - owner: {{ pillar['openerp_dbuser'] }}
        - runas: postgres
        - require:
            - postgres_user: openerp

