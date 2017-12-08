using System;
using Nugget;

namespace SocketServer.Models
{
    class StockSocket : WebSocket
    {
        // This method is called when data is comming from the client.
        // In this example the method is just empty
        public override void Incoming(string data)
        {
            Console.WriteLine(" Client says: " + data);
        }

        // This method is called when the socket disconnects
        public override void Disconnected()
        {
            Console.WriteLine(" Client disconnected");
        }

        // This method is called when the socket connects
        public override void Connected(ClientHandshake handshake)
        {
            //this.Send("You are now connected");
        }
    }
}
