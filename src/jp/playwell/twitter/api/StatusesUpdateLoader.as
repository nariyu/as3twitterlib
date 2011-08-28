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
	 * @see https://dev.twitter.com/docs/api/1/post/statuses/update
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
		public function StatusesUpdateLoader(account:Account, text:String)
		{

			super(account);

			url = "statuses/update";
			method = URLRequestMethod.POST;

			this.text = text;

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

			delete vars.in_reply_to_status_id;

			vars.status = text;

			if (replyTo && replyTo.match(/^\d+$/))
				vars.in_reply_to_status_id = replyTo;

			super.load();

		}
	}
}
