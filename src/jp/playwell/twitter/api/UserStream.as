////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api
{
	import jp.playwell.twitter.api.supportClasses.TwitterStreamBase;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthToken;
	/**
	 *
	 * @author nariyu
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
