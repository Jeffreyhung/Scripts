#! /bin/bash
function validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then true; else false; fi
}

read -p "Enter the url of one of the images: " input1
read -p "Max number of image to download: " input2
BASE=${input1::${#input1}-8}
output_folder=${BASE##*/}
output_folder=${output_folder::${#output_folder}-1}
for i in $(seq -f "%04g" 1 $input2)
do 
    x=$i
    URL=$BASE$x
    
    if `validate_url "$URL.jpg" >/dev/null`; 
    then wget -P "$output_folder" "$BASE$x.jpg" -q --show-progress; 
    else break; fi

    if `validate_url "$URL.mp4" >/dev/null`; 
    then wget -P "$output_folder" "$BASE$x.mp4" -q --show-progress; fi
done