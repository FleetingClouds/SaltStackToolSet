include:
#    - workaround
    - postgresql


# ####
#   Dependencies
# ##
#
apt_prereqs:
     pkg.installed:
         - pkgs:
            - antiword
            - bzr
            - gcc
            - ghostscript
            - graphviz
            - libfreetype6-dev
            - libldap2-dev
            - libsasl2-dev
            - libsasl2-dev
            - libpq-dev
            - libxml2
            - libxslt
            - lptools
            - make
            - mc
            - poppler-utils
            - postgresql-client
            - python-dateutil
            - python-dev
            - python-libxslt1
            - python-matplotlib
            - python-pip
            - python-pdftools
            - python-pychart
            - python-reportlab-accel
            - python-zsi

            
python_prereqs:
    pip.installed:
        - names:
            - Babel
            - docutils
            - egenix-mx-base
            - feedparser
            - jinja2
            - lxml
            - matplotlib
            - mock
            - mako
            - paramiko
            - pdftools
            - PIL
            - psutil
            - psycopg2
            - pydot
            - PyOpenSSL
            - pyparsing
            - python-ldap
            - python-openid
            - python-webdav
            - pytz
            - pyyaml
            - reportlab
            - setuptools
            - simplejson
            - unittest2
            - vobject
            - vatnumber
            - werkzeug
            - xlwt
        - requires:
            - pkg: python-pip
            - pkg: libpq-dev
            - pkg: python-dev
            - pkg: libxml2
            - pkg: libxslt


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
        - text: "host    all             {{ pillar['openerp_dbuser'] }}         {{ grains['ip_interfaces']['eth0'][0] }}/24\tmd5"
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
#   Make entry point bash executable
# ##
#
openerp-server_privileges:
    file.managed:
        - name: {{ pillar['openerp_installation_path'] }}/openerp-7.0-{{ pillar['openerp_archive_version'] }}/openerp-server
        - user: openerp
        - group: openerp
        - mode: 550

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
        - group: openerp
        - mode: 640
        - dir_mode: 750

# ####
#   Prepare OpenERP logging 
# ##
#
{{ pillar['openerp_logging_path'] }}:
    file.directory:
        - user: root
        - group: openerp
        - recurse:
            - user
            - group
            - mode
        - file_mode: 660
        - dir_mode: 770

/etc/logrotate.d/openerp-server:
    file.managed:
        - source: salt://openerp/openerp-server.logrotate
        - user: root
        - group: root
        - mode: 644

#
openerp:
    postgres_user:
        - present
        - name: {{ pillar['openerp_dbuser'] }}
        - password: {{ pillar['openerp_dbpassword'] }}
        - createdb: True
#        - user: postgres
        - require:
            - service: postgresql

# ####
#   Configure OpenERP init.d service
# ##
#
/etc/init.d/oerp-srvr:
    file.managed:
        - source: salt://openerp/oerp-srvr
        - makedirs: True
        - template: jinja
        - user: root
        - group: root
        - mode: 750

oerp-srvr:
    service:
        - running
        - enable: true

