////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import jp.playwell.twitter.core.twitter_internal;
	import jp.playwell.twitter.data.Account;
	import jp.playwell.twitter.events.TwitterOAuthEvent;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;

	use namespace twitter_internal;
	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="receivedToken", type="jp.playwell.twitter.events.TwitterOAuthEvent")]
	[Event(name="accessTokenReceived", type="jp.playwell.twitter.events.TwitterOAuthEvent")]
	[Event(name="verifiedComplete", type="jp.playwell.twitter.events.TwitterOAuthEvent")]
	/**
	 *
	 * @author nariyu
	 */
	public class TwitterOAuth extends EventDispatcher
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
		public function TwitterOAuth()
		{

			super();

			consumer = new OAuthConsumer(TwitterAPIConfig.consumerKey,
				TwitterAPIConfig.consumerSecret);

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
		public var account:Account;

		/**
		 *
		 * @default
		 */
		public var callback:String;

		/**
		 *
		 * @default
		 */
		private var consumer:OAuthConsumer;

		/**
		 *
		 * @default
		 */
		private var loader:URLLoader;

		/**
		 *
		 * @default
		 */
		private var token:OAuthToken;


		//----------------------------------------------------------
		//
		//
		//   Event handlers 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param event
		 */
		private function accessTokenLoader_completeHandler(event:Event):void
		{

			var responceData:String = String(loader.data);
			var vars:URLVariables = new URLVariables(responceData);

			var accessToken:OAuthToken = new OAuthToken(vars.oauth_token,
				vars.oauth_token_secret);

			account = new Account;
			account.oauthKey = accessToken.key;
			account.oauthSecret = accessToken.secret;

			// access_token を完了しました

			var verifyLoader:AccountVerifyCredentialsLoader = new AccountVerifyCredentialsLoader;
			verifyLoader.addEventListener(ErrorEvent.ERROR, loader_errorHandler);
			verifyLoader.addEventListener(Event.COMPLETE,
				verifyLoader_completeHandler);
			verifyLoader.account = account;
			verifyLoader.load();

			var e:TwitterOAuthEvent = new TwitterOAuthEvent(TwitterOAuthEvent.ACCESS_TOKEN_RECEIVED);
			e.account = account;
			dispatchEvent(e);

		}

		/**
		 *
		 * @param event
		 */
		private function loader_errorHandler(event:ErrorEvent):void
		{

			trace(event.text);

			account = null;
			dispatchEvent(event.clone() as ErrorEvent);

		}

		/**
		 *
		 * @param event
		 */
		private function requestTokenLoader_completeHandler(event:Event):void
		{

			// request_token を完了

			var responceData:String = String(loader.data);
			var vars:URLVariables = new URLVariables(responceData);

			token = new OAuthToken;
			token.key = vars.oauth_token;
			token.secret = vars.oauth_token_secret;

			var url:String = "http://api.twitter.com/oauth/authorize?oauth_token=" + token.key;

			var e:TwitterOAuthEvent = new TwitterOAuthEvent(TwitterOAuthEvent.RECEIVED_TOKEN);
			e.authorizeURL = url;
			dispatchEvent(e);

		}

		/**
		 *
		 * @param event
		 */
		private function verifyLoader_completeHandler(event:Event):void
		{

			var e:TwitterOAuthEvent = new TwitterOAuthEvent(TwitterOAuthEvent.VERIFIED_COMPLETE);
			e.account = account;
			dispatchEvent(e);

		}


		//----------------------------------------------------------
		//
		//
		//   Methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param pin
		 * @return
		 */
		public function checkPin(pin:String):Boolean
		{

			if (!token)
			{
				trace("hoge");
				return false;
			}

			// access_token を開始

			var url:String = "http://api.twitter.com/oauth/access_token";

			var oauthRequest:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_MEHTOD_GET,
				url, {oauth_verifier: pin}, consumer, token);

			var request:URLRequest = new URLRequest(oauthRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1,
				OAuthRequest.RESULT_TYPE_URL_STRING));
			request.method = OAuthRequest.HTTP_MEHTOD_GET;
			request.authenticate = false;

			loader = new URLLoader(request);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
				loader_errorHandler);
			loader.addEventListener(Event.COMPLETE,
				accessTokenLoader_completeHandler);

			return true;

		}

		/**
		 *
		 */
		public function interrupt():void
		{

			if (loader)
			{
				loader.removeEventListener(IOErrorEvent.IO_ERROR,
					loader_errorHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
					loader_errorHandler);
				loader.removeEventListener(Event.COMPLETE,
					accessTokenLoader_completeHandler);
			}

		}

		/**
		 *
		 */
		public function requestToken():void
		{

			var url:String = "http://api.twitter.com/oauth/request_token";

			var params:Object = {};

			if (callback is String)
				params["oauth_callback"] = callback;

			var oauthRequest:OAuthRequest = new OAuthRequest("GET", url, params,
				consumer);

			var request:URLRequest = new URLRequest(oauthRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1));

			// request_token を開始
			loader = new URLLoader(request);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
				loader_errorHandler);
			loader.addEventListener(Event.COMPLETE,
				requestTokenLoader_completeHandler);

		}
	}
}
