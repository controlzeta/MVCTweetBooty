using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TweetSharp;

namespace MVCTweetBooty.Models
{
    public class HomeModels
    {
        public string _consumerKey = "";
        public string _consumerSecret = "";
        public string _accessToken = "";
        public string _accessTokenSecret = "";

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

        public void Connect()
        {
            service = new TwitterService(_consumerKey, _consumerSecret);
            service.AuthenticateWith(_accessToken, _accessTokenSecret);
        }
    }
}