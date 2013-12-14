base:
    pkgrepo.managed:
        - name: deb http://nightly.openerp.com/7.0/nightly/deb/ ./

OpenERP package install:
    pkg.installed:
        - skip_verify: True
        - names:
            - openerp

        
