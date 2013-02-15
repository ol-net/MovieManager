package business.database
{
	import flash.events.EventDispatcher;
	
	import mx.collections.XMLListCollection;
	
	public class SelectVideoSQL extends EventDispatcher
	{
		import flash.data.SQLStatement;
		import flash.data.SQLResult;
		import flash.events.SQLEvent;
		import flash.events.SQLErrorEvent;
		import mx.collections.ArrayCollection;
		import events.SQLConnectionIsOpen;
		import events.SQLVideoInsideEvent;
		import events.SQLVideoInEvent;
		
		private var selectStatement:SQLStatement;
		private var result:SQLResult;
		private var resultXML:XML;
		private var con:DatabaseConnectionSQL;
		private var elem:Object;
		private var videos:XMLListCollection;
		
		static private var instance:SelectVideoSQL;
		
		private var videoInside:Boolean = false;
		
		static public function getInstance():SelectVideoSQL
		{
			if (instance == null) 
			{
				instance = new SelectVideoSQL();
			}
			
			return instance;
		}
		
		public function initSQLViewAdopters():void
		{		
			con = DatabaseConnectionSQL.getInstance();
			
			videos = new XMLListCollection();
			
			selectStatement = new SQLStatement();	
			selectStatement.sqlConnection = con.getSQLConncection();
			
			selectStatement.text = "SELECT id, videoName, thumbnailPath FROM movman ORDER BY id DESC";
			
			selectStatement.addEventListener(SQLEvent.RESULT, resultHandlerSelect); 
			selectStatement.addEventListener(SQLErrorEvent.ERROR, errorHandler); 
			
			selectStatement.execute();
		}
		
		public function resultHandlerSelect(event:SQLEvent):void
		{ 
			result = selectStatement.getResult(); 
			
			var rArr:Array = result.data;
			
			if(result)
			{      				
				var numResults:int = 0;
				
				if(result.data != null)
				{
					numResults = result.data.length; 
				}
				
				var ad:Object = "";
				
				for (var i:int = 0; i < numResults; i++) 
				{ 
					var row:Object = result.data[i]; 
					var name:String = row.videoName;
					var img:String = row.thumbnailPath;
					
					ad = "<video><thumbnail>"+img+"</thumbnail><url>"+name+"</url></video>";
					
					videos.addItem(new XML(ad));
				} 
			}
			var eCon:SQLConnectionIsOpen = new SQLConnectionIsOpen(SQLConnectionIsOpen.READERCOMPLETE);
			this.dispatchEvent(eCon);
		}
		
		private var option:Boolean;
		
		public function checkVideo(vName:String, option:Boolean):void
		{
			this.option = option;
			
			con = DatabaseConnectionSQL.getInstance();
			
			selectStatement = new SQLStatement();	
			selectStatement.sqlConnection = con.getSQLConncection();
			
			selectStatement.addEventListener(SQLEvent.RESULT, resultHandlerForVideo); 
			selectStatement.addEventListener(SQLErrorEvent.ERROR, errorHandler); 
			
			selectStatement.text = "SELECT id FROM movman WHERE videoName=:name";
			
			selectStatement.parameters[":name"] = vName;
			
			selectStatement.execute();
		}
		
		public function resultHandlerForVideo(event:SQLEvent):void
		{
			result = selectStatement.getResult(); 
			
			var rArr:Array = result.data;
			
			if(result)
			{      			
				var numResults:int = 0;
				
				if(result.data != null)
				{
					numResults = result.data.length; 
					videoInside = true;
				}
				else
				{
					videoInside = false;
				}
			} 
			else
			{
				videoInside = false;
			}
			
			if(option)
			{
				var eCon:SQLVideoInsideEvent = new SQLVideoInsideEvent(SQLVideoInsideEvent.SELECTVIDEOCOMPLETE);
				this.dispatchEvent(eCon);
			}
			else
			{
				var eCon2:SQLVideoInEvent = new SQLVideoInEvent(SQLVideoInEvent.VIDEOIN);
				this.dispatchEvent(eCon2);
			}
		}
		
		public function getVideosXML():XMLListCollection
		{
			return videos;
		}
		
		public function getVideoInsideStatus():Boolean
		{
			return videoInside;
		}
		
		public function errorHandler(event:SQLErrorEvent):void 
		{ 
			videoInside = false;
		}
	}
}