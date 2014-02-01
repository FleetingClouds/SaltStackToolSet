include:
    - gspread

# ####
# Getting GData OpenERP Data Pump
# ##
#
dir_base:
    file.directory:
        - name: /opt
        
obtain-gdata_oerp_pump:
    cmd.run:
        - name: wget -N https://github.com/martinhbramwell/GData_OpenERP_Data_Pump/archive/master.zip
        - cwd: /opt

extract-gdata_oerp_pump:
    cmd.run:
        - name: unzip -uo /opt/master.zip
        - cwd: /opt
        - depends: obtain-gdata_oerp_pump

/opt/GData_OpenERP_Data_Pump:
    file.rename:
        - source: /opt/GData_OpenERP_Data_Pump-master
        - makedirs: True
        - force: True

/opt/GData_OpenERP_Data_Pump/creds_oa.py:
    file.managed:
        - source: salt://gdata_oerp_pump/creds_oa.py
        - makedirs: True
        - template: jinja
        - depends:
            - extract-gdata_oerp_pump
            - /opt/GData_OpenERP_Data_Pump


