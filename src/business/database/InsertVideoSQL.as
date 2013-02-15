package business.database
{
	import flash.events.EventDispatcher;
	
	public class InsertVideoSQL
	{
		import flash.data.SQLStatement;
		import flash.data.SQLResult;
		import flash.events.SQLEvent;
		import flash.events.SQLErrorEvent;
		
		private var insertStatement:SQLStatement;
		private var updateStatement:SQLStatement;
		private var deleteStatement:SQLStatement;
		
		private var result:SQLResult;
		private var con:DatabaseConnectionSQL;
		
		static private var instance:InsertVideoSQL;
		
		static public function getInstance():InsertVideoSQL
		{
			if (instance == null) 
			{
				instance = new InsertVideoSQL();
			}
			
			return instance;
		}
		
		public function insertVideo(video:String, thumbnail:String):void
		{
			con = DatabaseConnectionSQL.getInstance();
			
			insertStatement = new SQLStatement();	
			insertStatement.sqlConnection = con.getSQLConncection();
			
			insertStatement.text = "insert into movman (videoName, thumbnailPath) values (:name, :img)";
			
			insertStatement.parameters[":name"] = video;
			insertStatement.parameters[":img"] = thumbnail;
			
			insertStatement.execute();
		}
		
		public function updateAdopter(id:String, textName:String, textAdopter:String):void
		{
			con = DatabaseConnectionSQL.getInstance();
			
			updateStatement = new SQLStatement();	
			updateStatement.sqlConnection = con.getSQLConncection();
			
			updateStatement.text = "update mh2go set name = :name, adopter = :adopter where id = :id";
			
			updateStatement.parameters[":id"] = id;
			updateStatement.parameters[":name"] = textName;
			updateStatement.parameters[":adopter"] = textAdopter;
			
			updateStatement.execute();
		}
		
		public function deleteAdopter(id:String):void
		{
			con = DatabaseConnectionSQL.getInstance();
			
			deleteStatement = new SQLStatement();	
			deleteStatement.sqlConnection = con.getSQLConncection();
			
			deleteStatement.text = "delete from mh2go where id = :id";
			
			deleteStatement.parameters[":id"] = id;
			
			deleteStatement.execute();
		}
	}
}