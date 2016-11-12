using log4net;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using TweetSharp;

namespace MVCTweetBooty.Models
{
    public class HomeModels
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(HomeModels).FullName);

        string _consumerKey = "";
        string _consumerSecret = "";
        string _accessToken = "";
        string _accessTokenSecret = "";

        static string[] fileEntries;
        string fullPath;
        string tweetedPath;
        public string query = "";
        public string TweetText = "";
        public string Errors = "";

        System.Timers.Timer FifteenMinuteTimer = new System.Timers.Timer();
        System.Timers.Timer OneHourTimer = new System.Timers.Timer();

        public int TweetsByTheHour = 0;
        public int RTsByTheHour = 0;
        public int FavsByTheHour = 0;
        public int FollowsByTheHour = 0;
        public int FifteenMinutes = 0;
        public int FavCounter = 0;
        public int TweetCounter = 0;
        public int FollowCounter = 0;
        public int NumFotos = 0;
        public int Hours = 0;
        public int minutesLeft = 0;
        public int secondsLeft = 0;
        Random rand = new Random();

        public List<TwitterHashTag> hashtags = new List<TwitterHashTag>();
        public List<TwitterHashTag> hashtagsDistintos = new List<TwitterHashTag>();
        public List<TwitterUser> friendList = new List<TwitterUser>();
        public List<TwitterTrend> TrendList = new List<TwitterTrend>();
        public List<Tweeted> OldTweets = new List<Tweeted>();
        public int CountryId { get; set; }
        public List<SelectListItem> Countries { get; set; }
        public List<SelectListItem> ResultsNumber { get; set; }
        public int idResultNumber { get; set; }
        public List<SelectListItem> TypeOfResults { get; set; }
        public int idTypeOfResults;

        public TwitterSearchResult results = new TwitterSearchResult();
        public string Statuses = "";

        public string rateLimit = "";

        public HomeModels()
        {
            Connect();
            ScanForMedia();
        }

        public void Connect()
        {
            MvcApplication.service = new TwitterService(_consumerKey, _consumerSecret);
            MvcApplication.service.AuthenticateWith(_accessToken, _accessTokenSecret);
        }

        public void Init()
        {
            //Connect();
            GetCountries();
            GetTrendingTopicsById(0);
            InitializeSelects();
            RateLimit(MvcApplication.service.Response.RateLimitStatus);
            RandomTime();
            //GetBestTweets();
        }

        public void InitializeSelects()
        {
            ResultsNumber = new List<SelectListItem>();
            SelectListItem a = new SelectListItem();
            for (int i = 1; i < 10; i++)
            {
                a = new SelectListItem();
                a.Text = (i * 10).ToString(); a.Value = (i * 10).ToString();
                ResultsNumber.Add(a);
            }
            for (int i = 1; i < 10; i++)
            {
                a = new SelectListItem();
                if (i == 1)
                    a.Selected = true;
                a.Text = (i * 100).ToString(); a.Value = (i * 100).ToString();
                ResultsNumber.Add(a);
            }
            TypeOfResults = new List<SelectListItem>();
            a = new SelectListItem();
            a.Text = "Mixed"; a.Value = "0"; TypeOfResults.Add(a);
            a = new SelectListItem();
            a.Text = "Recent"; a.Value = "1"; TypeOfResults.Add(a);
            a = new SelectListItem();
            a.Text = "Popular"; a.Value = "2"; TypeOfResults.Add(a);
        }

        public void RateLimit(TwitterRateLimitStatus rate)
        {
            rateLimit = "You have used " + rate.RemainingHits + " out of your " + rate.HourlyLimit + " \n";
            rateLimit += "You have to wait: " + rate.ResetTimeInSeconds / 60 + " minutes or to " + rate.ResetTime.ToLongTimeString();
        }

        public void FifteenMinuteEvent()
        {
            try
            {
                // Create Random number 
                int times = rand.Next(1, 5);
                bool AlreadyRecommended = false;
                while (times > 0)
                {
                    int action = rand.Next(1, 6);
                    switch (action)
                    {
                        case 1: //Tweet
                            string nuevoStatus = ConstructTweet(85);
                            SendTweet(nuevoStatus);
                            break;
                        case 2: //Fav
                            var statuses = GetBestTweets();
                            if (statuses.Count > 0)
                            {
                                FavTweet(statuses.ElementAt(0).Id, statuses.ElementAt(0).Text);
                            }
                            break;
                        case 3: //RT
                            var statuses2 = GetBestTweets();
                            if (statuses2.Count > 0)
                            {
                                RTTweet(statuses2.ElementAt(0).Id, statuses2.ElementAt(0).Text);
                            }
                            break;
                        case 4: //RT & FAV
                            var statuses3 = GetBestTweets();
                            if (statuses3.Count > 0)
                            {
                                FavTweet(statuses3.ElementAt(0).Id, statuses3.ElementAt(0).Text);
                                RTTweet(statuses3.ElementAt(0).Id, statuses3.ElementAt(0).Text);
                            }
                            break;
                        //case 5: //Recommend
                        //    if (!AlreadyRecommended)
                        //    {
                        //        Recommended();
                        //        AlreadyRecommended = true;
                        //    }
                        //    break;
                    }
                    times--;
                }
                RandomTime();
            }
            catch (Exception ex)
            {
                log.Error("No se pudo inicializar el proceso de Timer: " , ex);
            }
        }

        private TwitterSearchResult Search(string query, int numberOfResults, int resultType)
        {
            SearchOptions search = new SearchOptions();
            results = new TwitterSearchResult();
            search.Q = query;
            search.Count = numberOfResults != 0 ? numberOfResults : 50;
            search.IncludeEntities = true;
            search.Resulttype = ResulTypeOf(resultType);
            results = MvcApplication.service.Search(search);
            addLinks(results);
            RateLimit(MvcApplication.service.Response.RateLimitStatus);
            return results;
        }

        private TwitterSearchResult addLinks(TwitterSearchResult results)
        { 
            foreach(TwitterStatus status in results.Statuses)
            {
                string url = "https://twitter.com/";
                //status.Author.ScreenName = "<a href='" + url + status.Author.ScreenName + "' target='_blank'>@" + status.Author.ScreenName + "</a>";
            }
            return results;
        }

        public TwitterSearchResultType ResulTypeOf(int type)
        { 
            switch(type)
            { 
                case 0:
                    return TwitterSearchResultType.Mixed;
                case 1:
                    return TwitterSearchResultType.Popular;
                case 2:
                    return TwitterSearchResultType.Recent;
                default:
                    return TwitterSearchResultType.Mixed;
            }
        }

        public List<TwitterStatus> GetBestTweets()
        {
            List<TwitterStatus> statuses = new List<TwitterStatus>();
            TwitterSearchResult tweets = Search(GetSearchTerm(), 0, 0);
            if (tweets != null)
            {
                statuses = (from x in tweets.Statuses
                            orderby x.RetweetCount descending
                            select x).ToList();

            }
            return statuses;
        }

        public string GetSearchTerm()
        {
            using (TweetBotDBEntities bd = new TweetBotDBEntities())
            {
                Random rnd = new Random();
                List<SearchTerm> lsST =  (from li in bd.SearchTerms
                                select li).ToList();
                return lsST.ElementAt(rnd.Next(0, lsST.Count)).SearchTerm1;
            }
            
        }

        public void GetCountries()
        {
            var countries = MvcApplication.service.ListAvailableTrendsLocations();
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
            var Trends = MvcApplication.service.ListLocalTrendsFor(lctfo);
            TrendList = Trends.Trends;
        }

        public void SearchTweets(string Query, string numberOfResults, string resultType)
        {
            try
            {
                Search(Query, Convert.ToInt32(numberOfResults), Convert.ToInt32(resultType));    
            }
            catch (Exception ex)
            {
                log.Error("No se pudo buscar el query: " + Query, ex);
            }
        }

        public int RandomTime()
        {
            minutesLeft = rand.Next(50, 75);
            secondsLeft = minutesLeft * 60;
            return secondsLeft;
        }

        public string ConstructTweet(int tweetLength)
        {
            Random rnd = new Random();
            string nuevoStatus = "";
            using (TweetBotDBEntities bd = new TweetBotDBEntities())
            {
                int NumLinks = (from li in bd.Links
                                select li).ToList().Count;
                int random = rnd.Next(1, NumLinks);
                Link link = (from l in bd.Links
                             where l.id == random
                             select l).FirstOrDefault();
                nuevoStatus = ShortenedString(link.title, tweetLength);
                int counter = 0;
                while (nuevoStatus.Length <= tweetLength)
                {
                    List<Hashtag> lsthashtags = (from h in bd.Hashtags
                                                 where h.repeated > 80
                                                 select h).ToList();
                    random = rnd.Next(0, lsthashtags.Count);
                    if ((nuevoStatus.Length + lsthashtags.ElementAt(random).hashtag1.Trim().Length + 2) < tweetLength)
                    {
                        nuevoStatus = nuevoStatus + " #" + lsthashtags.ElementAt(random).hashtag1.Trim();
                    }
                    else
                    {
                        counter++;
                    }
                    if (counter == 5)
                    {
                        break;
                    }
                }
                nuevoStatus = ShortenedString(nuevoStatus, tweetLength) + " " + link.link1;
            }
            return nuevoStatus;
        }

        private string ShortenedString(string linea, int medida)
        {
            if (linea.Length <= medida)
            {
                return linea;
            }
            string lineaCorta;
            int cuantos = linea.Length - medida;
            lineaCorta = linea.Remove(medida, cuantos);
            return lineaCorta;
        }

        public bool Tweet(string Status)
        {
            try
            {
                SendTweetOptions tweet = new SendTweetOptions();
                tweet.Status = Status;
                var result = MvcApplication.service.SendTweet(tweet);
                RateLimit(MvcApplication.service.Response.RateLimitStatus);
                if (result != null)
                {
                    SaveAction("Tweet", Status, result.Id, result.User.ScreenName);
                    return true;
                }
                else
                    return false;
            }
            catch (Exception ex)
            {
                log.Error("No se pudo enviar el Tweet", ex);
                return false;
            }
        }

        public void FavTweet(long tweetID, string tweet)
        {
            try
            {
                FavoriteTweetOptions fav = new FavoriteTweetOptions();
                fav.Id = tweetID;
                MvcApplication.service.FavoriteTweet(fav);
                RateLimit(MvcApplication.service.Response.RateLimitStatus);
                int counter = Convert.ToInt32(FavCounter);
                if (MvcApplication.service.Response.StatusDescription == "OK")
                {
                    SaveAction("Favorite", tweet, tweetID, " ");
                    counter++;
                }
                FavCounter = counter;
                //getLog();
            }
            catch (Exception ex)
            {
                log.Error("No se pudo favear el Tweet", ex);
            }
        }

        public void RTTweet(long tweetID, string tweet)
        {
            RetweetOptions rt = new RetweetOptions();
            rt.Id = tweetID;
            MvcApplication.service.Retweet(rt);
            RateLimit(MvcApplication.service.Response.RateLimitStatus);
            int counter = Convert.ToInt32(TweetCounter);
            if (MvcApplication.service.Response.StatusDescription == "OK")
            {
                SaveAction("ReTweet", tweet, tweetID, " ");
                counter++;
            }
            TweetCounter = counter;
            //getLog();
        }

        public void Follow(bool following, string screenName)
        {
            FollowUserOptions follow = new FollowUserOptions();
            follow.Follow = following;
            follow.ScreenName = screenName;
            MvcApplication.service.FollowUser(follow);
            RateLimit(MvcApplication.service.Response.RateLimitStatus);
            int counter = Convert.ToInt32(FollowCounter);
            if (MvcApplication.service.Response.StatusDescription == "OK")
            {
                SaveAction(following ? "Follow" : "Unfollow", " ", 0, screenName);
                counter++;
            }
            FollowCounter = counter;
            //getLog();
        }

        public void Recommended()
        {
            ListFriendsOptions Friends = new ListFriendsOptions();
            Friends.ScreenName = "nalgaprontacom";
            Friends.Count = 500;
            friendList = MvcApplication.service.ListFriends(Friends);
            string status = "#MustFollow : ";
            int contador = 0;
            while (status.Length <= 88 && contador <= 6)
            {
                int index = rand.Next(0, friendList.Count);
                //foreach (TwitterUser t in friendList)
                //{
                if (friendList.ElementAt(index).ScreenName.Length + status.Length <= 87)
                {
                    status += " @" + friendList.ElementAt(index).ScreenName + " ";
                }
                contador++;
                friendList.RemoveAt(index);

                //}
            }
            SendTweet(status);
        }

        public bool SendTweet(string status)
        {
            bool success = false;
            if (fileEntries != null && fileEntries.Length > 0)
            {
                success = TweetWithMedia(status, fileEntries[0]);
                var list = new List<string>(fileEntries);
                list.Remove(fileEntries[0]);
                fileEntries = list.ToArray();
                NumFotos = fileEntries.Length;
            }
            else
            {
                success = Tweet(status);
            }
            if (success)
            {
                int tweetCounter = Convert.ToInt32(TweetCounter);
                tweetCounter++;
                TweetCounter = tweetCounter;
            }
            //getLog();
            return success;
        }

        public bool TweetWithMedia(string status, string mediaPath)
        {
            try
            {
                TwitterStatus result;
                SendTweetWithMediaOptions MediaOp = new SendTweetWithMediaOptions();
                Bitmap img = new Bitmap(mediaPath); //Bitmap img = new Bitmap(@"C:\Users\AngelC\Dropbox\Freelance Ko\TweetBot\logo.jpg");
                using (MemoryStream ms = new MemoryStream())
                {
                    img.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
                    ms.Seek(0, SeekOrigin.Begin);
                    Dictionary<string, Stream> images = new Dictionary<string, Stream> { { "mypicture", ms } };
                    result = MvcApplication.service.SendTweetWithMedia(
                        new SendTweetWithMediaOptions { Status = status, Images = images });
                    ((IDisposable)img).Dispose();
                }
                RateLimit(MvcApplication.service.Response.RateLimitStatus);
                if (result != null)
                {
                    SaveAction("Tweet", status, result.Id, result.User.ScreenName);
                    string copyFilePath = tweetedPath + "\\" + Path.GetFileName(mediaPath);
                    System.IO.File.Move(mediaPath, copyFilePath);
                    return true;
                }
                Errors = MvcApplication.service.Response.StatusDescription + " " + MvcApplication.service.Response.Error;
                return false;
            }
            catch (Exception ex)
            {
                log.Error("No se pudo lanzar el Tweet", ex);
                return false;
            }
        }

        public void GetMentions()
        {
            List<TwitterStatus> mentions = MvcApplication.service.ListTweetsMentioningMe(new ListTweetsMentioningMeOptions()).ToList();
            foreach (TwitterStatus t in mentions)
            {
                //DataGridViewRow row = (DataGridViewRow)dgvMentions.Rows[0].Clone();
                //row.Cells[0].Value = t.Author.ScreenName;                   //UserName
                //row.Cells[1].Value = t.Text;                                //Text
                //row.Cells[2].Value = t.Id.ToString();                         //Id
                //dgvMentions.Rows.Add(row);
            }
            RateLimit(MvcApplication.service.Response.RateLimitStatus);
        }

        public void getOldTweets(int howMany = 50)
        {
            try
            {
                using (TweetBotDBEntities bd = new TweetBotDBEntities())
                {
                    OldTweets = (from o in bd.Tweeteds
                                     orderby o.Id descending
                                 select o).Take(howMany).ToList();
                }
            }
            catch (Exception ex)
            {
                log.Error("No se pudo enviar el Tweet", ex);
            }
        }

        public void SaveAction(string action, string text, long TweetId, string Username)
        {
            try
            {
                using (TweetBotDBEntities bd = new TweetBotDBEntities())
                {
                    Tweeted t = new Tweeted();
                    t.Action = action;
                    t.Text = text;
                    t.Timestamp = DateTime.Now;
                    t.TweetId = TweetId;
                    t.Username = Username;
                    bd.Tweeteds.Add(t);
                    bd.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                log.Error("No se pudo guardar la acción: " + action , ex);
            }
        }

        public static int ProcessDirectory(string targetDirectory)
        {
            // Process the list of files found in the directory.
            fileEntries = Directory.GetFiles(targetDirectory);
            return fileEntries.Length;
        }

        public void ScanForMedia()
        {
            string exeFile = AppDomain.CurrentDomain.GetData("DataDirectory").ToString();
            string exeDir = Path.GetDirectoryName(exeFile);
            //string fullPath = Path.Combine(exeDir, "..\\..\\Images\\");
            fullPath = Path.Combine(exeDir + "\\Images\\");
            tweetedPath = Path.Combine(exeDir + "\\Images\\tweeted");
            if (Directory.Exists(fullPath))
            {
                NumFotos = ProcessDirectory(fullPath);
            }
            if (!System.IO.Directory.Exists(tweetedPath))
            {
                System.IO.Directory.CreateDirectory(tweetedPath);
            }

        }

    }
}