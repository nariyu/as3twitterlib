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
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.SharedObject;
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
	[Event(name="requestTokenReceived", type="jp.playwell.twitter.events.TwitterOAuthEvent")]
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
		public function TwitterOAuth(callback:String = null,
			autoLogin:Boolean = false)
		{

			super();

			this.callback = callback;
			this.autoLogin = autoLogin;

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
		public var autoLogin:Boolean;

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
		//   Setter / Getter 
		//
		//
		//----------------------------------------------------------

		private var _httpStatus:int;

		[Bindable]
		/**
		 *
		 * @return
		 */
		public function get httpStatus():int
		{
			return _httpStatus;
		}

		/**
		 *
		 * @param value
		 */
		public function set httpStatus(value:int):void
		{
		}

		private var _loading:Boolean;

		[Bindable]
		/**
		 *
		 * @return
		 */
		public function get loading():Boolean
		{
			return _loading;
		}

		/**
		 *
		 * @param value
		 */
		public function set loading(value:Boolean):void
		{

		}

		private var _responseHeaders:Array;

		[Bindable]
		/**
		 *
		 * @return
		 */
		public function get responseHeaders():Array
		{
			return _responseHeaders;
		}

		/**
		 *
		 * @param value
		 */
		public function set responseHeaders(value:Array):void
		{
		}


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

			var verifyLoader:AccountVerifyCredentialsLoader = new AccountVerifyCredentialsLoader(account);
			verifyLoader.addEventListener(ErrorEvent.ERROR, loader_errorHandler);
			verifyLoader.addEventListener(Event.COMPLETE,
				verifyLoader_completeHandler);
			verifyLoader.load();

			_loading = true;

			var e:TwitterOAuthEvent = new TwitterOAuthEvent("accessTokenReceived");
			e.account = account;
			dispatchEvent(e);

		}

		/**
		 *
		 * @param event
		 */
		private function loader_errorHandler(event:ErrorEvent):void
		{
			
			//trace(event.text);
			trace(loader.data);

			_loading = false;
			account = null;

			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false,
				event.text, event.errorID));

		}

		private function loader_httpStatusHandler(event:HTTPStatusEvent):void
		{
			//_responseHeaders = event.responseHeaders;
			_httpStatus = event.status;
		}

		/**
		 *
		 * @param event
		 */
		private function requestTokenLoader_completeHandler(event:Event):void
		{

			// request_token を完了
			_loading = false;

			var responceData:String = String(loader.data);
			var vars:URLVariables = new URLVariables(responceData);

			token = new OAuthToken;
			token.key = vars.oauth_token;
			token.secret = vars.oauth_token_secret;

			var url:String = "https://api.twitter.com/oauth/authorize";

			if (autoLogin)
			{
				url = "https://api.twitter.com/oauth/authenticate";
			}

			url += "?oauth_token=" + token.key;

			var e:TwitterOAuthEvent = new TwitterOAuthEvent(TwitterOAuthEvent.TOKEN_RECEIVED);
			e.authorizeURL = url;
			e.token = token;
			dispatchEvent(e);

		}

		/**
		 *
		 * @param event
		 */
		private function verifyLoader_completeHandler(event:Event):void
		{

			_loading = false;

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
		public function authWithXAuth(username:String, password:String):void
		{

			// access_token を開始

			var url:String = "https://api.twitter.com/oauth/access_token";

			var params:Object = {oauth_version: "1.0",
					x_auth_mode: 'client_auth', x_auth_username: username,
					x_auth_password: password};

			var oauthRequest:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_MEHTOD_POST,
				url, params, consumer);

			var postVariables:String = oauthRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1,
				OAuthRequest.RESULT_TYPE_POST) as String;

			var request:URLRequest = new URLRequest(url);
			request.method = OAuthRequest.HTTP_MEHTOD_POST;
			//request.data = vars;
			request.data = postVariables;
			//request.authenticate = false;

			loader = new URLLoader;
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
				loader_errorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,
				loader_httpStatusHandler);
			loader.addEventListener(Event.COMPLETE,
				accessTokenLoader_completeHandler);
			loader.load(request);

			_loading = true;
		}

		/**
		 *
		 * @param pin
		 * @return
		 */
		public function checkPin(pin:String, tokenKey:String = null,
			tokenSecret:String = null):void
		{

			// access_token を開始

			var url:String = "https://api.twitter.com/oauth/access_token";

			if (!token)
			{
				token = new OAuthToken;
				token.key = tokenKey;
				token.secret = tokenSecret;
			}

			var oauthRequest:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_MEHTOD_GET,
				url, {oauth_verifier: pin}, consumer, token);

			var request:URLRequest = new URLRequest(oauthRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1,
				OAuthRequest.RESULT_TYPE_URL_STRING));
			request.method = OAuthRequest.HTTP_MEHTOD_GET;
			//request.authenticate = false;

			loader = new URLLoader;
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
				loader_errorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,
				loader_httpStatusHandler);
			loader.addEventListener(Event.COMPLETE,
				accessTokenLoader_completeHandler);
			loader.load(request);

			_loading = true;
		}

		/**
		 *
		 */
		public function interrupt():void
		{

			_loading = false;

			if (loader)
			{
				loader.removeEventListener(IOErrorEvent.IO_ERROR,
					loader_errorHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
					loader_errorHandler);
				loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,
					loader_httpStatusHandler);
				loader.removeEventListener(Event.COMPLETE,
					accessTokenLoader_completeHandler);
			}

		}

		/**
		 *
		 */
		public function requestToken():void
		{

			var url:String = "https://api.twitter.com/oauth/request_token";

			var params:Object = {};

			if (callback is String)
			{
				params["oauth_callback"] = callback;
			}

			var oauthRequest:OAuthRequest = new OAuthRequest("GET", url, params,
				consumer);
			var request:URLRequest = new URLRequest(oauthRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1));

			// request_token を開始
			loader = new URLLoader;
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
				loader_errorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,
				loader_httpStatusHandler);
			loader.addEventListener(Event.COMPLETE,
				requestTokenLoader_completeHandler);
			loader.load(request);

			_loading = true;

		}
	}
}
