# os-code-server
code server for openshift 

These scripts can be used to create and manage a live vs code environment into an OpenShift cluster.

This can be helpful when implementing pair programming practices.

The OpenShift CLI is required for these scripts to work.

## Limitations

1. Upload script
The upload script currently uploads all files under the present working directory to the code server. This could cause problems if the user runs the command in 
a directory where they have lots of files (for example their home directory).

2. Scripts only work if placed in users home directory.
The scripts will only work if they are placed in the users home directory. This is because several of the scripts reference the scripts themselves by using
the HOME environment variable followed by a prefixed path. For example the update script. I can improve this by adding a variable in the scripts which can identify
the path to itself.

'''
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
'''

3. Scripts currently use public repo to deploy the application
Currently the scripts create the code server using a dockerfile which is stored in a public repo on github.com. This makes it easy to create the deployment
because it does not need any credentials. This allows the application to be created without the use of any secret. Ideally however would deploy the application from the git repo in github.ibm.com (which would require credentials in OpenShift) or alternativley deploy directly from the dockerfile stored locally on users machine.

## Improvements/Amendments to be made

1. Cosolidate into 1 script
Currently I have written all the seperate functions in seperate files. This has made each function easier to ammend and manage but for simplicity of installation 
and usage should nest them all into one script.

2. os-code status command
The os-code status command errors if it tries to retreive the password from the code server pod before the build has complete. This results in some funky output
but the command performs as intended if the pod has completed its build.
