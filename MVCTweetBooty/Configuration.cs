//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MVCTweetBooty
{
    using System;
    using System.Collections.Generic;
    
    public partial class Configuration
    {
        public int id { get; set; }
        public string ConsumerKey { get; set; }
        public string ConsumerSecret { get; set; }
        public string AccessToken { get; set; }
        public string AccessTokenSecret { get; set; }
        public int Minutes { get; set; }
        public int RTCount { get; set; }
        public int TweetLimit { get; set; }
        public int FavLimit { get; set; }
        public int FollowLimit { get; set; }
        public int TweetCounter { get; set; }
        public int FavCounter { get; set; }
        public int FollowCounter { get; set; }
    }
}
