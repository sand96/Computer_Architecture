#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <string>
#include <vector>
using namespace std;

string extend(string str)
{
	string result;
	string temp;
	int num;
	if (str.find("r")==0)
	{
		str=str.substr(1);
		num=stoi(str);
		std::bitset<7> a(num);
		ostringstream stream;
		stream<<a;
		result=stream.str();
	}
	else
	{
		num=stoi(str);
		std::bitset<10> a(num);
		ostringstream stream;
		stream<<a;
		result=stream.str();
	}
	return result;
}

int main()
{
    //read the code from file
	ifstream infile("code.txt", ios::in);
	string line;
	//output hexadecimal
	ofstream outfile("encode.txt",ios::out);
	
	//map store the word and the opcode
	map<string, string> code_map;
	code_map["lqd"]="00110100";
	code_map["stdq"]="00100100";
	code_map["ah"]="00011001000";
	code_map["ahi"]="00011101";
	code_map["a"]="00011000000";
	code_map["ai"]="00011100";
	code_map["sfh"]="00001001000";
	code_map["sfhi"]="00001101";
	code_map["sf"]="00001000000";
	code_map["sfi"]="00001100";
	code_map["mpy"]="01111000100";
	code_map["mpyu"]="01111001100";
	code_map["mpyi"]="01110100";
	code_map["and"]="00011000001";
	code_map["andbi"]="00010110";
	code_map["andhi"]="00010101";
	code_map["andi"]="00010100";
	code_map["or"]="00001000001";
	code_map["orbi"]="00000110";
	code_map["orhi"]="00000101";
	code_map["ori"]="00000100";
	code_map["xor"]="01001000001";
	code_map["xorbi"]="01000110";
	code_map["xorhi"]="01000101";
	code_map["xori"]="01000100";
	code_map["nand"]="00011001001";
	code_map["nor"]="00001001001";
	code_map["shlqbi"]="00111011011";
	code_map["shlqbii"]="00111111011";
	code_map["rotqby"]="00111011100";
	code_map["rotqbyi"]="00111111100";
	code_map["cbd"]="00111110100";
	code_map["ceqb"]="01111010000";
	code_map["ceqbi"]="01111110";
	code_map["ceqh"]="01111001000";
	code_map["ceqhi"]="01111101";
	code_map["ceq"]="01111000000";
	code_map["ceqi"]="01111100";
	code_map["cgtb"]="01001010000";
	code_map["cgtbi"]="01001110";
	code_map["cgth"]="01001001000";
	code_map["cgthi"]="01001101";
	code_map["cgt"]="01001000000";
	code_map["cgti"]="01001100";
	code_map["br"]="001100100";
	code_map["bra"]="001100000";
	code_map["brsl"]="001100110";
	code_map["brasl"]="001100010";
	code_map["bi"]="00110101000";
	code_map["bisl"]="00110101001";
	code_map["brnz"]="001000010";
	code_map["brz"]="001000000";
	code_map["brhnz"]="001000110";
	code_map["brhz"]="001000100";
	code_map["fa"]="01011000100";
	code_map["fs"]="01011000101";
	code_map["fm"]="01011000110";
	code_map["fma"]="1110";
	code_map["dfceq"]="01111000011";
	code_map["dfcgt"]="01011000011";
	code_map["cntb"]="01010110100";
	code_map["avgb"]="00011010011";
	code_map["stop"]="00000000000";
	code_map["inop"]="00000000001";
	code_map["nop"]="01000000001";


	//read each line of the input file
	while(getline(infile,line)!=0)
	{
		vector<int> split_index;
		int size=line.size();
		string binary;
		split_index.push_back(-1);
		// get the split index
		for (int i=0;i<size;i++)
		{
			if (line[i]==' ' || line[i]==',' || line[i]=='(' || line[i]==')')
			{
				split_index.push_back(i);
			}
		}
		split_index.push_back(size);
		cout<<line<<endl;
		vector<string> operand;
		for (int i=0;i<split_index.size()-1;i++)
		{
			string temp(line,split_index[i]+1,split_index[i+1]-split_index[i]-1);
			operand.push_back(temp);
		}
		if (operand[0]=="lqd" || operand[0]=="stqd")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[2])+extend(operand[3])+extend(operand[1]);

		}
		else if(operand[0]=="br" || operand[0]=="bra")
		{
			int num=stoi(operand[1]);
			std::bitset<16> a(num);
			ostringstream stream;
			stream<<a;
			string s=stream.str();
			binary+=code_map[operand[0]]+s+"0000000";
		}
		else if(operand[0]=="brsl" || operand[0]=="brasl" || operand[0]=="brnz" || operand[0]=="brz" || operand[0]=="brhnz" || operand[0]=="brhz")
		{
			int num=stoi(operand[2]);
			std::bitset<16> a(num);
			ostringstream stream;
			stream<<a;
			string s=stream.str();
			binary+=code_map[operand[0]]+s+extend(operand[1]);
		}
		else if(operand[0]=="bi")
		{
			binary+=code_map[operand[0]]+"0000000"+extend(operand[1])+"0000000";
		}
		else if(operand[0]=="bisl")
		{
			binary+=code_map[operand[0]]+"0000000"+extend(operand[2])+extend(operand[1]);
		}
		else if(operand[0]=="fma")
		{
			binary+=code_map[operand[0]]+extend(operand[1])+extend(operand[3])+extend(operand[2])+extend(operand[4]);
		}
		else if(operand[0]=="cntb")
		{
			binary+=code_map[operand[0]]+"0000000"+extend(operand[2])+extend(operand[1]);
		}
		else if(operand[0]=="stop" || operand[0]=="nop" || operand[0]=="lnop")
		{
			binary+=code_map[operand[0]]+"000000000000000000000";
		}
		else
		{
			binary+=code_map[operand[0]];
			for (int i=operand.size()-1;i>0;i--)
			{
				binary+=extend(operand[i]);
			}
		}
		cout<<binary<<endl;
		outfile<<binary<<endl;
	}
	return 0;
}
