////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.data
{
	import flash.geom.Point;
	import jp.playwell.twitter.core.twitter_internal;
	[RemoteClass]
	/**
	 *
	 * @author nariyu
	 */
	public class Tweet extends CoreData
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
		public var createdDate:Date;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var deleted:Boolean;

		/**
		 *
		 * @default
		 */
		public var entities:Object;

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
		public var inReplyTo:Tweet;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var inReplyToStatusId:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var latLng:Point;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var recipient:User;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var retweetOf:Tweet;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var source:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var text:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var user:User;

		/**
		 *
		 * @default
		 */
		twitter_internal var isMessage:Boolean;
	}
}
