# cmd_sftp_filecheck
Imagine, that you have a set of files on SFTP server, possibly with a general mask, like a date in their names (for easier identification) and you need to check if all of them are present without having access to actual server besides the SFTP connection.
If there are two or three files - easy. But what if there are hundreds of them and the count may vary? This script will help you.
You put a list of files into a filelist.txt in format like ".extension Mandatory" (instead of .extension another portion of mask may be used; Mandatory - is an optional description) and run the script. It will ask for username and password (but better use a key authentication, if available), get the list of files and then parse that output letting you know if any of the files are missing.
Sample uses SSH Tectia Client, but it should be possible to replace it with any other CLI-capable client. My own [Global Functions](https://github.com/Simbiat/cmd_global_functions) is also used here.
