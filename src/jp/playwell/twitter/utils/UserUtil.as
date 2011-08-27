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
	import jp.playwell.twitter.data.User;

	use namespace twitter_internal;
	/**
	 *
	 * @author nariyu
	 */
	public class UserUtil
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
		twitter_internal static var screenNameMap:Dictionary = new Dictionary(true);

		/**
		 *
		 * @default
		 */
		twitter_internal static var storedUsers:Dictionary = new Dictionary;


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
		public static function parseUser(obj:Object):User
		{

			var id:String = obj.id_str as String;

			var user:User;

			if (storedUsers.hasOwnProperty(id))
			{
				user = storedUsers[id];
			}
			else
			{
				user = new User;
				user.id = id;
			}

			user.rawObject = obj;

			user.screenName = obj.screen_name as String;
			user.name = obj.name as String;
			user.url = obj.url as String;
			user.description = obj.description as String;
			user.location = obj.location as String;
			user.profileImageURL = obj.profile_image_url as String;
			user.numOfTweets = obj.statuses_count as Number;
			user.numOfFollowers = obj.followers_count as Number;
			user.numOfFollowing = obj.friends_count as Number;
			user.numOfFavorites = obj.favourites_count as Number;
			user.joinedDate = DateUtil.parseDateString(obj.created_at as String);

			storedUsers[id] = user;
			screenNameMap[user.screenName] = user;

			return user;

		}
	}
}
