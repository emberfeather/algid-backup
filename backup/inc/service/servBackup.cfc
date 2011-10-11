<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="periodicBackup" access="public" returntype="void" output="false">
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset local.plugin = variables.transport.theApplication.managers.plugin.getBackup() />
		<cfset local.observer = getPluginObserver('backup', 'backup') />
		
		<cfset local.observer.beforeBackup(variables.transport, arguments.options) />
		
		<cfset local.backup = getModel('backup', 'backup') />
		
		<cfif structKeyExists(arguments.options, 'path') and len(arguments.options.pat)>
			<cfset local.backup.setPath(arguments.options.pat) />
		<cfelse>
			<cfset local.backup.setPath(local.plugin.getStoragePath() & '/backups') />
		</cfif>
		
		<cfif structKeyExists(arguments.options, 'generateDirectory') and isStruct(arguments.options.generateDirectory)>
			<!--- Allow for generating the name of the backup directory --->
			<cfset local.backup.generateDirectory(argumentCollection = arguments.options.generateDirectory) />
		<cfelseif structKeyExists(arguments.options, 'directory') and len(arguments.options.directory)>
			<!--- User defined directory for storing backups --->
			<cfset local.backup.setDirectory(arguments.options.directory) />
		</cfif>
		
		<cfif not directoryExists(local.backup.getFullPath())>
			<cfset directoryCreate(local.backup.getFullPath()) />
		</cfif>
		
		<cftransaction>
			<cfset local.observer.backup(variables.transport, arguments.options, local.backup) />
		</cftransaction>
		
		<cfset local.observer.afterBackup(variables.transport, arguments.options) />
	</cffunction>
</cfcomponent>
