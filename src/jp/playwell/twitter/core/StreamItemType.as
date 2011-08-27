////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.core
{
	/**
	 *
	 * @author nariyu
	 */
	public class StreamItemType
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
		public static const DELETE:String = "delete";

		/**
		 *
		 * @default
		 */
		public static const ERROR:String = "error";

		/**
		 *
		 * @default
		 */
		public static const FAVORITE:String = "favorite";

		/**
		 *
		 * @default
		 */
		public static const FOLLOW:String = "follow";

		/**
		 *
		 * @default
		 */
		public static const LIST_MEMBER_ADDED:String = "listMemberAdded";

		/**
		 *
		 * @default
		 */
		public static const LIST_MEMBER_REMOVED:String = "listMemberRemoved";

		/**
		 *
		 * @default
		 */
		public static const TWEET:String = "tweet";

		/**
		 *
		 * @default
		 */
		public static const UNFAVORITE:String = "unfavorite";

		/**
		 *
		 * @default
		 */
		public static const UNKNOWN_EVENT:String = "unknownEvent";
	}
}
