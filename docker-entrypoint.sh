#!/bin/bash

set -e

# Service mode
if [[ "$1" == "supervisord" ]]; then
	supervisord -c /etc/supervisor/conf.d/supervisord.conf
# Command mode
else
	exec "$@"
fi
