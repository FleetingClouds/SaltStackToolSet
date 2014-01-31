# ####
#   Dependencies
# ##
#
apt_prereqs:
     pkg.installed:
         - pkgs:
            - python-pip
            - python-dev
            - build-essential
            
python_prereqs:
    pip.installed:
        - names:
            - openerp-client-lib
            - oauth2client
            - Importing
            - progressbar2
        - depends: apt_prereqs

# ####
#   Getting gspread
# ##
#
pip_build_root:
    file.directory:
        - name: /tmp
        
obtain-gspread:
    cmd.run:
        - name: wget -N https://github.com/FleetingClouds/gspread/archive/master.zip
        - cwd: /tmp

extract-gspread:
    cmd.run:
        - name: unzip -uo /tmp/master.zip
        - cwd: /tmp
        - depends: obtain-gspread

install-gspread:
    cmd.run:
        - name: python setup.py install
        - cwd: /tmp/gspread-master
        - depends:
            - extract-gspread
            - python_prereqs

/tmp/gspread-master/tests/tests.config:
    file.managed:
        - source: salt://gdata_oerp_pump/tests.config
        - makedirs: True
        - template: jinja
        - depends:
            - install-gspread


