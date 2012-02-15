component extends="plugins.cron.inc.resource.base.cron" {
	public void function execute(struct options = {}) {
		local.servBackup = getService('backup', 'backup');
		local.servBackup.periodicBackup(arguments.options);
	}
}
