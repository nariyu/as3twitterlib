////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api
{
	import flash.events.Event;
	import jp.playwell.twitter.api.supportClasses.TwitterLoaderBase;
	import jp.playwell.twitter.utils.UserUtil;
	/**
	 *
	 * @author nariyu
	 */
	public class AccountVerifyCredentialsLoader extends TwitterLoaderBase
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
		 */
		public function AccountVerifyCredentialsLoader()
		{

			super();
			url = "account/verify_credentials";

			load();

		}


		//----------------------------------------------------------
		//
		//
		//   Event handlers 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param event
		 */
		override protected function completeHandler(event:Event):void
		{

			account.user = UserUtil.parseUser(data);

		}
	}
}
