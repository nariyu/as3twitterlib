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
	 */
	public class SearchLoader extends TwitterLoaderBase
	{


		//----------------------------------------------------------
		//
		//
		//   Static properties 
		//
		//
		//----------------------------------------------------------

		private static const API_BASE_URL:String = "https://search.twitter.com/";


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
		public function SearchLoader()
		{
			super();
			baseURL = API_BASE_URL;
			url = "search";
		}


		//----------------------------------------------------------
		//
		//
		//   Properties 
		//
		//
		//----------------------------------------------------------

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var count:int = 100;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var keyword:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var lang:String = "all";

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var maxStatusId:String;

		[Bindable]
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
			_statuses = new Vector.<Status>;
			
			var rawStatuses:Array = [];
			if (data.hasOwnProperty("results"))
			{
				rawStatuses = data.results;
			}
			
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

			if (maxStatusId && maxStatusId.match(/^\d+$/))
				vars.max_id = maxStatusId;

			if (sinceStatusId && sinceStatusId.match(/^\d+$/))
				vars.sence_id = sinceStatusId;

			vars.q = keyword;
			vars.rpp = count;

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
