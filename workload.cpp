/*
This file is a simple example of a thread that runs a lambda function.
*/

/*
The following headers are required for the code to run properly. They are part of the C++ Standard Library.
- iostream: input/output stream (e.g. std::cout, std::cin)
- thread: thread class and supporting functions
- chrono: time utilities
*/
#include <iostream>
#include <thread>
#include <chrono>

/*
TODO: refactor the code to define the lambda function separately before it's used.
Name the lambda function "threadFunction" and pass the lambda function to the thread constructor.
*/


int main()
{
    // define a constant 'stress' for how long we want the thread to run
    const int stress = 10;

    std::thread t1{[](int load /* simulated worload in seconds  */) -> void
                   {
                        // log a message to the console that the thread has started
                        std::cout << "Thread has started" << std::endl;
                       for (size_t i = 0; i < load; i++)
                       {
                           std::this_thread::sleep_for(std::chrono::milliseconds(500));
                       }
                        // log a message to the console that the thread has finished
                          std::cout << "Thread has finished" << std::endl;
                   },
                   stress};


    // wait for the thread to finish
    t1.join();

    std::cout << "Done!" << std::endl;
    return 0;
}
