#!/bin/csh -f 

if($#argv < 5) then
    goto usage
endif


goto start

usage:
echo "This is Check Point Web Visualization Tool"
echo "Usage: cpdb2html <cpdb2html_path> <output_directory> <SmartCenter_Server> <admin_name | certificate> <password> [-o output_file_name] [ -m host_name] [-gr] [-go]"
echo "Where:"
echo "cpdb2html_path         - Web Visualization Tool's root directory."
echo "output_directory       - The path where the html file will be written to."
echo "SmartCenter_Server     - Name or IP address of the management server"
echo "                        (in Provider-1 it should be the virtual IP associated with the CMA)."
echo "admin_name|certificate - User name of the SmartCenter administrator, or full path of certificate file."
echo "password               - Administrator's password, or certificate's password."
echo "-o output_file_name    - The name of the HTML file that will be generated"
echo "                         (default file name is '1.html')."
echo "-m host_name           - The name of the module one wishes to see its database"
echo "-gr                    - For Check Point Provider-1 users only."
echo "                         When the -gr option is set the output will include"
echo "                         customer rules only (no global rules)."
echo "-go                    - For Check Point Provider-1 users only."
echo "                         When the -go option is set the output will include"
echo "                         customer objects only (no global objects)."

@ EXIT_CODE=-1
goto quit

start:
if(!(-d $1 )) then
    echo ${1}: no such directory.
    goto usage
endif

if(!(-d $2)) then
    echo ${2}: no such directory.
    goto usage
endif


set CUR_PATH=$1
set TARGET_DIR=$2
set HOST=$3
set USERNAME=$4
set PASSWORD=$5
set TEMP_DIR=${2}/temp
set XSLDIR=${CUR_PATH}/xsl
set XSLFILE=stripped_html.xsl
set BASE_XML_FILE=stripped_html.xml
set OUTPUT_FILE=1.html
set POLICY_NAME=standart
set CURRENT_POLICY=-c
set NO_G_RULES
set NO_G_OBJECTS

@ I = 6
while($I <= $#argv)

   switch ($argv[$I])

    case -o:
		@ I ++
		set OUTPUT_FILE=$argv[$I]
		breaksw
    case -p:
		@ I ++
		set POLICY_NAME=$argv[$I]
		breaksw
    case -s:
		@ I ++
		set XSLDIR=$argv[$I]
		@ I ++
		set XSLFILE=$argv[$I]
		@ I ++
		set BASE_XML_FILE=$argv[$I]
		breaksw
	case -m:
		@ I ++
		set CURRENT_POLICY="-m $argv[$I]"
		breaksw
	case -go:
		set NO_G_OBJECTS=-go
		breaksw
	case -gr:
		set NO_G_RULES=-gr
		breaksw	
	endsw
    @ I ++
end

#echo CUR_PATH = $CUR_PATH
#echo TARGET_DIR = $TARGET_DIR
#echo HOST = $HOST
#echo USERNAME = $USERNAME
#echo PASSWORD = $PASSWORD
#echo TEMP_DIR = $TEMP_DIR
#echo MODULENAME = MODULENAME
#echo XSLDIR = $XSLDIR
#echo XSLFILE = $XSLFILE
#echo BASE_XML_FILE = $BASE_XML_FILE
#echo OUTPUT_FILE = $OUTPUT_FILE
#echo POLICY_NAME = $POLICY_NAME


#create a temporary directory
set TEMP=$TEMP_DIR
@ I=0
while(-e $TEMP_DIR)
    @ I ++
    set TEMP_DIR=${TEMP}${I}
    echo $TEMP_DIR
end
mkdir $TEMP_DIR

${CUR_PATH}/cpdb2web -s ${HOST} -u ${USERNAME} -p ${PASSWORD} -o ${TEMP_DIR} ${CURRENT_POLICY} ${NO_G_RULES} ${NO_G_OBJECTS} -x
if(${status} != 0) then
	@ EXIT_CODE=${status}
    echo failed to get data from management server ${HOST}
    goto finish
endif

\cp -f ${XSLDIR}/${XSLFILE} ${TEMP_DIR}
\cp -f ${XSLDIR}/${BASE_XML_FILE} ${TEMP_DIR}

setenv LD_LIBRARY_PATH ${CUR_PATH}:${LD_LIBRARY_PATH}
${CUR_PATH}/Xalan -o "${TARGET_DIR}/${OUTPUT_FILE}" "${TEMP_DIR}/${BASE_XML_FILE}" "${TEMP_DIR}/${XSLFILE}"
@ EXIT_CODE=${status}

finish:
\rm -f $TEMP_DIR/*
\rmdir $TEMP_DIR

quit:
exit ($EXIT_CODE)

