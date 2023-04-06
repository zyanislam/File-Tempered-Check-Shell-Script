#!/bin/bash

# Count the no of tampered files
tampered_files=0

# Declare an Associative Array that maps a Key to a Value
declare -A tampered_by_dept

# Date Check

# DATE=11-31-2005
# DATE=29-31-2005
# DATE=2021-02-29
# d=${DATE:8:2}
# m=${DATE:5:2}
# Y=${DATE:0:4}
# echo $d $m $Y
# echo "year=$Y, month=$m, day=$d"
# if date -d "$Y-$m-$d" &> /dev/null; then 
#   echo VALID
# else 
#   echo INVALID
# fi 

for dept_dir in logs/*; do

    # Check if it's a directory
    if [ -d "$dept_dir" ]; then 
        dept=$(basename "$dept_dir")
        echo "The directory we are checking is: "$dept

        for log_file in "$dept_dir"/*.log; do
            # Taking name of the file
            filename=$(basename "$log_file")

            # Extract date from the filename
            # Ex: 2002_01_20.log
            #     0123456789
            
            # Length
            #      |4|     |2|    |2|
            #    |0123| 4 |56| 7 |89|
            date=${filename%.log}

            year=${date:0:4}
            month=${date:5:2}
            day=${date:8:2}

            # echo "Year: " $year
            # echo "Month: " $month
            # echo "Day: " $day
            
            # Leap Year check
            if [ $month -eq 2 ] && [ $day -eq 29 ] && ! date -d "$year-02-29" >/dev/null 2>&1; then
              echo "Not a leap year"
              echo "Tampered: $log_file"
              ((tampered_files++))
              ((tampered_by_dept[$dept]++))
              continue

            # Check if the date is valid, if an error occurs then discard it
            elif ! date -d "$year-$month-$day" &> /dev/null; then
              echo "Not a valid date"
              echo "Tampered: $log_file"
              ((tampered_files++))
              ((tampered_by_dept[$dept]++))
              continue
            fi

            # Check if the department and date in the file matches the dept & filename

            # Read all lines into an array
            readarray -t lines < "$log_file"

            # Print each line
            # for line in "${lines[@]}"; do
            #   echo "$line"
            # done


            # filedept = 1st line inside the file
            # filedate = 2nt line inside the file
            filedept=${lines[0]}
            filedate=${lines[1]}

            # echo "$filedept"
            # echo "$filedate"

            # Department: mecha
            # 0123456789012
            deptf=${filedept:12:6}
            # echo "$deptf"

            # Log for 2004_08_25
            # 012345678---------
            datef=${filedate:8:10}
            # echo "$datef"

            if [[ "$deptf" != "$dept" || "$datef" != "$date" ]]; then
              echo "File Dept/Date doesn't match with the Dept/Date inside the file."
              echo "Tampered: $log_file"
              ((tampered_files++))
              ((tampered_by_dept[$dept]++))
              # echo "${tampered_by_dept[$dept]}"
            fi
        done
    fi
done

# Print the A.Array's Key & Value
echo "Total tampered files: $tampered_files"
for dept in "${!tampered_by_dept[@]}"; do
    echo "$dept: ${tampered_by_dept[$dept]}"
done

