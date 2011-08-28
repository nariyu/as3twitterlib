////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api
{
	import flash.debugger.enterDebugger;
	import flash.utils.escapeMultiByte;
	
	import jp.playwell.twitter.api.supportClasses.TwitterStreamBase;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthToken;
	import org.iotashan.utils.URLEncoding;

	/**
	 *
	 * @author nariyu
	 * @see https://dev.twitter.com/docs/streaming-api/user-streams
	 */
	public class UserStream extends TwitterStreamBase
	{


		//----------------------------------------------------------
		//
		//
		//   Static properties 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @default
		 */
		public static const API_URL:String = "https://userstream.twitter.com/2/user.json";


		//----------------------------------------------------------
		//
		//
		//   Constructor 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param consumer
		 * @param token
		 */
		public function UserStream()
		{

			super();
			
			//vars.replies = "all";

		}


		//----------------------------------------------------------
		//
		//
		//   Overriden methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @return
		 */
		override protected function getURL():String
		{

			return API_URL;

		}
	}
}
