using MVCTweetBooty.Models;
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
