using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using AcctMgmtWebApp.Models;

namespace AcctMgmtWebApp.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult terms()
        {
            ViewData["Message"] = "Where we term people";

            return View();
        }

        public IActionResult search()
        {
            ViewData["Message"] = "Your search page.";

            return View();
        }

        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
