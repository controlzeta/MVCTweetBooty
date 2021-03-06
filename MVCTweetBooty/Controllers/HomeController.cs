﻿using MVCTweetBooty.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace MVCTweetBooty.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index(MVCTweetBooty.Models.HomeModels m)
        {
            m.Init();
            return View(m);
        }

        [HttpPost]
        public ActionResult GetFooString()
        {
            HomeModels m = new HomeModels();
            m.Init();
            return Json(m);
        } // end GetFooString

        [HttpPost]
        public JsonResult GetHashtagByCountry(int id)
        {
            HomeModels m = new HomeModels();
            m.GetTrendingTopicsById(id);
            return Json(m.TrendList);
        }

        [HttpPost]
        public JsonResult Timer(int id)
        {
            HomeModels m = new HomeModels();
            m.FifteenMinuteEvent();
            m.RandomTime();
            return Json(m.secondsLeft);
        }

        [HttpPost]
        public JsonResult OldTweets(int howMany)
        {
            HomeModels m = new HomeModels();
            m.getOldTweets();
            return Json(m.OldTweets);
        }

        [HttpPost]
        public JsonResult SearchTweets(string query, string numberOfResults, string resultsType)
        {
            HomeModels m = new HomeModels();
            m.SearchTweets(query, numberOfResults, resultsType);
            return new JsonResult()
            {
                Data = m.results,
                MaxJsonLength = 86753090
            };
        }

        [HttpPost]
        public JsonResult Tweet(string tweetText)
        {
            HomeModels m = new HomeModels();
            m.SendTweet(tweetText);
            return new JsonResult()
            {
                Data = m,
                MaxJsonLength = 86753090
            };
        }

        [HttpPost]
        public JsonResult ReTweetSomething()
        {
            HomeModels m = new HomeModels();
            m.ReTweetSomething();
            return new JsonResult()
            {
                Data = m,
                MaxJsonLength = 86753090
            };
        }

        [HttpPost]
        public JsonResult FavoriteSomething()
        {
            HomeModels m = new HomeModels();
            m.FavoriteSomething();
            return new JsonResult()
            {
                Data = m,
                MaxJsonLength = 86753090
            };
        }

        [HttpPost]
        public JsonResult GetMentions()
        {
            HomeModels m = new HomeModels();
            m.GetMentions();
            return new JsonResult()
            {
                Data = m,
                MaxJsonLength = 86753090
            };
        }

        [HttpPost]
        public JsonResult GetSearchTerms()
        {
            HomeModels m = new HomeModels();
            return new JsonResult()
            {
                Data = m.GetSearchTerms(),
                MaxJsonLength = 86753090
            };
        }

        [HttpPost]
        public JsonResult RetweetTerm(string term)
        {
            HomeModels m = new HomeModels();
            m.RetweetTerm(term);
            return new JsonResult()
            {
                Data = m,
                MaxJsonLength = 86753090
            };
        }

        [HttpPost]
        public JsonResult FavTerm(string term)
        {
            HomeModels m = new HomeModels();
            m.FavoriteTerm(term);
            return new JsonResult()
            {
                Data = m,
                MaxJsonLength = 86753090
            };
        }

        [HttpPost]
        public JsonResult InsertTerm(string term)
        {
            HomeModels m = new HomeModels();
            m.InsertTerm(term);
            return new JsonResult()
            {
                Data = m,
                MaxJsonLength = 86753090
            };
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your app description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}
