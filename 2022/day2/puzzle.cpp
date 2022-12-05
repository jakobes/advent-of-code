#include <iostream>
#include <map>
#include <string>
#include <fstream>
#include <vector>
#include <sstream>
#include <set>

#include <boost/spirit/home/x3.hpp>


namespace parser {
    namespace x3 = boost::spirit::x3;
    namespace ascii = boost::spirit::x3::ascii;

    using x3::phrase_parse;
    using x3::char_;
    using x3::eol;
    using ascii::space;

    const auto pair_parser = char_ >> char_;
    const auto skip_parser = space;
}


int main() {
    using boost::spirit::x3::phrase_parse;
    std::map<char, int> rpc_scores{{'A', 1}, {'B', 2}, {'C', 3}, {'X', 1}, {'Y', 2}, {'Z', 3}};
    std::map<std::vector<char>, int> win_points{
	    {{'A', 'X'}, 3},
	    {{'A', 'Y'}, 6},
	    {{'A', 'Z'}, 0},

	    {{'B', 'X'}, 0},
	    {{'B', 'Y'}, 3},
	    {{'B', 'Z'}, 6},

	    {{'C', 'X'}, 6},
	    {{'C', 'Y'}, 0},
	    {{'C', 'Z'}, 3},
    };

    std::map<std::vector<char>, int> win_points_puzzle2{
	    {{'A', 'X'}, 3},
	    {{'A', 'Y'}, 1},
	    {{'A', 'Z'}, 2},

	    {{'B', 'X'}, 1},
	    {{'B', 'Y'}, 2},
	    {{'B', 'Z'}, 3},

	    {{'C', 'X'}, 2},
	    {{'C', 'Y'}, 3},
	    {{'C', 'Z'}, 1},
    };

    std::map<char, int> win_scores_puzzle2{{'X', 0}, {'Y', 3}, {'Z', 6}};

    std::ifstream ifs("input.txt");
    int score = 0;
    for (std::string line; std::getline(ifs, line); ) {
        std::vector<char> game_set;
	phrase_parse(
	    line.begin(),
	    line.end(),
            parser::pair_parser,
	    parser::skip_parser,
	    game_set
	);
	/* int round_score = win_points[game_set]; */
	/* round_score = round_score + rpc_scores[game_set[1]]; */
	/* std::cout << round_score << std::endl; */
	int round_score = win_scores_puzzle2[game_set[1]];
	round_score = round_score + win_points_puzzle2[game_set];
	score = score + round_score;
    }
    std::cout << "\n" << score << std::endl;
}
