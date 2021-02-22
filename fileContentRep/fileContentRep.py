#!/usr/bin/python

import sys
import getopt

repDict = {
	"[%content%]"		:	"hanxiangguo",
	"[%imageName%]"		:	"this image"
}

def usage() : 
	print "usage: fileContentRep infile outfile"
	print "    replace string"
	print "\nfileContentRep-V0.1 psbec@126.com"
	sys.exit()

def parseArgs(argPair) : 
	for op, val in argPair : 
		if op == "-h" : 
			usage()
		elif op == "-e" :
			datPair = val.split('=',-1)
			if len(datPair) < 2 :
				print "invalid argument, ", val
				sys.exit()
			print "add pair = %s,%s" % (datPair[0], datPair[1])
			repDict[datPair[0]] = datPair[1]


# support -h -e string
opts,args = getopt.getopt(sys.argv[1:], "he:")

parseArgs(opts)

if len(args) < 2 : 
	usage()

fo = open(args[0], "rb")
content = fo.read()
fo.close()

for key in repDict:
	content = content.replace(key, repDict[key])

fo = open(args[1], "wb")
fo.write(content)
fo.close()

print "process done, out file is ", args[1]
