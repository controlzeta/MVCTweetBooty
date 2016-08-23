using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.WebPages.Html;
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
        public string query = "";

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
        public List<TwitterTrend> TrendList = new List<TwitterTrend>();
        public int CountryId { get; set; }
        public List<SelectListItem> Countries { get; set; }


        public TwitterSearchResult results = new TwitterSearchResult();
        public string Statuses = "";

        public string rateLimit = "";

        public HomeModels()
        {
            Connect();
            //Search("Nalgapronta");
        }

        public void Connect()
        {
            service = new TwitterService(_consumerKey, _consumerSecret);
            service.AuthenticateWith(_accessToken, _accessTokenSecret);
        }

        public void Init()
        {
            //Connect();
            GetCountries();
            GetTrendingTopicsById(0);
        }

        public void RateLimit(TwitterRateLimitStatus rate)
        {
            rateLimit = "You have used " + rate.RemainingHits + " out of your " + rate.HourlyLimit;
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

        public void GetCountries()
        {
            var countries = service.ListAvailableTrendsLocations();
            Countries = new List<SelectListItem>();
            foreach (WhereOnEarthLocation country in countries)
            {
                SelectListItem SLI = new SelectListItem();
                SLI.Text = country.Country + " - " + country.Name;
                SLI.Value = country.WoeId.ToString();
                Countries.Add(SLI);
            }
        }

        public void GetTrendingTopicsById(int id)
        {
            ListLocalTrendsForOptions lctfo = new ListLocalTrendsForOptions();
            lctfo.Id = id == 0 ? 116545 : id; //Mexico City
            //lctfo.Id = 116545; //Mexico City
            //lctfo.Id = 134047; //Monterrey
            //lctfo.Id = 395269; //Caracas
            //lctfo.Id = 753692; //Barcelona
            //lctfo.Id = 766273; //Madrid
            var Trends = service.ListLocalTrendsFor(lctfo);
            TrendList = Trends.Trends;
        }
    }
}