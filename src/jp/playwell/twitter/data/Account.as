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
	public class Account extends CoreData
	{


		//----------------------------------------------------------
		//
		//
		//   Properties 
		//
		//
		//----------------------------------------------------------

		[Transient]
		/**
		 *
		 * @default
		 */
		public var hourlyLimit:Number;

		/**
		 *
		 * @default
		 */
		public var oauthKey:String;

		/**
		 *
		 * @default
		 */
		public var oauthSecret:String;

		[Transient]
		/**
		 *
		 * @default
		 */
		public var remainCount:Number;

		[Transient]
		/**
		 *
		 * @default
		 */
		public var resetDate:Date;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var user:User;
	}
}
