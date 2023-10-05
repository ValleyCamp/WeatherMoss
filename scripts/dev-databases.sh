script_path=$(dirname "${BASH_SOURCE[0]}")

case "$1" in
  start)
    $script_path/mysql-dev-database.sh start
    $script_path/pgsql-dev-database.sh start
    ;;
  stop)
    $script_path/mysql-dev-database.sh stop
    $script_path/pgsql-dev-database.sh stop
    ;;
  *)
    printf "Usage: `basename $0` {start|stop} \nStarts (or stops and deletes) both the MySQL and Postegres docker containers, which the dev environment is expecting to find.\nSimply calls start/stop on both the database-specific scripts.\n\n"
    exit 1
    ;;
esac
