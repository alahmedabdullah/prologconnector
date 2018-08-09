GNU PROLOG Smart Connector for Chiminey
=======================================

"PROLOG Smart Connector for Chiminey" allows payload parameter sweep over prolog models which facilitates scheduling computes over the cloud for parallel execution.

Once "PROLOG Smart Connector" is activated in Chiminey, Chiminey portal then allows to configure and submit a PROLOG job for execution.

PROLOG Smart Connector(SC) Core Function
-----------------------------------
A payload (http://chiminey.readthedocs.io/en/latest/payload.html#payload) provides the core functionality of PROLOG SC. The payload structure of PROLOG SC is as following:

```
payload_prolog/
|--- bootstrap.sh
|--- process_payload
|    |---main.sh
     |---run.sh_template
```
The PROLOG SC will build GNU PROLOG binary from GNU Prolog distribution file. During activation of PROLOG SC, the user is required to download appropriate version of Prolog and place in the 'package' directory of Chiminey install. Please refer to installation steps described in https://github.com/alahmedabdullah/prologconnector/blob/master/SETUP.md file.

"bootstrap.sh" installs all dependencies required to prepeare job execution environment for PROLOG. Following is the content of "bootstrap.sh" for PROLOG SC:    

```
#!/bin/sh
# version 2.0

WORK_DIR=`pwd`

PROLOG_PACKAGE_NAME=$(sed 's/PROLOG_PACKAGE_NAME=//' $WORK_DIR/package_metadata.txt)
mv $WORK_DIR/$PROLOG_PACKAGE_NAME /opt
cd /opt

tar -zxvf $PROLOG_PACKAGE_NAME
prolog_exe=$(whereis gprolog 2>&1 | awk '/gprolog/ {print $2}')
mv $prolog_exe /usr/local/bin

cd $WORK_DIR
```

The "main.sh" is a simple script that executes a shell script "run.sh". It also passes on commmand line arguments i.e. INPUT_DIR and OUTPUT_DIR to "run.sh". Following is the content of "main.sh" for PROLOG SC:

```
#!/bin/sh

INPUT_DIR=$1

cp run.sh $INPUT_DIR/run.sh

RUN_DIR=`cd "$(dirname "$0")" && pwd`

echo $RUN_DIR > mainsh.output

sh $RUN_DIR/run.sh $@

# --- EOF ---

```
The "main.sh" executes "run.sh". "cli_parametrs.txt_template" that is provied in "input_gprolog" along with the PROLOG SC install. The template "cli_parameters.txt_template" need to be placed in the "Input Location" which is specified in "Create Job" tab of the Chiminey-Portal. Following is the content of "run.sh" that executes a given PROLOG job :
"

```
#!/bin/sh

INPUT_DIR=$1
OUTPUT_DIR=$2

cd $INPUT_DIR


gprolog $(cat cli_parameters.txt) &> runlog.txt


cp ./*.txt ../$OUTPUT_DIR

# --- EOF ---

```
All the template tags specified in  the gprolog_command_line.txt_template file will be internally replaced by Chiminey with corresponding values that are passed in from "Chiminey Portal" as Json dictionary. This "gprolog_command_line.txt_template" is  also renamed to ""gprolog_command_line.txt" with all template tags replaced with corresponding values. Following is the content of ""gprolog_command_line.txt_template" 
```
{{model_file_name}}
```
So the "Payload parameter sweep", which is a JSON dictionary to be passed in from Chiminey-Portal's "Create Job" tab:

```
{ "model_file_name" :  [ "prolog_model_file_name" ] }

```
Note that the "model_file_name" is the tag name defined in the gprolog_command_line.txt_template file and will be replaced by appropiate value passed in through JSON dictionary .

The Input Directory
-------------------
A connector in Chiminey system specifes a "Input Location" through "Create Job" tab of the Chimney-Portal. Files located in the "Input Location" directory is loaded to each VM for cloud execution. The content of "Input Location" may vary for different runs. Chiminey allows parameteisation of the input envrionment. Any file with "_template" suffix located in the input directory is regarded as template file. Chiminey internally replaces values of the template tags based on the "payload parameter sweep" provied as Json Dictionary from "Create Job" tab in the Chiminey portal.

Configure, Create and Execute a PROLOG Job
------------------------------------------
"Create Job" tab in "Chiminey Portal" lists "prolog" form for creation and submission of prolog job. "_prolog" form require definition of "Compute Resource Name" and "Storage Location". Appropiate "Compute Resource" and "Storage Resource" need to be defined  through "Settings" tab in the "Chiminey portal".

Payload Parameter Sweep
-----------------------
Payload parameter sweep for "PROLOG Smart Connector" in Chiminey System may be performed by specifying appropiate JSON dictionary in "Payload parameter sweep" field  of the "prolog" form. An example JSON dictionary to run internal sweep for the "test.andl" could be as following:

```
{"model_file_name" :  [ "prolog_model_file_name_1", "prolog_model_file_name_2", "prolog_model_file_name_3" ] }
``` 
Above would create three individual process. To allocate maximum two cloud VMs - thus execute two PROLOG job in the same VM,  input fields in "Cloud Compute Resource" for "sweep_prolog" form has to be:

```
Number of VM instances : 2
Minimum No. VMs : 1
```
