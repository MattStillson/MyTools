using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AcctMgmtWebApp.Models
{
    public class Employee
    {
        public int ID { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public ICollection<ActiveDirectory> ActiveDirectory { get; set; }
        public ICollection<InterActionClient> InterActionClient { get; set; }
        public ICollection<Cvue> Cvue { get; set; }
    }
}
