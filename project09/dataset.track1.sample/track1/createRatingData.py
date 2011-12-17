fileName = open('testIdx1.firstLines.txt', 'rb') #substitute different file names here
fileName2 = open('testData.txt', 'w') #substitute different file names here
content = fileName.readline()
content = content.strip()
i = 0
userID = str(-1) #why? just so the file.write() doesn't complain about types
while (content != ""):
    fields = content.split("|")
    if (len(fields) < 2):
        fields = content.split("\t")
        itemID = fields[0]
        rating = fields[1] #not used for the test data
        fileName2.write(userID + "\t" + itemID + "\n" + "\t" + rating + "\n") #shorter for the test data
    else:
        userID = fields[0]
    content = fileName.readline().strip()
    i = i + 1
    print userID
fileName.close()
fileName2.close()
print "done"
