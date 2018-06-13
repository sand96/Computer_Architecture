#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <string>
#include <vector>
#include <bitset>
#include <cstring>
#include <cstdlib>
using namespace std;

//\brief translate the register value into a binary number
string extend(string str,int n)
{
 //   cout<<str<<endl;
	string result;
	string temp;
	int num;
	if (str.find("r")==0)
	{
		str=str.erase(0,1); //erase the first character in the string
		num=atoi(str.c_str());  //translate the value into a integer
		std::bitset<7> a(num);
		ostringstream stream;
		stream<<a;
		result=stream.str();
	}
	else if(n == 7)
	{
		num=atoi(str.c_str());  //translate the value into a integer
		std::bitset<7> a(num);
		ostringstream stream;
		stream<<a;
		result=stream.str();
	}
	else if(n == 10)
	{
		num=atoi(str.c_str()); //translate the value into a integer
		std::bitset<10> a(num);
		ostringstream stream;
		stream<<a;
		result=stream.str();
	}
	else if(n == 16)
	{
		num=atoi(str.c_str()); //translate the value into a integer
		cout<<num<<endl;
		std::bitset<16> a(num);
		ostringstream stream;
		stream<<a;
		result=stream.str();
	//	cout<<result<<endl;
	}
	return result;
}

//int main()
int main(int argc, char*argv[])
{
	//map store the word and the opcode
	map<string, string> code_map;
		//load instruction
	code_map["lqd"]="00110100";
	code_map["lqx"]="00111000100";
	code_map["lqa"]="001100001";
	code_map["lqr"]="001100111";
		//store instruction
	code_map["stqd"]="00100100";
	code_map["stqx"]="00101000100";
	code_map["stqa"]="001000001";
	code_map["stqr"]="001000111";

		//add and substract operation
	code_map["ah"]="00011001000";
	code_map["ahi"]="00011101";
	code_map["a"]="00011000000";
	code_map["ai"]="00011100";
	code_map["sfh"]="00001001000";
	code_map["sfhi"]="00001101";
	code_map["sf"]="00001000000";
	code_map["sfi"]="00001101";
	code_map["addx"]="01101000000";
	code_map["cg"]="00011000010";
	code_map["bg"]="00001000010";

		//multiply
	code_map["mpyi"]="01110100";
	code_map["mpyu"]="01111001100";
	code_map["mpyui"]="01110101";
	code_map["mpya"]="1100";

		//byte operation
	code_map["clz"]="01010100101";
	code_map["cntb"]="01010110100";
	code_map["avgb"]="00011010011";
	code_map["absdb"]="00001010011";
	code_map["sumb"]="01001010011";
	code_map["xsbh"]="01010110110";
	code_map["xshw"]="01010101110";
	code_map["xswd"]="01010100110";
	code_map["selb"]="1000";

		//logic operation
	code_map["and"]="00011000001";
	code_map["andbi"]="00010110";
	code_map["andhi"]="00010101";
	code_map["andi"]="00010100";
	code_map["or"]="00001000001";
	code_map["orbi"]="00000110";
	code_map["orhi"]="00000101";
	code_map["ori"]="00000100";
	code_map["nor"]="00001001001";

		//rotate
	code_map["roth"]="00001011100";
	code_map["rothi"]="00001111100";
	code_map["rot"]="00001011000";
	code_map["roti"]="00001111000";
	code_map["rotqby"]="00111011100";
	code_map["rotqbyi"]="00111111100";
	code_map["rotqbi"]="00111011000";
	code_map["rotqbii"]="00111111000";

		//double floating operation
	code_map["dfa"]="01011001100";
	code_map["dfs"]="01011001101";
	code_map["dfm"]="01011001110";
	code_map["dfma"]="01101011100";
	code_map["dfnms"]="01101011110";
	code_map["dfms"]="01101011101";
	code_map["dfceq"]="01111000011";
	code_map["dfcgt"]="01011000011";

		//compare
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

		//branch
	code_map["brsl"]="001100110";
	code_map["brasl"]="001100010";
	code_map["bi"]="00110101000";
	code_map["bisl"]="00110101001";
	code_map["brnz"]="001000010";
	code_map["brz"]="001000000";
	code_map["brhnz"]="001000110";
	code_map["brhz"]="001000100";

		//nop
	code_map["stop"]="00000000000";


	//setup the open file
	ofstream outfile;
	outfile.open("encode.txt");
	//setup the input file
    ifstream infile;
    infile.open("code.txt");
    //read each line of the txt file
    string line;
    while(getline(infile,line))
	{
		vector<int> split_index;
		int size=line.size();
		split_index.push_back(-1); //to split the first operand
		// get the split index
		for (int i=0;i<size;i++)
		{
			if (line[i]==' ' || line[i]==',' || line[i]=='(' || line[i]==')')
			{
				split_index.push_back(i);
			}
		}
		split_index.push_back(size); //to split the last operand
		cout<<line<<endl;

		vector<string> operand; //each operand in the instruction
        string binary; //binary instruction


        //using the index in the split_index to split the instruction
        //and put the result in the operand vector
		for (int i=0;i<split_index.size()-1;i++)
		{
			string temp(line,split_index[i]+1,split_index[i+1]-split_index[i]-1);
		//	cout<<temp<<endl;
			operand.push_back(temp);
		}
   //     cout<<operand[0]<<endl;
		//translate the operand according to the codemap
		if (operand[0]=="lqd" || operand[0]=="stqd")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[2], 10)+extend(operand[3], 7)+extend(operand[1], 7);

		}
		else if (operand[0]=="lqx" || operand[0]=="stqx")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);

		}
		else if (operand[0]=="lqa" || operand[0]=="stqa" || operand[0]=="lqr" || operand[0]=="stqr")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[2], 16)+extend(operand[1], 7);
		}
			//add and substract
		else if (operand[0]=="ah" || operand[0]=="a" || operand[0]=="sfh" || operand[0]=="addx" || operand[0]=="sf" || operand[0]=="cg" || operand[0]=="bg" )
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);
		}

		else if (operand[0]=="ahi" || operand[0]=="ai" || operand[0]=="sfhi" || operand[0]=="sfi")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 10)+extend(operand[2], 7)+extend(operand[1], 7);
		}
				//multiply
		else if (operand[0]=="mpyu")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);
		}
		else if (operand[0]=="mpyi" || operand[0]=="mpyui" )
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 10)+extend(operand[2], 7)+extend(operand[1], 7);
		}
		else if (operand[0]=="mpya")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[1], 7)+extend(operand[3], 7)+extend(operand[2], 7) + extend(operand[4], 7);
		}

				//byte operation
		else if (operand[0]=="clz" || operand[0]=="cntb" || operand[0]=="xsbh" || operand[0]=="xshw" || operand[0]=="xswd" )
		{
			binary+=code_map[operand[0]];
			binary+="0000000"+extend(operand[2], 7)+extend(operand[1], 7);
		}
		else if (operand[0]=="avgb" || operand[0]=="absdb" || operand[0]=="sumb")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);
		}
		else if (operand[0]=="selb")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[1], 7)+extend(operand[3], 7)+extend(operand[2], 7) + extend(operand[4], 7);
		}

			//logic operation
		else if (operand[0]=="and" || operand[0]=="or" || operand[0]=="nor")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);
		}
		else if (operand[0]=="andbi" || operand[0]=="andhi" || operand[0]=="andi" || operand[0]=="orbi" || operand[0]=="orhi" || operand[0]=="ori")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 10)+extend(operand[2], 7)+extend(operand[1], 7);
		}

			//floating point
		else if (operand[0]=="dfa" || operand[0]=="dfs" || operand[0]=="dfm" || operand[0]=="dfma" || operand[0]=="dfnms" || operand[0]=="dfms"  || operand[0]=="dfceq" || operand[0]=="dfcgt")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);
		}

			//rotate
		else if (operand[0]=="roth" || operand[0]=="rot" || operand[0]=="rotqby" || operand[0]=="rotqbi")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);
		}
		else if (operand[0]=="rothi" || operand[0]=="roti" || operand[0]=="rotqbyi" || operand[0]=="rotqbii")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);
		}

			//compare
		else if (operand[0]=="ceqb" || operand[0]=="ceqh" || operand[0]=="ceq" || operand[0]=="cgtb" || operand[0]=="cgth" || operand[0]=="cgt")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 7)+extend(operand[2], 7)+extend(operand[1], 7);
		}
		else if (operand[0]=="ceqbi" || operand[0]=="ceqhi" || operand[0]=="ceqi" || operand[0]=="cgtbi" || operand[0]=="cgthi" || operand[0]=="cgti")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[3], 10)+extend(operand[2], 7)+extend(operand[1], 7);
		}

			//branch
		else if (operand[0]=="brsl" || operand[0]=="brasl" || operand[0]=="brnz" || operand[0]=="brz" || operand[0]=="brhnz" || operand[0]=="brhz")
		{
			binary+=code_map[operand[0]];
			binary+=extend(operand[2], 16)+extend(operand[1], 7);
		}
		else if (operand[0]=="bi")
		{
			binary+=code_map[operand[0]];
			binary+= "0000000"+extend(operand[1], 7)+"0000000";
		}
		else if (operand[0]=="bisl")
		{
			binary+=code_map[operand[0]];
			binary+= "0000000"+extend(operand[2], 7)+extend(operand[1], 7);
		}

		else if(operand[0]=="nop")
		{
			binary+="00000000000000000000000000000000";
		}
		else
		{
			/*binary+=code_map[operand[0]];
			for (int i=operand.size()-1;i>0;i--)
			{
				binary+=extend(operand[i]);
			} */
			cout<<"error"<<endl;
		}
		cout<<binary<<endl;
		//store the binary into encode.txt
		outfile<<binary<<endl;
	}
	return 0;
}
