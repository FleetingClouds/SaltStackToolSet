openerp_user_account:
    user.absent:
        - name: openerp
        - purge: True
        - force: True

        
openerp_group:
    group.absent:
        - name: openerp

oerp_install_path:
    file.absent:
        - name: {{ pillar['openerp_installation_path'] }}/openerp-7.0-{{ pillar['openerp_archive_version'] }}

openerp_symlink:
    file.absent:
        - name: {{ pillar['openerp_installation_path'] }}/openerp-7/server

openerp-server.conf:
    file.absent:
        - name: {{ pillar['openerp_configuration_path'] }}/openerp-server.conf


