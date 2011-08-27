////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.events
{
	import flash.events.Event;
	import jp.playwell.twitter.data.Account;
	import org.iotashan.oauth.OAuthToken;
	/**
	 *
	 * @author nariyu
	 */
	public class TwitterOAuthEvent extends Event
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
		public static const ACCESS_TOKEN_RECEIVED:String = "accessTokenReceived";

		/**
		 *
		 * @default
		 */
		public static const RECEIVED_TOKEN:String = "receivedToken";

		/**
		 *
		 * @default
		 */
		public static const VERIFIED_COMPLETE:String = "verifiedComplete";


		//----------------------------------------------------------
		//
		//
		//   Constructor 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function TwitterOAuthEvent(type:String, bubbles:Boolean = false,
			cancelable:Boolean = false)
		{

			super(type, bubbles, cancelable);

		}


		//----------------------------------------------------------
		//
		//
		//   Properties 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @default
		 */
		public var account:Account;

		/**
		 *
		 * @default
		 */
		public var authorizeURL:String;


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
		override public function clone():Event
		{

			return new TwitterOAuthEvent(type, bubbles, cancelable);

		}
	}
}
