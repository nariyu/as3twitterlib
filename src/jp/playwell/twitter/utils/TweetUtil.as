////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.utils
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import jp.playwell.twitter.core.twitter_internal;
	import jp.playwell.twitter.data.CoreData;
	import jp.playwell.twitter.data.Tweet;
	import jp.playwell.twitter.data.User;

	use namespace twitter_internal;
	/**
	 *
	 * @author nariyu
	 */
	public class TweetUtil
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
		twitter_internal static var storedTweets:Dictionary = new Dictionary;


		//----------------------------------------------------------
		//
		//
		//   Static methods 
		//
		//
		//----------------------------------------------------------

		/**
		 *
		 * @param str
		 * @param convertHTML
		 * @param linkColor
		 * @return
		 */
		public static function convertText(str:String,
			convertHTML:Boolean = true, linkColor:Boolean = true):String
		{

			if (convertHTML)
			{
				str = str.replace(/(^|\s|[\r\n]|[あ-んが-ぼぁ-ょゎっーア-ンガ-ボヴァ-ョヮッーｱ-ﾝｧ-ｮｯｰﾟﾞ･ａ-ｚＡ-Ｚ０-９亜-龠、。，．・：；？！゛゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼〜～∥｜…‥‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰♯♭♪†‡¶◯ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψωАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡㍻〝〟№㏍℡㊤㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼≒≡∫∮∑√⊥∠∟⊿∵∩∪\{\}\[\]\(\)\<\>\!\@\#\$\%\^\&\*\-\_\+\=\~\`\:\;\'\"\,\.\/])(https?:\/\/[-_.a-zA-Z0-9;\/?:@&=+$,!~*\(\)%#]+|[#＃][-_a-zA-Z0-9_.あ-んが-ぼぁ-ょゎっーア-ンガ-ボヴァ-ョヮッーｱ-ﾝｧ-ｮｯｰﾟﾞ･ａ-ｚＡ-Ｚ０-９亜-龠ヶヵ々]+|#[-_a-zA-Z0-9_.]+|[-a-zA-Z0-9+_.]*[-a-zA-Z0-9+_]@[-a-zA-Z0-9.]+|@[a-zA-Z0-9_]+)/g,
					"$1<a href='event:$2' target='_blank'>" + (linkColor ? "<font color='#003399'>" : "<u>") + "$2" + (linkColor ? "</font>" : "</u>") + "</a>");
				str = str.replace(/\r\n|[\r\n]/g, "<br>");
			}
			else
			{
				str = str.replace(/\r\n|\r/g, "\n");
			}
			return str;

		}

		/**
		 *
		 * @param tweet
		 * @return
		 */
		public static function convertTextByEntities(tweet:Tweet):String
		{

			var text:String = tweet.text;
			var entities:Object = tweet.entities;

			if (!entities)
				return convertText(text);

			var convertItems:Array = [];
			var i:int;

			if (entities.hasOwnProperty("urls"))
			{
				var urls:Array = entities.urls || [];

				for (i = 0; i < urls.length; i++)
				{
					var url:Object = urls[i];
					convertItems.push([url.indices[0], url.indices[1], url.url,
						url.expanded_url]);
				}
			}

			if (entities.hasOwnProperty("user_mentions"))
			{
				var mentions:Array = entities.user_mentions || [];

				for (i = 0; i < mentions.length; i++)
				{
					var mention:Object = mentions[i];
					convertItems.push([mention.indices[0], mention.indices[1],
						mention.screen_name, "@" + mention.screen_name]);
				}
			}

			if (entities.hasOwnProperty("hashtags"))
			{
				var hashtags:Array = entities.hashtags || [];

				for (i = 0; i < hashtags.length; i++)
				{
					var hashtag:Object = hashtags[i];
					convertItems.push([hashtag.indices[0], hashtag.indices[1],
						hashtag.text, "#" + hashtag.text]);
				}
			}

			convertItems.sort(function(a:Array, b:Array):int
			{

				if (a[0] > b[0])
					return 1;

				if (a[0] < b[0])
					return -1;
				return 0;
			});

			var item:Array;
			var link:String;

			for (i = convertItems.length - 1; i >= 0; i--)
			{
				item = convertItems[i] as Array;
				link = item[3];

				if (link == null)
					link = item[2];
				text = text.substr(0, item[0]) + "<a href='event:" + link + "'><font color='#003399'>" + link + "</font></a>" + text.substr(item[1]);
			}
			text = text.replace(/\r\n|[\r\n]/g, "<br>");

			return text;

		}

		/**
		 *
		 * @param statuses
		 * @return
		 */
		public static function convertToRawStatuses(statuses:Array):Array
		{

			var rawTweets:Array = [];

			if (statuses is Array)
			{
				var n:int = statuses.length;
				var rawTweet:Object;

				for (var i:int = 0; i < n; i++)
				{
					rawTweet = Tweet(statuses[i]).toObject();
					rawTweets.push(rawTweet);
				}
			}
			return rawTweets;

		}

		/**
		 *
		 * @param rawStatuses
		 * @return
		 */
		public static function convertToStatuses(rawTweets:Array):Array
		{

			var tweets:Array = [];

			if (rawTweets is Array)
			{
				var n:int = rawTweets.length;
				var tweet:Tweet;

				for (var i:int = 0; i < n; i++)
				{
					try
					{
						tweet = parseTweet(rawTweets[i]);
						tweets.push(tweet);
					}
					catch (e:Error)
					{
						//logger.error(e.message);
					}
				}
			}
			return tweets;

		}

		/**
		 *
		 * @param str
		 * @param prefixScreenNames
		 * @return
		 */
		public static function extructScreenNames(str:String,
			prefixScreenNames:Array = null):Array
		{

			var html:String = convertText(str);
			var resultset:Array = html.match(/<a href='event:([^']+)' target/g);

			if (!prefixScreenNames)
			{
				prefixScreenNames = [];
			}
			var screenNames:Array = prefixScreenNames;

			if (resultset)
			{
				var matches:Array;
				var link:String;
				var screenName:String;

				for each (str in resultset)
				{
					matches = str.match(/<a href='event:([^']+)' target/);

					if (matches)
					{
						link = matches[1];

						if (link.substr(0, 1) == "@")
						{
							screenName = link.substr(1);

							if (screenNames.indexOf(screenName) == -1)
							{
								screenNames.push(screenName);
							}
						}
					}
				}
			}

			return screenNames;

		}

		/**
		 *
		 * @param str
		 * @return
		 */
		public static function extructURLs(str:String):Array
		{

			var html:String = convertText(str);
			var resultset:Array = html.match(/<a href='event:([^']+)' target/g);
			var urls:Array = [];

			if (resultset)
			{
				var matches:Array;

				for each (var str:String in resultset)
				{
					matches = str.match(/<a href='event:([^']+)' target/);

					if (matches && String(matches[1]).match(/^http/) && urls.indexOf(matches[1]) == -1)
					{
						urls.push(matches[1]);
					}
				}
			}
			return urls;

		}

		/**
		 *
		 * @param obj
		 * @return
		 */
		public static function parseTweet(obj:Object):Tweet
		{

			var id:String = obj.id_str as String;

			var tweet:Tweet;

			if (storedTweets.hasOwnProperty(id))
			{
				tweet = storedTweets[id];
			}
			else
			{
				tweet = new Tweet;
				tweet.id = id;
			}

			tweet.rawObject = obj;

			if (obj.hasOwnProperty("text"))
			{
				tweet.text = String(obj.text).replace(/\r\n|[\r\n]/g, "\n");
			}

			if (obj.hasOwnProperty("created_at"))
			{
				tweet.createdDate = DateUtil.parseDateString(obj.created_at);
			}


			if (obj.hasOwnProperty("in_reply_to_status_id_str"))
			{
				tweet.inReplyToStatusId = obj.in_reply_to_status_id_str;
			}

			if (obj.hasOwnProperty("source"))
			{
				tweet.source = CoreData.decode(obj.source);
			}

			if (obj.hasOwnProperty("geo") && obj.geo)
			{
				var geo:Object = obj.geo;

				if (geo.hasOwnProperty("type") && geo.type == "Point")
				{
					if (geo.hasOwnProperty("coordinates") && geo.coordinates is Array)
					{
						var coodinates:Array = geo.coordinates as Array;
						tweet.latLng = new Point(coodinates[0] as Number,
							coodinates[1] as Number);
					}
				}
			}

			tweet.entities = obj.entities;

			var key:String;

			if (obj.hasOwnProperty("user")) // normal tweet
			{
				key = "user";
			}
			else if (obj.hasOwnProperty("sender")) // messages
			{
				key = "sender";
				tweet.isMessage = true;
			}
			else if (obj.hasOwnProperty("from_user")) // search API
				key = "from_user";

			if (key)
			{
				var user:User;
				var latestUser:User;

				if (key == "from_user")
				{
					user = UserUtil.parseUser(obj);
					user.id = obj.from_user_id;
					user.screenName = obj.from_user;
				}
				else if (obj[key])
				{
					user = UserUtil.parseUser(obj[key]);
				}

				tweet.user = user;

				if (obj.hasOwnProperty("recipient") && obj.recipient)
				{
					user = UserUtil.parseUser(obj.recipient);
					tweet.recipient = user;
				}
			}
			else
			{
				//return null;
			}

			// if Retweet
			if (obj.hasOwnProperty("retweeted_status"))
			{
				tweet.retweetOf = TweetUtil.parseTweet(obj.retweeted_status);
			}

			storedTweets[id] = tweet;

			return tweet;

		}

		/**
		 *
		 * @param screenName
		 * @param text
		 * @return
		 */
		public static function screenNameContains(screenName:String,
			text:String):Boolean
		{

			var target:String = screenName.toLowerCase();
			var screenNames:Array = extructScreenNames(text);

			for (var i:int = 0; i < screenNames.length; i++)
			{
				var element:String = screenNames[i] as String;

				if (element != null && element.toLowerCase() == target)
				{
					return true;
				}
			}
			return false;

		}
	}
}
