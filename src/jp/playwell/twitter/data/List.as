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
	public class List extends CoreData
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
		 */
		public function List()
		{

			super();

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
		public var description:String;

		/**
		 *
		 * @default
		 */
		public var fullName:String;

		/**
		 *
		 * @default
		 */
		public var id:String;

		/**
		 *
		 * @default
		 */
		public var isPrivate:Boolean;

		/**
		 *
		 * @default
		 */
		public var memberCount:int;

		/**
		 *
		 * @default
		 */
		public var name:String;

		/**
		 *
		 * @default
		 */
		public var slug:String;

		/**
		 *
		 * @default
		 */
		public var subscriberCount:int;

		/**
		 *
		 * @default
		 */
		public var uri:String;

		/**
		 *
		 * @default
		 */
		public var user:User;
	}
}
