#!/bin/bash

#script to copy the dotfiles to/from here to/from their proper places
#added file structure preservation - files are copied to their location related to root
#added logging errors

#to clone/sync my dotfiles: git clone https://github.com/arpanpal010/dotfiles.git

#Usage:
#$ sh linkthedots.sh collect --> get files
#$ sh linkthedots.sh push --> put files
#$ sh linkthedots.sh cleanstore --> remove files from dotstorage
#$ sh linkthedots.sh cleanfiles --> remove files from config locations
#$ sh linkthedots.sh help --> show this help

#get dotfiles dir path from running file
filepath=`readlink -f $0`;
rootdir=${filepath%/*};
#echo $rootdir;

#get hostname to sort dotfiles according to device
backupdir="$rootdir/backup/`hostname`";
#echo "Backupdir="$backupdir;

#log file location
loglocation="$rootdir/logs";

dotfileslist=( #write full paths of dotfile locations
#example
#	"/path/to/dotfiles"
#	"/path/to/dotfolders"
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
		#preserve folder hierarchy, create folders as they exist in device
		if [ ! -d "$backupdir/$dotlocation/" ]; 
		then
			echo "Creating $backupdir$dotlocation/";
			mkdir -p "$backupdir$dotlocation/";
		fi
		cp -ruv "$dotlocation/$dotfilename" "$backupdir$dotlocation" 2>>$loglocation; #make sure dotlocations start with /
	done;
	if [ $loglocation != "" ]; then echo "BACKUP-`hostname`-`date +%F-%H-%M-%S`;" >> $loglocation; fi;
	echo "Done.";
}
dot_push(){ #pushing dotfiles from #rootdir to their actual locations, run as root to copy in su places e.g /etc
	echo "Copying dotfiles to their proper locations..."
	for index in ${!dotfileslist[*]};
	do
		dotpath="${dotfileslist[$index]}";
		#echo $dotpath;
		dotfilename="${dotpath##*/}";
		dotlocation="${dotpath%/*}";
		#echo "$dotlocation/" "$dotfilename";
		cp -ruv "$backupdir$dotlocation/$dotfilename" "$dotlocation/" 2>>$loglocation;
	done;
	if [ $loglocation != "" ]; then echo "PUSH-`hostname`-`date +%F-%H-%M-%S`;" >> $loglocation;fi;
	echo "Done.";
}
dot_cleanstore(){ #cleaning $rootdir
	echo "Cleaning files from $rootdir..."
	#remove backupdir
	#rm -rf --preserve-root "$backupdir"; #dont keep other files in backup
	#or remove each files, leaves behind empty folders
	for index in ${!dotfileslist[*]};
	do
		dotpath="${dotfileslist[$index]}";
		#echo $dotpath;
		dotfilename="${dotpath##*/}";
		dotlocation="${dotpath%/*}";
		#echo "$dotlocation/" "$dotfilename";
		rm -Irfv "$backupdir$dotlocation/$dotfilename" 2>>$loglocation;
	done;
	if [ $loglocation != "" ]; then echo "CLEANSTORE-`hostname`-`date +%F-%H-%M-%S`;" >> $loglocation;fi;
	echo "Done.";
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
		rm -Irfv "$dotpath" 2>>$loglocation;
	done;
	if [ $loglocation != "" ]; then echo "CLEANFILES-`hostname`-`date +%F-%H-%M-%S`;" >> $loglocation;fi;
	echo "Done.";
}
dot_usage(){ #help
	echo "DotBackup-->$backupdir
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