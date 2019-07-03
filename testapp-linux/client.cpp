#include <zmq.hpp>
#include <string>
#include <iostream>

int main ()
{
    zmq::context_t context (1);
    zmq::socket_t socket (context, ZMQ_REQ);

    std::cout << "Connecting to arty…" << std::endl;
    socket.connect ("tcp://arty:5555");

    while (1){

        zmq::message_t request (5);
        memcpy (request.data (), "Hello", 5);
        socket.send (request);

        zmq::message_t reply;
        socket.recv (&reply);
    }
    return 0;
}
