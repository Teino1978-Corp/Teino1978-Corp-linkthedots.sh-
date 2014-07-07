#!/bin/bash

#script to copy the dotfiles to/from here to/from their proper places

#Usage:
#$ sh linkthedots.sh collect --> get files
#$ sh linkthedots.sh push --> put files
#$ sh linkthedots.sh cleanstore --> remove files from dotstorage
#$ sh linkthedots.sh cleanfiles --> remove files from config locations
#$ sh linkthedots.sh help --> show this help


#get dotfiles dir path from running file (files are copied in the folder the script is in
#so choose an empty folder say ~/dotfiles and put this script in there.
filepath=`readlink -f $0`;
rootdir=${filepath%/*};
#echo $rootdir;

dotfileslist=( #write full paths of dotfile locations
	"/path/to/dotfiles"
	"/path/to/dotfolders"
	);

#functions
dot_collect(){ #collecting dotfiles from their locations to $rootdir
	echo "Collecting dotfiles...";
	for index in ${!dotfileslist[*]};
	do
		dotpath="${dotfileslist[$index]}";
		#echo $dotpath;
		dotfilename="${dotpath##*/}";
		dotlocation="${dotpath%/*}";
		#echo "$dotlocation/" "$dotfilename";
		cp -iruv "$dotlocation/$dotfilename" "$rootdir/";
	done;
}

dot_push(){ #pushing dotfiles from #rootdir to their actual locations
	echo "Copying dotfiles to their proper locations..."
	for index in ${!dotfileslist[*]};
	do
		dotpath="${dotfileslist[$index]}";
		#echo $dotpath;
		dotfilename="${dotpath##*/}";
		dotlocation="${dotpath%/*}";
		#echo "$dotlocation/" "$dotfilename";
		cp -iruv "$rootdir/$dotfilename" "$dotlocation/";
	done;
}

dot_cleanstore(){ #cleaning $rootdir
	echo "Cleaning files from $rootdir..."
	for index in ${!dotfileslist[*]};
	do
		dotpath="${dotfileslist[$index]}";
		#echo $dotpath;
		dotfilename="${dotpath##*/}";
		dotlocation="${dotpath%/*}";
		#echo "$dotlocation/" "$dotfilename";
		rm -Irfv "$rootdir/$dotfilename";
	done;
}

dot_cleanfiles(){ #removing dotfiles from their locations
	echo "Cleaning files from configs..."
	for index in ${!dotfileslist[*]};
	do
		dotpath="${dotfileslist[$index]}";
		#echo $dotpath;
		#dotfilename="${dotpath##*/}";
		#dotlocation="${dotpath%/*}";
		#echo "$dotlocation/" "$dotfilename";
		rm -Irfv "$dotpath";
	done;
}

dot_usage(){ #help
	echo "dotfiles storage-->$rootdir
Usage:
$ sh linkthedots.sh collect --> get files
$ sh linkthedots.sh push --> put files
$ sh linkthedots.sh cleanstore --> remove files from dotstorage
$ sh linkthedots.sh cleanfiles --> remove files from config locations
$ sh linkthedots.sh help --> show this help
";
}

#cli
case "$1" in
	'collect') dot_collect;
	;;
	'push')	dot_push;
	;;
	'cleanstore') dot_cleanstore;
	;;
	'cleanfiles') dot_cleanfiles;
	;;
	'help') dot_usage;
	;;
	*) dot_usage;
	;;
esac
