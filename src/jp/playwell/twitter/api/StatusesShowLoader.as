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
	import flash.events.ProgressEvent;
	import jp.playwell.twitter.api.supportClasses.TwitterLoaderBase;
	import jp.playwell.twitter.data.Status;
	import jp.playwell.twitter.utils.StatusUtil;
	[Event(name="progress", type="flash.events.ProgressEvent")]
	/**
	 *
	 * @author nariyu
	 * @see https://dev.twitter.com/docs/api/1/get/statuses/show/%3Aid
	 */
	public class StatusesShowLoader extends TwitterLoaderBase
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
		public function StatusesShowLoader(statusId:String)
		{

			super();

			url = "statuses/show/" + statusId;

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


		//----------------------------------------------------------
		//
		//
		//   Overriden methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param event
		 */
		override protected function completeHandler(event:Event):void
		{

			super.completeHandler(event);

			status = StatusUtil.parseStatus(data);
			//trace(status.text);

		}
	}
}
