fileName = open('trackData1.txt', 'rb')
fileName2 = open('genre_trackData.txt', 'w')
content = fileName.readline()
content = content.strip()
i = 0
while (content != ""):
    fields = content.split("|")
    trackID = fields[0]
    if (len(fields) < 3):
        continue
    for j in range(3, len(fields)):
        fileName2.write(trackID + "|" + fields[j] + "\n")
    content = fileName.readline().strip()
    i = i + 1
    if(i % 10000 == 0):
        print trackID
fileName.close()
fileName2.close()
print "done"
