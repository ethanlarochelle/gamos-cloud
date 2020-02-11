#!/bin/bash
# Standard function to print an error and exit with a failing return code
error_exit () {
  echo "${BASENAME} - ${1}" >&2
  exit 1
}

if [ -z "${BATCH_FILE_S3_URL}" ]; then
  error_exit "BATCH_FILE_S3_URL not set. GAMOS will not run without object to download."
fi

scheme="$(echo "${BATCH_FILE_S3_URL}" | cut -d: -f1)"
if [ "${scheme}" != "s3" ]; then
  error_exit "BATCH_FILE_S3_URL must be for an S3 object; expecting URL starting with s3://"
fi

# Check that necessary programs are available
which aws >/dev/null 2>&1 || error_exit "Unable to find AWS CLI executable."

SEED=$1    ## RANDOM SEED NUMBER ex. 1111
DEPTH=$2   # DEPTH OF PtG4 INCLUSION
NEV=$3    ## NUMBER OF EVENTS PER JOB
BASEINPUTFILE=$4 ## SPECIFY transport.in FILE
SUFFIX="_"$DEPTH"_"$SEED

BUCKET="$(dirname "$BATCH_FILE_S3_URL")"

mkdir ~/gamos_run
mkdir ~/gamos_run/6MV_NF$SUFFIX
cp ./* ~/gamos_run/6MV_NF$SUFFIX/
cd ~/gamos_run/6MV_NF$SUFFIX
###TO USE THIS SCRIPT, TYPE, FOR EXAMPLE: sh sendjobs SEED ENERGY N csv transport.in
source /docker_gamos/gamos/GAMOS.6.1.0/config/confgamos.sh
### SET THE VARIABLES TO BE READ FROM THE COMMAND LINE

### START THE LOOP OF THE NUMBER OF JOBS
nj=0

echo $BASEINPUTFILE
echo $PWD

### COPY THE INPUT FILE INTO A NEW ONE (SO THAT YOU CAN KEEP TRACK OF THE DIFFERENT FILES THAT ARE RUN)
NEW_INPUTFILE="transport"$SUFFIX".in"
echo " The new input file = " $NEW_INPUTFILE
### SUBSTITUTE IN THE NEW INPUT FILE THE VARIABLES FROM THE COMMAND LINE
awk -v SEED=$SEED -v DEPTH=$DEPTH -v NEV=$NEV -v SUFFIX=$SUFFIX '{
    if($1=="/gamos/random/setSeeds") {printf("%s %s %s\n", $1, SEED, SEED)}
    else if($2=="GmAnalysisMgr:FileNameSuffix") {printf("%s %s %s%s\n", $1, $2, $3, SUFFIX)}
    else if($2=="GmGeometryFromText:FileName") {printf("%s %s world_%s.geom\n", $1, $2, DEPTH)}
    else if($1=="/run/beamOn") {printf("%s %s\n", $1, NEV)}      
    else { print $0 }
}' $BASEINPUTFILE > $NEW_INPUTFILE

NEW_WORLDGEOM="world_"$DEPTH".geom"
Z_POS=$(python -c "print('{:1.2f}'.format(20.0-$DEPTH))")
echo "New Z depth: "$Z_POS

awk -v Z_POS=$Z_POS '{
	if($1==":PLACE" && $2=="tumor_inclusion") {printf("%s  %s  %s  %s  %s  %s  %s  %s*mm", $1, $2, $3, $4, $5, $6, $7, Z_POS)}
	else { print $0 }
}' world.geom > $NEW_WORLDGEOM


## RUN JOB IN FOREGROUND
log_file="gamos"$SUFFIX".log"

## RUN JOB IN FOREGROUND
gamos $NEW_INPUTFILE 2>&1 | tee $log_file

aws s3 cp ~/gamos_run/ $BUCKET --recursive
rm -r ~/gamos_run/
