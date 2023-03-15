' roReadFile examples

' In this example we'll show how to use readLine() with very long lines.
' Lines length cannot excede 4096 characters which we will work around here.

' Run this sample code from the BrightSign shell
' BrightSign> script roReadFile.brs

' Create a file with very long lines
' Each line in the file contains JSON which would be truncated at the 4096 chars boundary.

' Documentation: https://brightsign.atlassian.net/wiki/spaces/DOC/pages/370672993/roReadFile

sub main()
print : print "*** roReadFile example ***"

list = []

' Create list of strings ["1","2",... "1000"]

    for i = 0 to 1000
        list.push( i.toStr() )
    end for

json$ = formatJson( list )

print
print "JSON string length: "; json$.len()

' Show that JSON is valid

    if parseJson( json$ ) = invalid then stop

print "JSON is valid"

' We'll now write a file with two long lines

deleteFile("long-lines.txt")
appendFile = createObject( "roAppendFile", "long-lines.txt" )

appendFile.sendLine( json$ )
appendFile.sendLine( json$ )

appendFile.flush()
appendFile = invalid

''''''''''''''''''''''''''''''''''''''''''''

' We'll now read the JSON from file and show how line gets turncated which breaks the JSON.

file = createObject("roReadFile", "long-lines.txt" )

' Read a line from file
line$ = file.readLine()

    if parseJson( line$ ) = invalid then
        print
        print "INVALID JSON!"
        print "Length of line read from file is: "; line$.len()
        print "File current position is: "; file.currentPosition()
    end if

' Position in the file is now at 4095
' We haven't reached End Of Line (EOL)
' Let's continue reading the line and append to what we already have

print
print "Reading more..."

line$ = line$ + file.readLine()

    if parseJson( line$ ) <> invalid then
        print
        print "JSON is valid"
        print "Length of line is now: "; line$.len()
        print "File current position is: "; file.currentPosition()
    end if

end sub
