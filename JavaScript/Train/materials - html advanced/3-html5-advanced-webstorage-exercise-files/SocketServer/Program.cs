using System;
using Nugget;

namespace SocketServer
{
    class Server
    {
        static void Main(string[] args)
        {
            ISocketServer server = null;

            Console.WriteLine();
            Console.WriteLine("Welcome to the socket server.");
            Console.WriteLine();
            Console.WriteLine("Which server type would you like to create?");
            Console.WriteLine("   1) Hello World Server");
            Console.WriteLine("   2) Stocks Server");
            Console.WriteLine();

            string input = Console.ReadLine();

            if (input == "1")
            {
                server = new HelloServer();
                server.Initialize("/server", "http://localhost:2709");

                Console.WriteLine("");
                Console.WriteLine("The Hello World Server is now available under ws://localhost:8181/server.");
                Console.WriteLine("");
            }
            else if (input == "2")
            {
                server = new StockServer();
                server.Initialize("/stocks", "http://localhost:2709");

                Console.WriteLine("");
                Console.WriteLine("The Stocks Server is now available under ws://localhost:8181/stocks.");
                Console.WriteLine("");
            }
            else
            {
                Console.WriteLine("");
                Console.WriteLine(string.Format("Sorry, {0} is not a valid option.", input));
                Console.WriteLine("");
            }

            if (server != null)
            {
                server.Start();

                input = string.Empty;
                while (input != "exit")
                {
                    server.Input = input;
                    server.Send();
                    input = Console.ReadLine();
                }
            }

            Console.WriteLine("");
            Console.WriteLine("Closing socket server.");
            Console.WriteLine("");
        }
    }
}
