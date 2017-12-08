using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SocketServer.Models;

using Nugget;

namespace SocketServer
{
    class HelloServer : ISocketServer
    {
        private string _serverPath = string.Empty;
        private WebSocketServer _server = null;

        private string _input = string.Empty;

        public string Input
        {
            set { this._input = value; }
        }

        public void Initialize(string serverPath, string originServerAndPort)
        {
            this._server = new WebSocketServer(8181, originServerAndPort, "ws://localhost:8181");
            this._server.RegisterHandler<Socket>(serverPath);

            Nugget.Log.Level = LogLevel.None;
        }

        public void Start()
        {
            this._server.Start();
        }

        public void Send()
        {
            this._server.SendToAll(this._input);
        }
    }
}
