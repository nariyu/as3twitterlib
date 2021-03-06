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
	import jp.playwell.twitter.data.Status;
	import jp.playwell.twitter.data.User;

	use namespace twitter_internal;
	/**
	 *
	 * @author nariyu
	 */
	public class StatusUtil
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
		twitter_internal static var storedStatuses:Dictionary = new Dictionary;


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
				str = str.replace(/(^|\s|[\r\n]|[あ-んが-ぼぁ-ょゎっーア-ンガ-ボヴァ-ョヮッーｱ-ﾝｧ-ｮｯｰﾟﾞ･ａ-ｚＡ-Ｚ０-９亜-龠、。，．・：；？！゛゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼〜～∥｜…‥‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰♯♭♪†‡¶◯ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψωАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡㍻〝〟№㏍℡㊤㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼≒≡∫∮∑√⊥∠∟⊿∵∩∪\{\}\[\]\(\)\<\>\!\@\#\$\%\^\&\*\-\_\+\=\~\`\:\;\'\"\,\.\/])(https?:\/\/[-_.a-zA-Z0-9;\/?:@&=+$,!~*\(\)%#]+|[#＃][-_a-zA-Z0-9_.あ-んが-ぼぁ-ょゎっーア-ンガ-ボヴァ-ョヮッーｱ-ﾝｧ-ｮｯｰﾟﾞ･ａ-ｚＡ-Ｚ０-９亜-龠ヶヵ々]+|[-a-zA-Z0-9+_.]*[-a-zA-Z0-9+_]@[-a-zA-Z0-9.]+|@[a-zA-Z0-9_]+)/g,
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
		public static function convertTextByEntities(status:Status):String
		{

			var text:String = status.text;
			var entities:Object = status.entities;

			if (!entities)
				return convertText(text);

			var convertItems:Array = [];
			var i:int;

			if (entities.hasOwnProperty("media"))
			{
				var media:Array = entities.media || [];

				for (i = 0; i < media.length; i++)
				{
					var med:Object = media[i];
					convertItems.push([med.indices[0], med.indices[1], med.url,
						"http://" + med.display_url]);
				}
			}

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

			var rawStatuses:Array = [];

			if (statuses is Array)
			{
				var n:int = statuses.length;
				var rawStatus:Object;

				for (var i:int = 0; i < n; i++)
				{
					rawStatus = Status(statuses[i]).toObject();
					rawStatuses.push(rawStatus);
				}
			}
			return rawStatuses;

		}

		/**
		 *
		 * @param rawStatuses
		 * @return
		 */
		public static function convertToStatuses(rawStatuses:Array):Array
		{

			var statuses:Array = [];

			if (rawStatuses is Array)
			{
				var n:int = rawStatuses.length;
				var status:Status;

				for (var i:int = 0; i < n; i++)
				{
					try
					{
						status = parseStatus(rawStatuses[i]);
						statuses.push(statuses);
					}
					catch (e:Error)
					{
						//logger.error(e.message);
					}
				}
			}
			return statuses;

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
		public static function parseStatus(obj:Object):Status
		{

			var id:String = obj.id_str as String;

			var status:Status;

			if (storedStatuses.hasOwnProperty(id))
			{
				status = storedStatuses[id];
			}
			else
			{
				status = new Status;
				status.id = id;
			}

			var searchFlag:Boolean = obj.hasOwnProperty("from_user");

			if (!searchFlag || !status.rawObject)
			{
				status.rawObject = obj;
			}

			if (obj.hasOwnProperty("text") && (!searchFlag || status.text == null))
			{
				status.text = String(obj.text).replace(/\r\n|[\r\n]/g, "\n");
			}

			if (obj.hasOwnProperty("created_at"))
			{
				status.createdDate = DateUtil.parseDateString(obj.created_at);
			}


			if (obj.hasOwnProperty("in_reply_to_status_id_str"))
			{
				status.inReplyToStatusId = obj.in_reply_to_status_id_str;
			}

			if (obj.hasOwnProperty("source"))
			{
				status.source = CoreData.decode(obj.source);
			}

			if (obj.hasOwnProperty("geo") && obj.geo)
			{
				var geo:Object = obj.geo;

				if (geo.hasOwnProperty("type") && geo.type == "Point")
				{
					if (geo.hasOwnProperty("coordinates") && geo.coordinates is Array)
					{
						var coodinates:Array = geo.coordinates as Array;
						status.latLng = new Point(coodinates[0] as Number,
							coodinates[1] as Number);
					}
				}
			}

			if (obj.hasOwnProperty("entities"))
			{
				status.entities = obj.entities;
			}

			var key:String;

			if (obj.hasOwnProperty("user")) // normal tweet
			{
				key = "user";
			}
			else if (obj.hasOwnProperty("sender")) // messages
			{
				key = "sender";
				status.isMessage = true;
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
					user.id = obj.from_user_id_str;
					user.screenName = obj.from_user;
				}
				else if (obj[key])
				{
					user = UserUtil.parseUser(obj[key]);
				}

				status.user = user;

				if (obj.hasOwnProperty("recipient") && obj.recipient)
				{
					user = UserUtil.parseUser(obj.recipient);
					status.recipient = user;
				}
			}
			else
			{
				//return null;
			}

			// if Retweet
			if (obj.hasOwnProperty("retweeted_status"))
			{
				status.retweetOf = StatusUtil.parseStatus(obj.retweeted_status);
			}

			storedStatuses[id] = status;

			return status;

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
