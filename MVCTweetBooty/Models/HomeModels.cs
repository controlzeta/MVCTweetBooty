using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using TweetSharp;

namespace MVCTweetBooty.Models
{
    public class HomeModels
    {
        string _consumerKey = "";
        string _consumerSecret = "";
        string _accessToken = "";
        string _accessTokenSecret = "";

        public TwitterService service;  
        public static string[] fileEntries;
        public string fullPath;
        public string tweetedPath;

        System.Timers.Timer FifteenMinuteTimer = new System.Timers.Timer();
        System.Timers.Timer OneHourTimer = new System.Timers.Timer();

        public int TweetsByTheHour = 0;
        public int RTsByTheHour = 0;
        public int FavsByTheHour = 0;
        public int FollowsByTheHour = 0;
        public int FifteenMinutes = 0;
        public int Hours = 0;
        public int minutesLeft = 0;
        public int secondsLeft = 0;
        Random rand = new Random();

        public List<TwitterHashTag> hashtags = new List<TwitterHashTag>();
        public List<TwitterHashTag> hashtagsDistintos = new List<TwitterHashTag>();
        public List<TwitterUser> friendList = new List<TwitterUser>();

        public TwitterSearchResult results = new TwitterSearchResult();
        public string Statuses = "";

        public HomeModels()
        {
            Connect();
            Search("GreatAss pic");
        }

        public void Connect()
        {
            service = new TwitterService(_consumerKey, _consumerSecret);
            service.AuthenticateWith(_accessToken, _accessTokenSecret);
        }

        public void Init()
        {
            
        }

        public void RateLimit(TwitterRateLimitStatus rate)
        {
            string rateLimit = "You have used " + rate.RemainingHits + " out of your " + rate.HourlyLimit;
            rateLimit += "You have to wait: " + rate.ResetTimeInSeconds / 60 + " minutes or to " + rate.ResetTime.ToLongTimeString();
        }

        private TwitterSearchResult Search(string query)
        {
            SearchOptions search = new SearchOptions();
            results = new TwitterSearchResult();
            search.Q = query;
            search.Count = 50;
            search.IncludeEntities = true;
            search.Resulttype = TwitterSearchResultType.Mixed;
            results = service.Search(search);
            RateLimit(service.Response.RateLimitStatus);
            return results;
        }

        public List<TwitterStatus> GetBestTweets()
        {
            List<TwitterStatus> statuses = new List<TwitterStatus>();
            TwitterSearchResult tweets = Search("putas pic");
            if (tweets != null)
            {
                statuses = (from x in tweets.Statuses
                            orderby x.RetweetCount
                            select x).ToList();
            }
            return statuses;
        }
    }
}