using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SocketServer.Models
{
    class Stock
    {
        public string Symbol { get; set; }
        public decimal Value { get; set; }
        public bool IsUp { get; set; }
        public decimal PercentChange { get; set; }
    }
}
