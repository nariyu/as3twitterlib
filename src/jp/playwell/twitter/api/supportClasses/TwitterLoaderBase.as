////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.api.supportClasses
{
	import com.adobe.serialization.json.JSON;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import jp.playwell.twitter.api.TwitterAPIConfig;
	import jp.playwell.twitter.core.twitter_internal;
	import jp.playwell.twitter.data.Account;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;

	use namespace twitter_internal;
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="error", type="fash.events.ErrorEvent")]
	/**
	 *
	 * @author nariyu
	 */
	public class TwitterLoaderBase extends EventDispatcher
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
		public static const API_BASE_URL:String = "http://api.twitter.com/1/";

		/**
		 *
		 * @default
		 */
		public static var timeout:int = 30000;


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
		public function TwitterLoaderBase()
		{

			super();

			baseURL = API_BASE_URL;

			method = URLRequestMethod.GET;
			vars = new URLVariables;

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
		public var baseURL:String;

		/**
		 *
		 * @default
		 */
		public var data:Object;

		/**
		 *
		 * @default
		 */
		public var httpStatus:int;

		/**
		 *
		 * @default
		 */
		public var loading:Boolean;

		/**
		 *
		 * @default
		 */
		protected var loader:URLLoader;

		/**
		 *
		 * @default
		 */
		protected var method:String;

		/**
		 *
		 * @default
		 */
		protected var rawData:String;

		/**
		 *
		 * @default
		 */
		protected var request:URLRequest;

		/**
		 *
		 * @default
		 */
		protected var timer:Timer;

		/**
		 *
		 * @default
		 */
		protected var url:String;

		/**
		 *
		 * @default
		 */
		protected var vars:URLVariables;

		/**
		 *
		 * @default
		 */
		private var consumer:OAuthConsumer;


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
		protected function completeHandler(event:Event):void
		{
		}

		/**
		 *
		 * @param event
		 */
		protected function errorHandler(event:ErrorEvent):void
		{
		}

		/**
		 *
		 * @param event
		 */
		protected function loader_completeHandler(event:Event):void
		{

			loading = false;

			clearEventListeners();

			rawData = loader.data as String;

			if (!parseJSON(rawData))
				return;

			var e:Event = new Event(Event.COMPLETE);
			completeHandler(e);
			dispatchEvent(e);

		}

		/**
		 *
		 * @param event
		 */
		protected function loader_errorHandler(event:ErrorEvent):void
		{

			loading = false;

			clearEventListeners();

			var text:String = event.text;

			try
			{
				rawData = loader.data;
				data = com.adobe.serialization.json.JSON.decode(loader.data);
				text = data.error.toString();
			}
			catch (e:Error)
			{
			}

			//logger.error(text);

			switch (httpStatus)
			{
				case 0:
					text = "No network connect";
					break;
				case 400:
					text = "Rate limit exceeded";
					break;
				case 401:
					text = "Not authorized";
					break;
				case 403:
					text = "Forbidden";
					break;
				case 404:
					text = "NotFound";
					break;
				case 500:
				case 502:
				case 503:
					text = "Twitter is over capacity";
					break;
				default:
					text = "Unknown error";
					break;
			}

			var errorEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
			errorEvent.text = text;
			errorHandler(errorEvent);
			dispatchEvent(errorEvent);

		}

		/**
		 *
		 * @param event
		 */
		protected function loader_httpResponceStatusHandler(event:HTTPStatusEvent):void
		{

			httpStatus = event.status;

			var responceHeaders:Array = event.responseHeaders;

			var headerName:String;
			var hourlyLimit:Number;
			var remainCount:Number;
			var resetDate:Date;

			for each (var header:URLRequestHeader in responceHeaders)
			{
				headerName = header.name.toLowerCase();

				if (headerName == "x-ratelimit-limit")
				{
					hourlyLimit = Number(header.value);
				}
				else if (headerName == "x-ratelimit-remaining")
				{
					remainCount = Number(header.value);
				}
				else if (headerName == "x-ratelimit-reset")
				{
					var d:Date = new Date();
					d.setTime(Number(header.value) * 1000);
					resetDate = d;
				}
			}

			if (!isNaN(hourlyLimit) && !isNaN(remainCount) && resetDate)
			{
				//account.hourlyLimit = hourlyLimit;
				//account.remainCount = remainCount;
				//account.resetDate = resetDate;
			}

		}

		/**
		 *
		 * @param event
		 */
		protected function timer_timerHandler(event:TimerEvent):void
		{

			interrupt();

			var errorEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
			errorEvent.text = "Timeout";
			errorHandler(errorEvent);
			dispatchEvent(errorEvent);

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
		 */
		public function interrupt():void
		{

			clearEventListeners();
			loading = false;

		}

		/**
		 *
		 */
		public function load():void
		{

			rawData = "";
			data = null;
			interrupt();

			var url:String = baseURL + this.url + ".json";

			request = new URLRequest(url);
			request.authenticate = false;
			request.method = method;
			request.data = vars;

			if (account)
			{
				var token:OAuthToken = new OAuthToken(account.oauthKey,
					account.oauthSecret);

				request.data = (new OAuthRequest(method, url, vars, consumer,
					token)).buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),
					OAuthRequest.RESULT_TYPE_POST);
			}

			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
				loader_errorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,
				loader_httpResponceStatusHandler);
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.load(request);

			if (timeout > 0)
			{
				timer = new Timer(timeout, 1);
				timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
				timer.start();
			}

			loading = true;

		}

		/**
		 *
		 * @param str
		 * @return
		 */
		protected function parseJSON(str:String):Boolean
		{

			if (str == null)
			{
				//logger.error("response is null.");
			}
			else if (str.length == 0)
			{
				//logger.error("response is 0 byte.");
			}

			var errorEvent:ErrorEvent;

			try
			{
				str = str.replace(/\r\n/g, "\n");
				data = com.adobe.serialization.json.JSON.decode(str);

				if (data.error)
				{
					//logger.error(data.error);

					errorEvent = new ErrorEvent(ErrorEvent.ERROR);
					errorEvent.text = data.error;
					errorHandler(errorEvent);
					dispatchEvent(errorEvent);
					return false;
				}
			}
			catch (e:Error)
			{
				var message:String = e.message;

				//logger.error(message);

				if (message.match(/^Unexpected/))
				{
					message = "Connection Failed";
				}

				errorEvent = new ErrorEvent(ErrorEvent.ERROR);
				errorEvent.text = message;
				errorHandler(errorEvent);
				dispatchEvent(errorEvent);
				return false;
			}

			return true;

		}

		/**
		 *
		 */
		private function clearEventListeners():void
		{

			if (loader)
			{
				loader.removeEventListener(IOErrorEvent.IO_ERROR,
					loader_errorHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
					loader_errorHandler);
				loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,
					loader_httpResponceStatusHandler);
				loader.removeEventListener(Event.COMPLETE,
					loader_completeHandler);
			}

			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER, timer_timerHandler);
				timer.stop();
			}

		}
	}
}
