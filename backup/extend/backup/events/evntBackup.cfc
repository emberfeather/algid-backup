component extends="algid.inc.resource.base.event" {
	public void function backup(required struct transport, required struct options, required component backup) {
		// Backup all settings
		local.basePath = arguments.backup.getFullPath();
		
		local.app = arguments.transport.theApplication.managers.singleton.getApplication();
		local.plugins = local.app.getPrecedence();
		
		if(!directoryExists(local.basePath & '/config')) {
			directoryCreate(local.basePath & '/config');
		}
		
		if(fileExists('/root/config/settings.json.cfm')) {
			fileCopy('/root/config/settings.json.cfm', local.basePath & '/config/settings.json.cfm');
		}
		
		if(!directoryExists(local.basePath & '/plugins')) {
			directoryCreate(local.basePath & '/plugins');
		}
		
		for(local.i = 1; local.i <= arrayLen(local.plugins); local.i++) {
			local.key = local.plugins[local.i];
			
			if(!directoryExists(local.basePath & '/plugins/' & local.key)) {
				directoryCreate(local.basePath & '/plugins/' & local.key);
			}
			
			if(!directoryExists(local.basePath & '/plugins/' & local.key & '/config')) {
				directoryCreate(local.basePath & '/plugins/' & local.key & '/config');
			}
			
			if(fileExists('/plugins/' & local.key & '/config/settings.json.cfm')) {
				fileCopy('/plugins/' & local.key & '/config/settings.json.cfm', local.basePath & '/plugins/' & local.key & '/config/settings.json.cfm')
			}
		}
	}
	
	public void function afterBackup(required struct transport, required struct options, required component backup) {
		if(arguments.transport.theApplication.managers.plugin.hasScm()) {
			local.git = arguments.transport.theApplication.managers.singleton.getGit();
			
			// Check if the backup is a git repository
			local.isGit = true;
			local.fullPath = expandPath(arguments.backup.getFullPath());
			
			try {
				local.git.status(local.fullPath);
			} catch(any e) {
				local.isGit = false;
			}
			
			if(local.isGit) {
				local.git.add(local.fullPath, '.');
				local.git.commit(local.fullPath, '-m "Backed up on #arguments.backup.getCreatedOn()#"');
			}
		}
	}
}
