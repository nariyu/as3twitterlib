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
	import jp.playwell.twitter.data.Account;
	import jp.playwell.twitter.data.Tweet;
	import jp.playwell.twitter.utils.TweetUtil;
	[Event(name="progress", type="flash.events.ProgressEvent")]
	/**
	 *
	 * @author nariyu
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
		public function StatusesShowLoader(account:Account, tweetId:String)
		{

			super();
			url = "statuses/show/" + tweetId;
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
		public var tweet:Tweet;


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

			super.completeHandler(event);

			tweet = TweetUtil.parseTweet(data);
			trace(tweet.text);

		}
	}
}
