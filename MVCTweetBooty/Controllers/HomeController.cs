using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MVCTweetBooty.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index(MVCTweetBooty.Models.HomeModels m)
        {
            ViewBag.Message = "Modify this template to jump-start your ASP.NET MVC application.";
            m.Connect();
            return View();
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
