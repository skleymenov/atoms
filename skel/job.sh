#!/bin/bash
#
#
#SBATCH --partition=%PART%
#SBATCH --reservation=%RES%
#SBATCH --nodes=%NODES%
#SBATCH --ntasks-per-node=%TASKS%
#SBATCH --time=%TIME%
#SBATCH --job-name=%NAME%
#SBATCH --workdir=%WDIR%
#SBATCH --error=output/%j_%N.err
#SBATCH --output=output/%j_%N.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%MAIL%

export I_MPI_EAGER_THRESHOLD=128000
#          This setting may give 1-2% of performance increase over the
#          default value of 262000 for large problems and high number of cores

date

echo -n "This run was done on: "
date

# Capture some meaningful data for future reference:
echo -n "This run was done on: "
date
echo "HPL.dat: "
cat HPL.dat
echo "This script: "
cat job_offload.sh
echo "Environment variables: "
env 
echo "Actual run: "

srun ./xhpl 

echo -n "Done: "
date

cd output
BEST=`grep WC *.out | sort -k7 | tail -n1 | sed "s/\(^.*\):.*/\1/"`
WORST=`grep WC *.out | sort -k7 | head -n1 | sed "s/\(^.*\):.*/\1/"`

ln -ns $BEST best
ln -ns $WORST worst

