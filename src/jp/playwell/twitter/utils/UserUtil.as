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
			if (obj.hasOwnProperty("from_user_id_str"))
			{
				id = obj.from_user_id_str;
			}

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

			if (obj.hasOwnProperty("screen_name"))
			{
				user.screenName = obj.screen_name as String;
			}
			
			if (obj.hasOwnProperty("name"))
			{
				user.name = obj.name as String;
			}
			
			if (obj.hasOwnProperty("url"))
			{
				user.url = obj.url as String;
			}
			
			if (obj.hasOwnProperty("description"))
			{
				user.description = obj.description as String;
			}
			
			if (obj.hasOwnProperty("lang"))
			{
				user.location = obj.lang as String;
			}
			
			if (obj.hasOwnProperty("listed_count"))
			{
				user.listedCount = obj.listed_count as int;
			}
			
			if (obj.hasOwnProperty("location"))
			{
				user.location = obj.location as String;
			}
			
			if (obj.hasOwnProperty("protected"))
			{
				user.isProtected = obj["protected"] as Boolean;
			}
			
			if (obj.hasOwnProperty("profile_image_url"))
			{
				user.profileImageURL = obj.profile_image_url as String;
			}
			
			if (obj.hasOwnProperty("statuses_count"))
			{
				user.tweetsCount = obj.statuses_count as Number;
			}
			
			if (obj.hasOwnProperty("followers_count"))
			{
				user.followersCount = obj.followers_count as Number;
			}
			
			if (obj.hasOwnProperty("friends_count"))
			{
				user.friendsCount = obj.friends_count as Number;
			}
			
			if (obj.hasOwnProperty("favorites_count"))
			{
				user.numOfFavorites = obj.favorites_count as Number;
			}
			
			if (obj.hasOwnProperty("created_at"))
			{
				user.joinedDate = DateUtil.parseDateString(obj.created_at as String);
			}

			storedUsers[id] = user;
			screenNameMap[user.screenName] = user;

			return user;

		}
	}
}
