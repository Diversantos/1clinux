# /lib/systemd/system/postgrespro-1c-12.service
# It's not recommended to modify this file in-place, because it will be
# overwritten during package upgrades.  If you want to customize, the
# best way is to create a file "/etc/systemd/system/postgrespro-10.service",
# containing
#       .include /lib/systemd/system/postgrespro-10.service
#       ...make your changes here...
# For more info about custom unit files, see
# http://fedoraproject.org/wiki/Systemd#How_do_I_customize_a_unit_file.2F_add_a_custom_unit_file.3F

# Note: changing PGDATA will typically require adjusting SELinux
# configuration as well.

# Note: do not use a PGDATA pathname containing spaces, or you will
# break pg-setup.
[Unit]
Description=Postgres Pro 1c 12 database server
After=syslog.target
After=network.target

[Service]
Type=notify

User=postgres
Group=postgres

Environment=PATH=/opt/pgpro/1c-12/bin:/usr/sbin:/usr/bin:/bin:/sbin
# Location of database directory
EnvironmentFile=/etc/default/postgrespro-1c-12

# Where to send early-startup messages from the server (before the logging
# options of postgresql.conf take effect)
# This is normally controlled by the global default set by systemd
# StandardOutput=syslog

# Disable OOM kill on the postmaster
OOMScoreAdjust=-1000

ExecStartPre=/opt/pgpro/1c-12/bin/check-db-dir ${PGDATA}
ExecStart=/opt/pgpro/1c-12/bin/postgres -D ${PGDATA}
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT

# Give a reasonable amount of time for the server to start up/shut down
TimeoutSec=300

[Install]
WantedBy=multi-user.target

