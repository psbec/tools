#!/bin/bash

# Global variables
appName="dropDeps.sh"
destDir="."
doCopy="yes"


# Functions 
pureCopy()
{
	local path=${destDir}`dirname $1`
	[[ ! -d $path ]] && mkdir -p $path

	if [[ ! -e ${destDir}$1 ]]; then
		echo '    copy' $1 to $path
		cp -d $1 $path
		doCopy="yes"
	fi
}

copyFile()
{
	pureCopy $1

	# symbol link file, copy source file
	if [[ -L $1 ]]; then
		local realFile=`ls -l $1`
		realFile=${realFile#*->}
		realFile=${realFile%**}
		realFile=`echo $realFile`
		
		if [[ "${realFile:0:1}" == "/" ]]; then
			pureCopy $realFile
		else
			pureCopy `dirname $1`/$realFile
		fi
	fi 
}

# check file dependence
lddFile()
{
	local file=$1

	ldd $file | grep "/" | while read line  
	do
		name=${line#*=>}
		name=${name%(*} 
		name=`echo $name`
		if [[ "${name:0:4}" == "/lib" || "${name:0:8}" == "/usr/lib" ]]; then
			#echo '    Process: '$name
			copyFile $name
		fi
	done
}

# find all files in dir, get dependence
lddDir()
{
	echo Start check dir $1
	for file in `find $1`
	do
		if [[ -f $file && `file $file|grep ELF` != "" && ! -L $file ]]; then
			echo process elf file: $file
			lddFile $file
		fi
	done
}

lddDestDir()
{
	doCopy="yes"

	# do ldd
	while [[ "$doCopy" == "yes" ]]
	do
		doCopy="no"
		lddDir $destDir
	done
}

# helpFuction
helpFunc()
{
	if [[ $# == 0 ]]; then
		echo
		echo "Usage: $appName <Func> <Args>"
		echo 
		echo "Function list:"
		echo "    path    drop dependence files from <path>;"
		echo "    file    copy file and it's dependence files to some path;"
		echo "    cmd     copy cmd file and it's dependence files to some path;"
		echo
		echo "Version v0.1"
		echo "Author: han.psbec, psbec@126.com"
		echo 
	fi

	case $1 in 
		"path" )
			echo
			echo "$appName path <rootPath>"
			echo "    Drop dependence file for files in <rootPath>."
			echo
			echo "$appName path <appPath> <rootPath>"
			echo "    Drop dependence file for files in <appPath>, and copy deps to <rootPath>."
			echo
			;;

		"cmd" )
			echo
			echo "$appName cmd <cmdName> <rootPath>"
			echo "    Copy <cmdName> and its dependence to <rootPath>, use the same path."
			echo
			;;

		"file" )
			echo
			echo "$appName file <fileName> <dirInRootPath> <rootPath>"
			echo "    Copy <fileName> to 'rootPath/dirInRootPath' and copy it's dependence to <rootPath>."
			echo
			;;

		* )
			;;
	esac
}

###############################################################################
# start main programe

funcName=$1

case $funcName in 
	"path" )
		srcPath=$2
		destDir=$3
		[[ $srcPath == "" ]] && helpFunc $funcName && exit 1

		if [[ $destDir == "" ]]; then
			destDir=$srcPath
		else
			lddDir $srcPath
		fi

		lddDestDir
		;;

	"cmd" )
		cmdName=$2
		destDir=$3
		[[ $cmdName == "" || $destDir == "" ]] && helpFunc $funcName && exit 1

		# find out bin file, and copy to path
		for item in `which $cmdName`
		do
			if [[ ${item:0:1} == "/" ]]; then
	        	path=${destDir}`dirname $item`
	        	[[ ! -d $path ]] && mkdir -p $path
			
				copyFile $item
				lddDir $item
				lddDestDir
				cmdProced="yes"
			fi
		done

		[[ $cmdProced != "yes" ]] && echo "command $cmdName not found." && exit 1
		;;

	"file" )
		fileName=$2
		subDir=$3
		destDir=$4
		[[ $fileName == "" || $subDir == "" || $destDir == "" ]] && helpFunc $funcName && exit 1
		[[ ! -d $destDir/$subDir ]] && mkdir -p $destDir/$subDir

		if [[ -f $fileName ]];then
			cp -rf $fileName $destDir/$subDir
			[[ -x $fileName ]] && lddDestDir		# if file is executable, drop deps
		else
			echo Must be normal file!
			exit 1;
		fi
		;;

	* )
		helpFunc 
		exit 1
		;;
esac
		
echo All Done!
