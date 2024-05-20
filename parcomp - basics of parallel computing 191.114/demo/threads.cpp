// $ g++ -o ./demo/threads ./demo/threads.cpp && ./demo/threads && rm -rf ./demo/threads

#include <iostream>
#include <thread>

void task() {
    std::cout << "child id: " << std::this_thread::get_id() << "\n" << std::endl;
}

int main() {
    std::thread t(task);
    std::thread t2(task);

    std::cout << "parent id: " << std::this_thread::get_id() << "\n" << std::endl;
    t.join();
    t2.join();
}
