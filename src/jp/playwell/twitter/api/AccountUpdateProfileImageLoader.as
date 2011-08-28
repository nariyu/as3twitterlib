////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api
{
	import com.hurlant.util.Base64;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import jp.playwell.twitter.api.supportClasses.TwitterLoaderBase;
	import jp.playwell.twitter.data.Account;
	/**
	 *
	 * @author nariyu
	 * @see https://dev.twitter.com/docs/api/1/post/account/update_profile_image
	 */
	public class AccountUpdateProfileImageLoader extends TwitterLoaderBase
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
		 * @param account
		 * @param imageBytes
		 */
		public function AccountUpdateProfileImageLoader(account:Account = null,
			imageBytes:ByteArray = null)
		{
			super();
			url = "account/update_profile_image";
			method = URLRequestMethod.POST;

			this.account = account;
			this.imageBytes = imageBytes;
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
		public var imageBytes:ByteArray;


		//----------------------------------------------------------
		//
		//
		//   Overriden methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 */
		override public function load():void
		{

			vars.image = Base64.encodeByteArray(imageBytes);
			super.load();

		}
	}
}
