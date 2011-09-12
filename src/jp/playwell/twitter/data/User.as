////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.data
{
	[RemoteClass]
	/**
	 *
	 * @author nariyu
	 */
	public class User extends CoreData
	{


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
		public var description:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var id:String;

		[Bindable]
		/**
		 * 
		 * @default
		 */
		public var isProtected:Boolean;
		
		[Bindable]
		/**
		 *
		 * @default
		 */
		public var joinedDate:Date;
		
		[Bindable]
		/**
		 *
		 * @default
		 */
		public var lang:String;
		
		[Bindable]
		/**
		 *
		 * @default
		 */
		public var listedCount:int;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var location:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var name:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var numOfFavorites:int;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var followersCount:int;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var friendsCount:int;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var tweetsCount:int;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var profileImageURL:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var screenName:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var url:String;
	}
}
