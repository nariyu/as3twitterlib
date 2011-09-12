////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api
{
	import jp.playwell.twitter.data.Account;
	/**
	 *
	 * @author nariyu
	 * @see https://dev.twitter.com/docs/api/1/get/statuses/user_timeline
	 */
	public class StatusesUserTimelineLoader extends StatusesHomeTimelineLoader
	{


		//----------------------------------------------------------
		//
		//
		//   Constructor 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param account
		 */
		public function StatusesUserTimelineLoader(account:Account)
		{
			super(account);

			url = "statuses/user_timeline";
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
		public var screenName:String;

		/**
		 *
		 * @default
		 */
		public var userId:String;


		//----------------------------------------------------------
		//
		//
		//   Overriden methods 
		//
		//
		//----------------------------------------------------------

		override public function load():void
		{
			delete vars.screen_name;
			delete vars.user_id;

			if (screenName)
				vars.screen_name = screenName;

			if (userId)
				vars.user_id = userId;

			super.load();
		}
	}
}
