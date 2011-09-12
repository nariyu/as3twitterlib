////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.data
{
	/**
	 *
	 * @author nariyu
	 */
	public class StreamItem
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
		 * @param type
		 */
		public function StreamItem(type:String)
		{

			_type = type;

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

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var message:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var sourceUser:User;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var targetList:List;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var targetStatus:Status;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var targetUser:User;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var status:Status;

		/**
		 *
		 * @default
		 */
		private var _type:String;


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
		public function get type():String
		{

			return _type;

		}
	}
}
