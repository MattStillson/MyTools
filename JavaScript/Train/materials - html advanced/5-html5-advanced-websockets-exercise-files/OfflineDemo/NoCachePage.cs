using System;
using System.Web;

namespace OfflineDemo
{
    public class NoCachePage : System.Web.UI.Page
    {
        public NoCachePage() {
            this.Init += new EventHandler(NoCachePage_Init);
        }

        void NoCachePage_Init(object sender, EventArgs e)
        {
            this.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        }
    }
}