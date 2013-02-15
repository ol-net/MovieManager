package business.database
{
	import flash.events.EventDispatcher;
	
	public class DatabaseConnectionSQL
	{
		import flash.data.SQLConnection;
		import flash.data.SQLStatement;
		import flash.data.SQLResult;
		import flash.events.SQLEvent;
		import flash.events.SQLErrorEvent;
		import flash.filesystem.File;
		
		private var aConn:SQLConnection;
		private var sqlStatement:SQLStatement;
		private var dbFile:File;
		
		static private var instance:DatabaseConnectionSQL;
		
		static public function getInstance():DatabaseConnectionSQL
		{
			if (instance == null) 
			{
				instance = new DatabaseConnectionSQL();
			}
			return instance;
		}
		
		public function initConnection():void
		{
			this.dbFile = File.applicationStorageDirectory.resolvePath("movman.db");
			
			this.aConn = new SQLConnection();
			this.aConn.addEventListener(SQLEvent.OPEN, onConnOpen);
			this.aConn.addEventListener(SQLErrorEvent.ERROR, onConnError);
			this.aConn.openAsync(dbFile);
			
			function onConnOpen(se:SQLEvent):void
			{
				aConn.removeEventListener(SQLEvent.OPEN, onConnOpen);
				aConn.removeEventListener(SQLErrorEvent.ERROR, onConnError);					
				sqlStatement = new SQLStatement();	
				sqlStatement.sqlConnection = aConn;
				
				// create adopter table
				sqlStatement.text = "create table if not exists movman " +
					"(id integer primary key autoincrement, " +
					"videoName TEXT NOT NULL, thumbnailPath TEXT NOT NULL)";
				
				sqlStatement.execute();
			}
			
			function onConnError(see:SQLErrorEvent):void
			{
				aConn.removeEventListener(SQLEvent.OPEN, onConnOpen);
				aConn.removeEventListener(SQLErrorEvent.ERROR, onConnError);
			}
		}
		
		public function getSQLConncection():SQLConnection
		{
			return aConn;
		}
	}
}