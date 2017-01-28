#!/bin/sh

NOERROR="FALSE"
RANDVAR=$(echo $RANDOM)
checkGitOutput() {
	NOERROR="FALSE"
	if [[ "$GITREMOTE1" = "ERROR" ]] ; then
		GITV1=$(cat temp.${RANDVAR}.txt | cut -d':' -f2)
                GITVP=$(echo $GITV1 | cut -d' ' -f4)
                if [[ "$GITVP" = "found" ]] ; then
                	echo "It looks like there was a problem with the name that was $
                        echo "Or possibly SSH setup.  Please check configuration and re$
                        echo "The error was"
                        echo "$GITREMOTE"
                else
                	echo "unfortunately I do not have any additional information"
                        echo "The error was"
                        echo "$GITREMOTE"
                fi
	elif [[ "$GITREMOTE1" = "fatal" ]] ; then 
                GITV1=$(cat temp.${RANDVAR}.txt | cut -d':' -f2)
                if [[ "$GITV1" =~ "exists" ]] ; then
                	echo "It looks like you have already added a repository,"
                        echo "but for some reason, I cannot clone it.  Here is the information that I have"
                        echo "Remote repository is"
                        GITRV=$(git remote -v | cut -d'@' -f2 | cut -d'(' -f1 | cut -d' ' -f1) ; echo $GITRV | cut -$
                        echo "I attempted to clone it, but got this failure message"
                        echo "$GITREMOTE"
                else
    	        	echo "I ran into an error when attempting to clone the repository, "
        	        echo "but I do not have any additional information.  Here is the error message"
                	echo "$GITREMOTE"
                fi

	else
		NOERROR="TRUE"
	fi

}
git init
if [ -e ~/.ssh/id_rsa.pub ] ; then 
	echo "Located public key, I will do a test connection to GitHub" ; 
        # RANDVAR=$(echo $RANDOM)
	ssh -T git@github.com 2> temp.${RANDVAR}.txt
	CVAR=$(<./temp.${RANDVAR}.txt)
	CVAR1=$(echo $CVAR | cut -d' ' -f5)
	CVARP=$(echo $CVAR1 | cut -d',' -f1)
	if [[ "$CVARP" != "authenticated" ]] ; then
		echo ""
		echo "WARNING! There may be a problem with SSH, either keys are not set up with GitHub, or some other problem"
		echo "Output from the error was"
		echo $CVAR
		echo ""
	else
		echo ""
		echo "SSH Authentication looks good."
		echo "Enter remote repository to add.  Note that this should be in the format"
		read -p "username/repositoryname.git " GITREPOS
		git remote add origin git@github.com:${GITREPOS}
		sleep 1
		echo "Working..."
		git fetch origin 2> temp.${RANDVAR}.txt
		GITREMOTE=$(<./temp.${RANDVAR}.txt)
		GITREMOTE1=$(echo $GITREMOTE | cut -d':' -f1)
		checkGitOutput
                if [[ "$NOERROR" = "TRUE" ]] ; then
			sleep 1
			echo "Still working, be patient..."
			git clone git@github.com:${GITREPOS} 2> temp.${RANDVAR}.txt
			GITREMOTE=$(<./temp.${RANDVAR}.txt)
			GITREMOTE1=$(echo $GITREMOTE | cut -d':' -f1)
			checkGitOutput
			if [[ "$NOERROR" = "TRUE" ]] ; then 
				echo "It looks like your remote git repository was successfully cloned!"
			else
				echo "I ran into some problems, please see previous error messages for more information"
			fi
		else
			echo "It looks like there were some problems, please see the previous error messages for more information"
		fi
	fi
else
	echo ""
	echo "It looks like SSH has not been set up on this computer"
	echo "please run ssh-keygen -t rsa -b 4096 -C \"yourgithubaccountemail@email.com\""
	echo ""
fi

rm temp.${RANDVAR}.txt
