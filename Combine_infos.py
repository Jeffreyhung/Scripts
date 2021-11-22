assigned = open("Licenses Assigned.csv")
all_data = []
for i in assigned.readlines():
    line = i.split(",")

    line[2] = line[2].rstrip()
    all_data.append(line)

unlicensed = open("Unlicensed.csv")
need_upgrade = []
for i in unlicensed.readlines():
    line = i.split(",")
    line[5] = line[5].rstrip()
    for j in all_data:
        if line[3] in j[1]:
            line.extend(j[2])
            break
        elif line[3] in j[0]:
            line.extend(j[2])
            break
    need_upgrade.append(line)

output = open("output.csv", "w+")
for i in need_upgrade:
    temp = ""
    for j in i:
        temp = temp + j +','
    output.write(temp[:-1])
    output.write('\n')