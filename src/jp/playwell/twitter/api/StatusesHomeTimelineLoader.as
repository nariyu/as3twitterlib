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
	 * @see https://dev.twitter.com/docs/api/1/get/statuses/home_timeline
	 */
	public class StatusesHomeTimelineLoader extends TwitterLoaderBase
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
		public function StatusesHomeTimelineLoader(account:Account)
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
		public var maxStatusId:String;

		/**
		 *
		 * @default
		 */
		public var sinceStatusId:String;

		private var _statuses:Vector.<Status>;


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

			_statuses = new Vector.<Status>;

			var rawStatuses:Array = data as Array;
			var n:int = rawStatuses.length;
			var status:Status;

			for (var i:int = 0; i < n; i++)
			{
				status = StatusUtil.parseStatus(rawStatuses[i]);

				if (status)
				{
					_statuses.push(status);
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

			if (maxStatusId && maxStatusId.match(/^\d+$/))
				vars.max_id = maxStatusId;

			if (sinceStatusId && sinceStatusId.match(/^\d+$/))
				vars.sence_id = sinceStatusId;

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
		public function get statuses():Vector.<Status>
		{
			return _statuses;
		}
	}
}
