// Boost
#include <boost/program_options.hpp>

// STL
#include <iostream>

int main(int argc, char** argv) {
    boost::program_options::options_description desc("Allowed options");
    desc.add_options()
        ("help", "produce help message")
        ("nb", boost::program_options::value<int>(), "number to print to stdout");
    
    try {
        const auto command_line = boost::program_options::parse_command_line(argc, argv, desc);
        boost::program_options::variables_map vm;
        boost::program_options::store(command_line, vm);
        boost::program_options::notify(vm);    
        
        if (vm.count("help")) {
            std::cout << desc << std::endl;
            return 1;
        }
        
        if (vm.count("nb")) {
            std::cout << "Number: " << vm["nb"].as<int>() << '.' << std::endl;
        } else {
            std::cout << "Number was not set.\n" << desc << std::endl;
        }
    }
    catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << '\n';
	std::cout << desc << std::endl;
    }

    return 0;
}
