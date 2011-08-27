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
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import jp.playwell.twitter.api.TwitterAPIConfig;
	import jp.playwell.twitter.core.StreamItemType;
	import jp.playwell.twitter.core.twitter_internal;
	import jp.playwell.twitter.data.Account;
	import jp.playwell.twitter.data.List;
	import jp.playwell.twitter.data.StreamItem;
	import jp.playwell.twitter.data.Tweet;
	import jp.playwell.twitter.data.User;
	import jp.playwell.twitter.events.TwitterStreamEvent;
	import jp.playwell.twitter.utils.ListUtil;
	import jp.playwell.twitter.utils.TweetUtil;
	import jp.playwell.twitter.utils.UserUtil;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;

	use namespace twitter_internal;
	[Event(name="open", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	[Event(name="receive", type="jp.playwell.twitter.events.TwitterStreamEvent")]
	/**
	 *
	 * @author nariyu
	 */
	public class TwitterStreamBase extends EventDispatcher
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
		 * @param consumer
		 * @param token
		 */
		public function TwitterStreamBase()
		{

			super();
			this.vars = new URLVariables;

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
		public var vars:URLVariables;

		/**
		 *
		 * @default
		 */
		private var consumer:OAuthConsumer;

		/**
		 *
		 * @default
		 */
		private var stream:URLStream;

		/**
		 *
		 * @default
		 */
		private var textPart:String;


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
		protected function stream_completeHandler(event:Event):void
		{

			close();
			dispatchEvent(new Event(Event.CLOSE));

		}

		/**
		 *
		 * @param event
		 */
		protected function stream_errorHandler(event:ErrorEvent):void
		{

			close();

			var errorEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
			errorEvent.text = event.text;

			dispatchEvent(errorEvent);
			dispatchEvent(new Event(Event.CLOSE));

		}

		/**
		 *
		 * @param event
		 */
		protected function stream_httpStatusHandler(event:HTTPStatusEvent):void
		{

			dispatchEvent(event.clone());

		}

		/**
		 *
		 * @param event
		 */
		protected function stream_openHandler(event:Event):void
		{

			dispatchEvent(event.clone());

		}

		/**
		 *
		 * @param event
		 */
		protected function stream_progressHandler(event:ProgressEvent):void
		{

			// ストリームを受け取った
			dispatchEvent(event.clone());

			var text:String = stream.readUTFBytes(stream.bytesAvailable);
			parseText(text);

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
		public function close():void
		{

			if (stream)
			{
				stream.removeEventListener(HTTPStatusEvent.HTTP_STATUS,
					stream_httpStatusHandler);
				stream.removeEventListener(Event.OPEN, stream_openHandler);
				stream.removeEventListener(ProgressEvent.PROGRESS,
					stream_progressHandler);
				stream.removeEventListener(Event.COMPLETE,
					stream_completeHandler);
				stream.removeEventListener(IOErrorEvent.IO_ERROR,
					stream_errorHandler);
				stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
					stream_errorHandler);

				try
				{
					stream.close();
				}
				catch (error:Error)
				{
				}
			}

		}

		/**
		 *
		 */
		public function connect():void
		{

			close();

			var url:String = getURL();
			var regexpResult:Object = url.match(/^(https?:\/\/[^\/]+)/);

			var token:OAuthToken = new OAuthToken(account.oauthKey,
				account.oauthSecret);

			var oauthHeader:URLRequestHeader = (new OAuthRequest(OAuthRequest.HTTP_MEHTOD_GET,
				url, {"oauth_version": "1.0"}, consumer, token)).buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),
				OAuthRequest.RESULT_TYPE_HEADER, regexpResult[1]) as URLRequestHeader;

			var request:URLRequest = new URLRequest(url);
			request.requestHeaders = [oauthHeader];
			request.data = vars;

			stream = new URLStream;
			stream.addEventListener(HTTPStatusEvent.HTTP_STATUS,
				stream_httpStatusHandler);
			stream.addEventListener(Event.OPEN, stream_openHandler);
			stream.addEventListener(ProgressEvent.PROGRESS,
				stream_progressHandler);
			stream.addEventListener(Event.COMPLETE, stream_completeHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, stream_errorHandler);
			stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
				stream_errorHandler);
			stream.load(request);

		}

		/**
		 *
		 * @return
		 */
		protected function getURL():String
		{

			return null;

		}

		/**
		 *
		 * @param jsonString
		 */
		protected function parseJSON(jsonString:String):void
		{

			var event:TwitterStreamEvent;
			var tweet:Tweet;
			var user:User;
			var sourceUser:User;
			var targetUser:User;
			var targetTweet:Tweet;
			var targetList:List;
			var streamItem:StreamItem;

			try
			{
				var json:Object = com.adobe.serialization.json.JSON.decode(jsonString);

				// イベント
				if (json.hasOwnProperty("event"))
				{
					var eventType:String = json.event as String;

					switch (eventType)
					{
						case "favorite":
							sourceUser = UserUtil.parseUser(json.source);
							targetTweet = TweetUtil.parseTweet(json.target_object);
							event = new TwitterStreamEvent(TwitterStreamEvent.RECEIVE);
							streamItem = new StreamItem(StreamItemType.FAVORITE);
							break;
						case "unfavorite":
							sourceUser = UserUtil.parseUser(json.source);
							targetTweet = TweetUtil.parseTweet(json.target_object);
							event = new TwitterStreamEvent(TwitterStreamEvent.RECEIVE);
							streamItem = new StreamItem(StreamItemType.UNFAVORITE);
							break;
						case "follow":
							sourceUser = UserUtil.parseUser(json.source);
							targetUser = UserUtil.parseUser(json.target);
							event = new TwitterStreamEvent(TwitterStreamEvent.RECEIVE);
							streamItem = new StreamItem(StreamItemType.FOLLOW);
							break;
						case "list_member_added":
							sourceUser = UserUtil.parseUser(json.source);
							targetUser = UserUtil.parseUser(json.target);
							targetList = ListUtil.parseList(json.target_object);
							event = new TwitterStreamEvent(TwitterStreamEvent.RECEIVE);
							streamItem = new StreamItem(StreamItemType.LIST_MEMBER_ADDED);
							break;
						case "list_member_removed":
							sourceUser = UserUtil.parseUser(json.source);
							targetUser = UserUtil.parseUser(json.target);
							targetList = ListUtil.parseList(json.target_object);
							event = new TwitterStreamEvent(TwitterStreamEvent.RECEIVE);
							streamItem = new StreamItem(StreamItemType.LIST_MEMBER_REMOVED);
							break;
						default:
							//event = new TwitterStreamEvent(TwitterStreamEvent.UNKNOWN_EVENT);
							//streamItem = new StreamItem(StreamItemType.UNKNOWN_EVENT);
							trace(json.event + " " + jsonString);
							break;
					}
				}

				// ツイート削除
				else if (json.hasOwnProperty("delete"))
				{
					var deletedId:String = json["delete"]["status"]["id_str"];

					if (TweetUtil.storedTweets.hasOwnProperty(deletedId))
					{
						targetTweet = TweetUtil.storedTweets[deletedId];
					}
					else
					{
						targetTweet = TweetUtil.parseTweet(json["delete"]["status"]);
					}

					if (targetTweet)
					{
						targetTweet.deleted = true;
					}

					event = new TwitterStreamEvent(TwitterStreamEvent.RECEIVE);
					streamItem = new StreamItem(StreamItemType.DELETE);
						//trace(deletedId + " が削除されました");
				}

				// ツイート
				else if (json.hasOwnProperty("user"))
				{
					if (json.user.hasOwnProperty("screen_name"))
					{
						tweet = TweetUtil.parseTweet(json);

						if (!tweet)
							return;

						event = new TwitterStreamEvent(TwitterStreamEvent.RECEIVE);
						streamItem = new StreamItem(StreamItemType.TWEET);
					}
				}
				else if (json.hasOwnProperty("friends"))
				{

				}
				else
				{
					//trace(jsonString);
				}

				if (event && streamItem)
				{
					event.streamItem = streamItem;

					streamItem.sourceUser = sourceUser;
					streamItem.targetUser = targetUser;
					streamItem.targetTweet = targetTweet;
					streamItem.targetList = targetList;
					streamItem.tweet = tweet;
					streamItem.json = json;
					dispatchEvent(event);
				}
			}
			catch (error:Error)
			{
				/*
				var errorEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
				errorEvent.text = error.message;
				dispatchEvent(errorEvent);
				*/
			}

		}

		/**
		 * ストリームに流れてきた文字列を解析
		 */
		private function parseText(text:String):void
		{

			var result:Object;
			var jsonString:String;

			if (textPart != null)
			{
				if (text.match(/^[^\r\n]+$/))
				{
					textPart += text;
					return;
				}

				result = text.match(/^(.+\})[\r\n]/);

				if (result)
				{
					jsonString = textPart + result[1];
					text = text.substr(String(result[0]).length);
					parseJSON(jsonString);
				}
				textPart = null;
			}


			result = text.match(/\n(\{.+\})[\r\n$]/);

			if (result)
			{
				jsonString = result[1];
				textPart = null;
				parseJSON(jsonString);
				return;
			}

			result = text.match(/^(\{.+\})[\r\n$]/);

			if (result)
			{
				jsonString = result[1];

				textPart = null;
				parseJSON(jsonString);
				return;
			}

			result = text.match(/\n(\{.+)/);

			if (result)
			{
				textPart = result[1];
				return;
			}

			result = text.match(/^(\{.+)/);

			if (result)
			{
				textPart = result[1];
				return;
			}

		}
	}
}
