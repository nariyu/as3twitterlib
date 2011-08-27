////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.utils
{
	import flash.utils.Dictionary;
	import jp.playwell.twitter.core.twitter_internal;
	import jp.playwell.twitter.data.List;

	use namespace twitter_internal;
	/**
	 *
	 * @author nariyu
	 */
	public class ListUtil
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
		twitter_internal static var storedLists:Dictionary = new Dictionary(true);


		//----------------------------------------------------------
		//
		//
		//   Static methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param obj
		 * @return
		 */
		public static function parseList(obj:Object):List
		{

			var id:String = obj.id_str as String;

			var list:List;

			if (storedLists.hasOwnProperty(id))
			{
				list = storedLists[id];
			}
			else
			{
				list = new List;
				list.id = id;
			}

			list.rawObject = obj;

			list.name = obj.name as String;
			list.fullName = obj.full_name as String;
			list.slug = obj.slug as String;
			list.subscriberCount = obj.subscriver_count as int;
			list.memberCount = obj.member_count as int;
			list.uri = obj.uri as String;
			list.isPrivate = obj.mode == "private";
			list.description = obj.description as String;

			if (obj.hasOwnProperty("user"))
			{
				list.user = UserUtil.parseUser(obj.user);
			}

			storedLists[id] = list;

			return list;

		}
	}
}
