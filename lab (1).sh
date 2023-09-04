#!/usr/bin/bash
while true; do
    dictionary_file_name=""
    codes=()
    strings=()
    check=0
    # ask the user if the dictionary exists or not
    read -p "Does the dictionary exist or not? (y/n): " answer1
    #if yes,ask the user to enter the path of the dictionay, read the path, and load the dictionary
    if [ "$answer1" = "y" ]; then
       # read -p "Enter the path of the dictionary: " dictionary_file_name
       echo "Enter the path of the dictionary: "
       read dictionary_file_name
       echo "Loading the dictionary from $dictionary_file_name ......"
        
        # Read the file line by line (read dictionary)
        while IFS= read -r line; do
            # Split the line into code and string using space as delimiter
            code="${line%% *}"
            string="${line#* }"
            
            codes+=("$code")
            strings+=("$string")
        done < "$dictionary_file_name"
        echo "The dictionary has been loaded successfully"
    else
        #create file called dictionary2.txt
        read -p "Enter name of dictionary to be created: " dictionary_file_name
        touch "$dictionary_file_name"
        echo "$dictionary_file_name dictionary has been created"
    fi 

    while true; do
    #ask the user if he wants COMPRESSION / DECOMPRESSION   
    read -p "Do you want to compress or decompress? (c/d): " answer2


    if [ "$answer2" = "c" ]; then
        echo "start compressing"
        #define array to save generated codes
        codes_for_compressing=()
        # let's compress the following sentence
        # Read the contents of readMe.txt and store it in the 'sentence' variable
        sentence=$(<readMe.txt)
        # Split the sentence into words and iterate over them
        IFS=$' \t' read -ra sentence_words <<< "$sentence"
        for word in "${sentence_words[@]}"; do
            found=false
            i=0  # Initialize index i
            flag=0
            newCode=0
            # Iterate over the strings array to compare with each string
            for j in "${strings[@]}"; do
                if [[ "$word" == "$j" ]]; then
                    found=true
                    codes_for_compressing+=("${codes[$i]}")  # Add the corresponding code
                    flag=1
                    break
                fi
                i=$((i+1))  # Increment index i
            done

            if [ "$flag" -eq 0 ]; then # to generate code for not founded string
                #if the dictionary file is empty, let new code = 0x0000
                if [ -s "$dictionary_file_name" -o "$check" -eq 1 ]; then
                    i=$((i-1))
                    newCode="${codes[$i]}"
                    # Extract the numeric value without the "0x" prefix
                    numeric_value=$((16#${newCode#0x}))

                    # Increment the numeric value by 1
                    new_numeric_value=$((numeric_value + 1))

                    # Convert the new numeric value back to a hexadecimal string
                    new_hex_string=$(printf "0x%04x" "$new_numeric_value")
        
                    # now, add the newCode to  codes_for_compressing array
                    codes_for_compressing+=("${new_hex_string}")
                    # now we must add the new string and the new code to the dictionary file
                    echo "$new_hex_string $word" >> "$dictionary_file_name"
                    # add the new code to codes arrray
                    codes+=("${new_hex_string}")
                    strings+=("${word}")
                else 
                    check=1
                    newCode=0x0000
                    codes_for_compressing+=("${newCode}")
                    echo "$newCode $word" >> "$dictionary_file_name"
                    # add the new code to codes arrray
                    codes+=("${newCode}")
                    strings+=("${word}")

                fi 
            fi
        done
        # Print each element on its own line in the file
        for code in "${codes_for_compressing[@]}"; do
            echo "$code"
        done > compressedFile.txt
        echo "COMPRESSION DONE"
        echo "------------------------------"
        echo "Before compressing"
        # Count the number of characters in the sentence
        character_count=${#sentence}
        #Multiply the character count by 16
        result1=$((character_count * 16))
        #Display the result
        echo "Number of characters: $character_count"
        echo "COMPRESSED FILE SIZE IN BITS: $result1 bits"
        echo "COMPRESSED FILE SIZE IN BYTES: $((result1 / 8)) bytes "
        echo "----------------------------------"
        echo "After compressing"
        # Count the number of characters in the sentence
        array_length=${#codes_for_compressing[@]}
        result2=$((array_length*16))
        echo "The compressed file size in bits: $result2 bit"
        echo "The compressed file size in bytes: $((result2 / 8)) byte "
        echo "----------------------------------"
        # let's print the ratio
        echo "FIle compression ratio = uncompressed file size/ compressed file size"
        echo "$result1 / $result2 : $(echo "scale=2; $result1 / $result2" | bc)"
        echo "----------------------------------"



        break




    elif [ "$answer2" = "d" ]; then
        echo "DeCompressing......."
        # Arrays to store codes and strings of the dictionary
        # Declare an empty array to store the hexadecimal codes
        hex_codes=() # hexa codes to read from file that will be decompressed
        strings_after_decompressing=()
        read -p "Enter file name to be DECOMPRESSED: " file1
        # Read the file line by line and store the codes in the array
        while IFS= read -r line; do
            # Extract the hexadecimal code using parameter expansion
            hex_code="${line#*(}"
            # Append the code to the array
            hex_codes+=("$hex_code")
        done < "$file1"


        # now let's compare
        # Loop through the hex_codes array and compare with codes array
        for (( i = 0; i < ${#hex_codes[@]}; i++ )); do
            match_found=false  # Initialize match_found flag
            
            for (( j = 0; j < ${#codes[@]}; j++ )); do
                if [[ "${hex_codes[i]}" == "${codes[j]}" ]]; then
                    strings_after_decompressing+=("${strings[j]}")
                    match_found=true  # Set the flag to true if a match is found
                    break  # Exit the inner loop since a match has been found
                fi
            done

            if ! $match_found; then
                echo "Error: No match found for code ${hex_codes[i]}"
                exit 1
            fi
        done
        #AFTER THIS CODE, WE HAVE TRANSFOREMED THE CODES INTO STRINGS


        # now we need to print the strings_after_decompressing array to a file called afrerDecompressing.txt
        # Print the strings_after_decompressing array to a file
        printf "%s " "${strings_after_decompressing[@]}" > "afterDecompressing.txt"
        echo "Results saved to afterDecompressing.txt"
        echo "Decompress done "
        break

    else
        echo "inappropriate input,please enter c/d."
    fi   
    done         
done
    