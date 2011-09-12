package jp.playwell.twitter.utils
{
	import flash.external.ExternalInterface;

	public class OAuthUtil
	{
		static public function getURL():String
		{
			if (!ExternalInterface.available)
			{
				throw new Error("ExternalInterface unavailable");
			}
			return ExternalInterface.call("window.location.href.toString");
		}
	}
}