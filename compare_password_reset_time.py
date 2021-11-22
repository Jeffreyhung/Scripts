file_path1 = 'UserPasswordReset.csv'
file_path2 = 'breach_list.csv'
output = open("output.csv", "w+")
file1  = open(file_path1, 'r')
file2  = open(file_path2, 'r')

result = []
reset_date= []

for line in file1:
	temp = line.split(',')
	temp[0] = temp[0].strip().lower()
	temp[1] = temp[1].rstrip("\n")
	reset_date.append(temp)



for line in file2:
	temp = line.split(',')
	temp5 = ""
	for i in reset_date:
		if (temp[2].lower() in i):
			temp2 = i + temp
			result.append(temp2)
			temp5 = ""
			for j in temp2:
				temp5 = temp5 + j +','
			break
		else:
			temp5 = " , ,"
			for j in temp:
				temp5 = temp5 + j +','
	output.write(temp5[:-1])
print(result)

'''
    if ( f.count(temp[serial_tag]) > 1):
        if(temp[serial_tag] not in result):
            result.append(temp[serial_tag])

result.sort()
print('Duplicated Serial Tag')
for i in result:
    print(i)
print('----------------')
print('Count: ', len(result))
'''