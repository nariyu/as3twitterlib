////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api
{
	import flash.events.ErrorEvent;
	import flash.net.URLRequestMethod;
	import jp.playwell.twitter.api.supportClasses.TwitterLoaderBase;
	import jp.playwell.twitter.data.Account;
	/**
	 *
	 * @author nariyu
	 */
	public class StatusesUpdateLoader extends TwitterLoaderBase
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
		public function StatusesUpdateLoader(account:Account)
		{

			super();
			url = "statuses/update";
			method = URLRequestMethod.POST;
			this.account = account;

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
		public var replyTo:String;

		/**
		 *
		 * @default
		 */
		public var text:String;


		//----------------------------------------------------------
		//
		//
		//   Overriden methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 */
		override public function load():void
		{

			vars.status = text;

			if (replyTo)
				vars.in_reply_to_status_id = replyTo;
			else
				delete vars.in_reply_to_status_id;

			super.load();

		}
	}
}
