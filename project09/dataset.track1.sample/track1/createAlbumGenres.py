fileName = open('albumData1.txt', 'rb')
fileName2 = open('album_genreData.txt', 'w')
content = fileName.readline()
content = content.strip()
i = 0
while (content != ""):
    fields = content.split("|")
    albumID = fields[0]
    if (len(fields) < 2):
        continue
    for j in range(2, len(fields)):
        fileName2.write(albumID + "|" + fields[j] + "\n")
    content = fileName.readline().strip()
    i = i + 1
    print albumID
fileName.close()
fileName2.close()
print "done"
