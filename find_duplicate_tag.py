#Export all agent info with serial tag from Kaseya
# change file_path to where the exported file is
file_path = 'ExportManageAgentList.csv'
# change the column number to where serial tag is
serial_tag = 12

f = open(file_path, 'r').read()
file  = open(file_path, 'r')
duplicate = []
for line in file:
    temp = line.split(',')
    if ( f.count(temp[serial_tag]) > 1):
        if(temp[serial_tag] not in duplicate):
            duplicate.append(temp[serial_tag])

duplicate.sort()
print('Duplicated Serial Tag')
for i in duplicate:
    print(i)
print('----------------')
print('Count: ', len(duplicate))
file.close()