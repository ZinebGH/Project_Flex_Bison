#!/usr/bin/bash
output="result.txt"
correct=0
failed=0
test_dir="../tests/correct/*"
rm -f $output
cd src
make


function run_tests() {
	
	for file in $test_dir 
		do
			echo -e "\n		\033[0;36m${file:17}\033[m\n"
			./as < "$file"
			let "res = $?"
			echo -e "Return value =  \033[0;33m$res\033[m"
			if [ $res = 0 ]
			then
				echo -e "\033[5;32mProgram is correct !\033[m"
				echo "$file: correct" >> $output
            	((correct++))			
			
			else
				echo -e "\033[5;31mProgram is not correct...\033[m"
				 echo "$file: failed" >> $output
            	((failed++))
			fi
		done
}

run_tests

test_dir="../tests/invalid/*"

run_tests


echo "TESTS CORRECT : $correct" >> $output
echo "TESTS INVALID : $failed" >> $output

