help:
	@echo "*** Development Commands ***"
	@echo "dev_server\t\t Start node.js server"
	@echo "prod_server\t\t Start node.js server with clustering"
	@echo "acl_server\t\t Start node.js server, logging ACL data"
	@echo "periodic_tasks\t\t Start node.js process, only executing periodic tasks"
	@echo "db_update\t\t Start node.js process, only executing DB update task"
	@echo "all_tasks\t\t Start node.js process, only executing DB update and periodic tasks"

# start server
dev_server:
	slc run

# start server in prod mode
prod_server:
	NODE_ENV=production slc run

# start server in acl debug mode
acl_server:
	DEBUG=loopback:security:acl slc run

# run periodic tasks
periodic_tasks:
	YASH_TASK=periodic node server/server.js

# run autoupdate taskw
db_update:
	YASH_TASK=autoupdate node server/server.js

# run all tasks
all_tasks:
	YASH_TASK=autoupdate:periodic node server/server.js