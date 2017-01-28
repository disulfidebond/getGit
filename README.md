# getGit
This is a self-contained bash script that can be run by copying and pasting into a text file, cloning this repository, or other similar methods.  Briefly, if run from a local Terminal with 

*bash getGit.sh* 

it checks to see if SSH has been set up, then asks for the name of a remote repository and attempts to clone it.  If it is successful, it provides an appropriate descriptive output.  If it fails, it tries to provide a helpful error message with suggestions on how to fix the problem, before gracefully exiting.
