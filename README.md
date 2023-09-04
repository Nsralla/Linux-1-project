# Linux-1-project
In this project, you are required to implement a simple dictionary-based compression and decompression
tool in shell scripting.
The dictionary-based compression is a lossless compression technique that relies on finding patterns in data.
In the compressed file, a shorter code is substituted for the pattern. In this project, and for simplicity, we
will have (assume) the following:
1. A unique binary code is assigned to each word in the uncompressed file. Thus, the compressed file
will consist of binary codes only
2. The code size is 16-bit. This will allow us to encode up to 65,536 unique words
3. The uncompressed file is a text file that contains Unicode characters, i.e., each character is 16-bit
4. Your compression/decompression tool will have a dictionary stored in a text file called
dictionary.txt. The binary code of the values of the dictionary starts from 0x0000.
5. Initially, assume the dictionary is empty. The dictionary is filled over time when more and more
compression operations are performed.
6. The tool is case-sensitive.
7. Special characters, such as, spaces, punctuation, $, #, etc. are treaded as words, and hence each one
will have a code in the dictionary
Program Menu (Program usage flow):
1. The program asks the user if the dictionary.txt file exist or not
2. If yes, the program asks the user to enter the path of dictionary.txt, read this path, and load the
dictionary into the appropriate data structure.
3. If no, the program creates a new empty dictionary.txt
4. The program asks the user whether he or she wants to do compression or decompression
- c, compress, or compression means compression.
- d, decompress, decompression means decompression
- The options above are case-insensitive
- Any other option, the program prints the appropriate error message
5. In the case of compression,
- The program asks the user to enter the path of the file to be compressed
- The program reads the file and compresses it by substituting the appropriate codes from the
dictionary
- If the program encounters a word in the input file that does not exist in the dictionary, then the
program appends it to the dictionary and uses its new code in the compression operation
- The program computes the compression ratio and prints it on the screen
- The program writes the compressed data in the compressed file
- The program saves changes on the dictionary
6. In the case of decompression,
- The program asks the user to enter the path of the file to be decompressed
- If the file has codes that do not exist in the dictionary, an appropriate error message is displayed
- The program decompresses the file by substituting the correct words from the dictionary
- The program writes the decompressed data in the uncompressed file 
