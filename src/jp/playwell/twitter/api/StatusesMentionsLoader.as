////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api
{
	import jp.playwell.twitter.data.Account;
	/**
	 *
	 * @author nariyu
	 * @see https://dev.twitter.com/docs/api/1/get/statuses/mentions
	 */
	public class StatusesMentionsLoader extends StatusesHomeTimeline
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
		 */
		public function StatusesMentionsLoader(account:Account)
		{
			super(account);
			
			url = "statuses/mentions";
		}
	}
}
