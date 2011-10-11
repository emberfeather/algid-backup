component extends="algid.inc.resource.base.model" {
	public component function init(required component i18n, required string locale) {
		super.init(arguments.i18n, arguments.locale);
		
		// Set the bundle information for translation
		add__bundle('plugins/backup/i18n/inc/model', 'modBackup');
		
		// Created On
		add__attribute(
			attribute = 'createdOn',
			defaultValue = now()
		);
		
		// Path
		add__attribute(
			attribute = 'path',
			defaultValue = '/storage/backup/backups'
		);
		
		// Directory
		add__attribute(
			attribute = 'directory',
			defaultValue = 'backup'
		);
		
		return this;
	}
	
	public string function generateDirectory(date backupDate = now(), string prefix = 'backup') {
		local.directory = arguments.prefix
				& '-'
				& dateformat(arguments.backupDate, 'yyyy-mm-dd')
				& '-'
				& timeformat(arguments.backupDate, 'HH-mm-ss');
		
		this.setDirectory(local.directory);
		
		return local.directory;
	}
	
	public string function getFullPath() {
		return this.getPath() & '/' & this.getDirectory();
	}
}
