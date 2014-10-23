#!/bin/bash
#
#
#SBATCH --partition=large
#SBATCH --reservation=stress
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:30:00
#SBATCH --job-name=hydrogen
#SBATCH --workdir=/homeb/zam/sk/atoms/hydrogen
#SBATCH --error=output/%j_%N.err
#SBATCH --output=output/%j_%N.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sergey.kleymenov@t-platforms.ru

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

ln -fs $BEST best
ln -fs $WORST worst

