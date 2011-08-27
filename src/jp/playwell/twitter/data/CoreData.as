////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.data
{
	import jp.playwell.twitter.core.twitter_internal;

	use namespace twitter_internal;
	/**
	 *
	 * @author nariyu
	 */
	public class CoreData
	{


		//----------------------------------------------------------
		//
		//
		//   Static methods 
		//
		//
		//----------------------------------------------------------


		/**
		 *
		 * @param str
		 * @return
		 */
		twitter_internal static function decode(str:String):String
		{

			str = str.replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g,
				'"').replace(/&amp;/g, "&");
			return str;

		}


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
		public function CoreData()
		{
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
		twitter_internal var rawObject:Object;


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
		public function toObject():Object
		{

			return rawObject;

		}
	}
}
