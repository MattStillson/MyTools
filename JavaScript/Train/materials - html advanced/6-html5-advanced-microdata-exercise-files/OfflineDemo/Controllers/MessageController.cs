using System;
using System.Web.Mvc;
using System.Collections.Generic;

namespace OfflineDemo.Controllers
{
    public class JournalMessageInputModel
    {
        public string Message { get; set; }
    }

    public class MessageController : Controller
    {
        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult Save(JournalMessageInputModel messageModel)
        {
            // implement persistence logic here
            if (messageModel != null)
            {
                string fragment = messageModel.Message.PadRight(4,' ').Substring(0, 4) + "...";
                return Json(new { Status = "Posted journal entry to server: '" + fragment + "'" });
            }

            return Json(new { Status = "Empty message request." });
            
        }

        public ActionResult Index()
        {
            return View();
        }
    }
}
