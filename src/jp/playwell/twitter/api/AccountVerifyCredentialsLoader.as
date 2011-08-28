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
	import jp.playwell.twitter.data.Account;
	import jp.playwell.twitter.utils.UserUtil;
	/**
	 *
	 * @author nariyu
	 * @see https://dev.twitter.com/docs/api/1/get/account/verify_credentials
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
		public function AccountVerifyCredentialsLoader(account:Account)
		{

			super();
			url = "account/verify_credentials";
			
			this.account = account;

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
