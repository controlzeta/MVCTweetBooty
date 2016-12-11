using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MVCTweetBooty.Objects
{
    public class Actions
    {
        public int id { get; set; }
        public string action { get; set; }
        public string link { get; set; }
        public string userName { get; set; }
        public DateTime date { get; set; }
        public bool success { get; set; }
        public string dialog { get; set; }
    }
}