using System;
using System.Collections.Generic;
using System.Threading;
using System.Web.Script.Serialization;

using FizzWare.NBuilder;
using Nugget;
using SocketServer.Models;

namespace SocketServer
{
    class StockServer : ISocketServer
    {
        private string _serverPath = string.Empty;
        private WebSocketServer _server = null;
        private Timer _timer = null;
        private IList<Stock> _stocks = null;
        private int _index = 0;

        private string _input = string.Empty;

        public string Input 
        {
            set { this._input = value; }
        }

        public void Initialize(string serverPath, string originServerAndPort)
        {
            this._server = new WebSocketServer(8181, originServerAndPort, "ws://localhost:8181");
            this._server.RegisterHandler<StockSocket>(serverPath);
            
            Nugget.Log.Level = LogLevel.None;

            this._stocks = Builder<Stock>.CreateListOfSize(1000).WhereAll().Build();
        }

        public void Start()
        {
            this._server.Start();
        }

        public void Send()
        {
            if (this._timer == null)
            {
                this._timer = new Timer(SendStock, null, 0, 1500);

                Console.WriteLine("");
                Console.WriteLine("Sending stock info to all connected clients.");
                Console.WriteLine("");
            }
        }

        private void SendStock(Object state)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();

            string stock = serializer.Serialize(this._stocks[this._index]);
            this._server.SendToAll(stock);
            this._index++;
        }
    }
}
