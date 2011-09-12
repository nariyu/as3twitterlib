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
	import jp.playwell.twitter.data.Status;
	import jp.playwell.twitter.utils.StatusUtil;
	/**
	 *
	 * @author nariyu
	 * @see https://dev.twitter.com/docs/api/1/post/statuses/destroy/%3Aid
	 */
	public class StatusesDestroyLoader extends TwitterLoaderBase
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
		 * @param tweetId
		 */
		public function StatusesDestroyLoader(account:Account, statusId:String)
		{
			super(account);

			url = "statuses/destroy/" + statusId;

			this.statusId = statusId;

			vars.include_entities = "true";
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
		public var status:Status;

		/**
		 *
		 * @default
		 */
		public var statusId:String;


		//----------------------------------------------------------
		//
		//
		//   Overriden methods 
		//
		//
		//----------------------------------------------------------

		override protected function completeHandler(event:Event):void
		{
			status = StatusUtil.parseStatus(data);
		}
	}
}
