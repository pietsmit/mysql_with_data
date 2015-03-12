#!/bin/bash
# This file add some new logic to the entrypoint.sh. I do not want to add a new file, as this could
# lose some future upstream changes. After entrypoint.sh is modified, it is called as the main process.

cd /

# This snippet allows you to specify different datavolumes for different containers 
sed -n -i -e '/DATADIR=/r /tmp/move_datadir_snippet' -e 1x -e '2,${x;p}' -e '${x;p}' entrypoint.sh

# This snippets allow you to import a database, and also to bind to 0.0.0.0
sed -n -i -e '/FLUSH PRIVILEGES/r /tmp/import_database_snippet' -e 1x -e '2,${x;p}' -e '${x;p}' entrypoint.sh

./entrypoint.sh mysqld
