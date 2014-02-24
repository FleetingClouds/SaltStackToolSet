#!/bin/sh

### BEGIN INIT INFO
# Provides:             {{ pillar['openerp_service_name'] }}
# Required-Start:       $remote_fs $syslog
# Required-Stop:        $remote_fs $syslog
# Should-Start:         $network
# Should-Stop:          $network
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Enterprise Resource Management software
# Description:          Open ERP is a complete ERP and CRM software.
### END INIT INFO

PATH=/bin:/sbin:/usr/bin
DAEMON={{ pillar['openerp_installation_path'] }}/openerp-{{ pillar['openerp_major_revision'] }}/server/openerp-server
NAME={{ pillar['openerp_service_name'] }}
DESC=openerp-server

# Specify the user name (Default: openerp).
USER={{ pillar['openerp_user'] }}

# Specify an alternate config file (Default: /etc/openerp-server.conf).
CONFIGFILE="{{ pillar['openerp_configuration_path'] }}/openerp-server.conf"

# pidfile
PIDFILE=/var/run/$NAME.pid

# Additional options that are passed to the Daemon.
DAEMON_OPTS="-c $CONFIGFILE"

[ -x $DAEMON ] || exit 0
[ -f $CONFIGFILE ] || exit 0

checkpid() {
    [ -f $PIDFILE ] || return 1
    pid=`cat $PIDFILE`
    [ -d /proc/$pid ] && return 0
    return 1
}

case "${1}" in
        start)
                echo -n "Starting ${DESC}: "

                start-stop-daemon --start --quiet --pidfile ${PIDFILE} \
                        --chuid ${USER} --background --make-pidfile \
                        --exec ${DAEMON} -- ${DAEMON_OPTS}

                echo "${NAME}."
                ;;

        stop)
                echo -n "Stopping ${DESC}: "

                start-stop-daemon --stop --quiet --pidfile ${PIDFILE} \
                        --oknodo

                echo "${NAME}."
                ;;

        restart|force-reload)
                echo -n "Restarting ${DESC}: "

                start-stop-daemon --stop --quiet --pidfile ${PIDFILE} \
                        --oknodo
      
                sleep 1

                start-stop-daemon --start --quiet --pidfile ${PIDFILE} \
                        --chuid ${USER} --background --make-pidfile \
                        --exec ${DAEMON} -- ${DAEMON_OPTS}

                echo "${NAME}."
                ;;

        *)
                N=/etc/init.d/${NAME}
                echo "Usage: ${NAME} {start|stop|restart|force-reload}" >&2
                exit 1
                ;;
esac

exit 0
