# ####
#   Dependencies
# ##
#
apt_prereqs:
     pkg.installed:
         - pkgs:
            - libkrb5-dev
            - libssl-dev
            - libsasl2-dev
            - dtach
            - openssl
            - python-pip
            - python-dev
            - build-essential
            
python_prereqs:
    pip.installed:
        - names:
            - pyopenssl
            - tornado
            - kerberos
        - depends: apt_prereqs

# ####
#   Getting GateOne
# ##
#
pip_build_root:
    file.directory:
        - name: /tmp
        
obtain-gateone:
    cmd.run:
        - name: wget -N https://github.com/liftoff/GateOne/archive/master.zip
        - cwd: /tmp

extract-gateone:
    cmd.run:
        - name: unzip -uo /tmp/master.zip
        - cwd: /tmp
        - depends: obtain-gateone

install-gateone:
    cmd.run:
        - name: python setup.py install
        - cwd: /tmp/GateOne-master
        - depends:
            - extract-gateone
            - python_prereqs

