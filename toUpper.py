file_path = 'words.txt'
f = open(file_path, 'r')
Lines = f.readlines()
Result=[]
for line in Lines:
    Result.append(line.capitalize())
    
print(Result)
output = open("word1.txt", "w+")
for i in Result:
    output.write(i)