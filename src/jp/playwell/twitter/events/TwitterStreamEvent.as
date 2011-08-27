////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.events
{
	import flash.events.Event;
	import jp.playwell.twitter.data.StreamItem;
	/**
	 *
	 * @author nariyu
	 */
	public class TwitterStreamEvent extends Event
	{


		//----------------------------------------------------------
		//
		//
		//   Static properties 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @default
		 */
		public static const RECEIVE:String = "receive";


		//----------------------------------------------------------
		//
		//
		//   Constructor 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function TwitterStreamEvent(type:String, bubbles:Boolean = false,
			cancelable:Boolean = false)
		{

			super(type, bubbles, cancelable);

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
		public var json:Object;

		/**
		 *
		 * @default
		 */
		public var streamItem:StreamItem;


		//----------------------------------------------------------
		//
		//
		//   Overriden methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @return
		 */
		override public function clone():Event
		{

			return new TwitterStreamEvent(type, bubbles, cancelable);

		}
	}
}
