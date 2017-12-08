
namespace SocketServer
{
    interface ISocketServer
    {
        void Initialize(string serverPath, string originServerAndPort);
        void Start();
        void Send();
        string Input { set; }
    }
}
