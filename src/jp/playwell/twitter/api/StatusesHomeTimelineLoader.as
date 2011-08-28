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
	import jp.playwell.twitter.data.Tweet;
	import jp.playwell.twitter.utils.TweetUtil;
	/**
	 *
	 * @author nariyu
	 * @see https://dev.twitter.com/docs/api/1/get/statuses/home_timeline
	 */
	public class StatusesHomeTimeline extends TwitterLoaderBase
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
		public function StatusesHomeTimeline(account:Account)
		{
			super(account);

			url = "statuses/home_timeline";
			
			vars.include_entities = "true";
			vars.exclude_replies = "true";
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
		public var count:int = 200;

		/**
		 *
		 * @default
		 */
		public var excludeReplies:Boolean = false;

		/**
		 *
		 * @default
		 */
		public var includeRetweet:Boolean = true;

		/**
		 *
		 * @default
		 */
		public var maxTweetId:String;

		/**
		 *
		 * @default
		 */
		public var senceTweetId:String;

		private var _tweets:Vector.<Tweet>;


		//----------------------------------------------------------
		//
		//
		//   Overriden methods 
		//
		//
		//----------------------------------------------------------

		override protected function completeHandler(event:Event):void
		{
			if (!(data is Array))
				return;

			_tweets = new Vector.<Tweet>;

			var rawTweets:Array = data as Array;
			var n:int = rawTweets.length;
			var tweet:Tweet;

			for (var i:int = 0; i < n; i++)
			{
				tweet = TweetUtil.parseTweet(rawTweets[i]);

				if (tweet)
				{
					_tweets.push(tweet);
				}
			}
		}

		override public function load():void
		{
			delete vars.max_id;
			delete vars.since_id;

			vars.include_rts = includeRetweet ? "true" : "false";
			vars.include_entities = "true";
			vars.exclude_replies = excludeReplies ? "true" : "false";

			if (maxTweetId && maxTweetId.match(/^\d+$/))
				vars.max_id = maxTweetId;

			if (senceTweetId && senceTweetId.match(/^\d+$/))
				vars.sence_id = senceTweetId;

			vars.count = count;

			super.load();
		}


		//----------------------------------------------------------
		//
		//
		//   Methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @return
		 */
		public function get tweets():Vector.<Tweet>
		{
			return _tweets;
		}
	}
}
