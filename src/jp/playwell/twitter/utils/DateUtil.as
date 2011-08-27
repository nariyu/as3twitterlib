////////////////////////////////////////////////////////////////////////////////
//
//    PLAYWELL INC  
//    Copyright 2011 
//    All rights reserved. 
//
////////////////////////////////////////////////////////////////////////////////

package jp.playwell.twitter.utils
{
	/**
	 *
	 * @author nariyu
	 */
	public class DateUtil
	{


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
		 * @return
		 */
		public static function parseDateString(str:String):Date
		{

			if (!str)
				return null;

			var weeks:String = "Sun|Mon|Tue|Wed|Thu|Fri|Sat";
			var monthes:String = "Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec";

			var date:Date;

			// Sun Oct 04 09:04:20 +0000 2009
			var regexp:RegExp = new RegExp("^(" + weeks + ") (" + monthes + ")" + " (\\d+) (\\d+):(\\d+):(\\d+) ([+-]?\\d+) (\\d+)$");
			var result:Object = str.match(regexp);

			if (result)
			{
				weeks.split("|").indexOf(result[1]);
				var m:int = monthes.split("|").indexOf(result[2]);
				var d:int = Number(result[3]);
				var y:int = Number(result[8]);
				date = new Date;
				date.setUTCFullYear(y, m, d);
				date.setUTCHours(Number(result[4]), Number(result[5]),
					Number(result[6]));
				return date;
			}

			// Sun, 04 Oct 2009 13:16:48 +0000
			regexp = new RegExp("^(" + weeks + "), (\\d+) (" + monthes + ")" + " (\\d+) (\\d+):(\\d+):(\\d+) ([+-]?\\d+)$");
			result = str.match(regexp);

			if (result)
			{
				weeks.split("|").indexOf(result[1]);
				m = monthes.split("|").indexOf(result[3]);
				d = Number(result[2]);
				y = Number(result[4]);
				date = new Date;
				date.setUTCFullYear(y, m, d);
				date.setUTCHours(Number(result[5]), Number(result[6]),
					Number(result[7]));

				return date;
			}

			// 2009-10-31T01:45:59+00:00
			regexp = new RegExp("^(\d{4})-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)([+-])(\d\d):(\d\d)$");
			result = str.match(regexp);

			if (result)
			{
				y = Number(result[1]);
				m = Number(result[2]) - 1;
				d = Number(result[3]);
				date = new Date;
				date.setUTCFullYear(y, m, d);
				date.setUTCHours(Number(result[4]), Number(result[5]),
					Number(result[6]));
				return date;
			}

			return null;

		}

		/**
		 *
		 * @param date
		 * @return
		 */
		public static function toString(date:Date):String
		{

			if (!date)
				return "";
			//return date.toDateString();
			return date.getFullYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate();

		}
	}
}
