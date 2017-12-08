using System;
using Nugget;

namespace SocketServer.Models
{
    class Socket : WebSocket
    {
        // This method is called when data is comming from the client.
        // In this example the method is just empty
        public override void Incoming(string data)
        {
            Console.WriteLine("");
            Console.WriteLine(" Client says: " + data);
            Console.WriteLine("");
            Console.WriteLine("Enter response: ");
        }

        // This method is called when the socket disconnects
        public override void Disconnected()
        {
            Console.WriteLine(" * Client Disconnected");
        }

        // This method is called when the socket connects
        public override void Connected(ClientHandshake handshake)
        {
            Console.WriteLine("");
            Console.WriteLine(" * Client Connected");
            Console.WriteLine("");
            Console.WriteLine("What would you like to say to the client?");
            Console.WriteLine("");
        }
    }
}
