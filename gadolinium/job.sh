#!/bin/bash
#
#
#SBATCH --partition=large
#SBATCH --reservation=stress
#SBATCH --nodes=64
#SBATCH --ntasks-per-node=1
#SBATCH --time=06:30:00
#SBATCH --job-name=gadolinium
#SBATCH --workdir=/homeb/zam/sk/atoms/gadolinium
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
cat job.sh
echo "Environment variables: "
env 
echo "Actual run: "

# env I_MPI_DEBUG=5 mpirun -np 64 -machinefile $HOME/hostfile ./xhpl
# env I_MPI_DEBUG=5 PSP_DEBUG=1 PBS_NODEFILE=$HOME/hostfile /opt/parastation/bin/mpiexec -x -n 64 ./xhpl
srun ./xhpl

echo -n "Done: "
date

cd output
BEST=`grep WC *.out | sort -k7 | tail -n1 | sed "s/\(^.*\):.*/\1/"`
WORST=`grep WC *.out | sort -k7 | head -n1 | sed "s/\(^.*\):.*/\1/"`
echo $BEST
echo $WORST

ln -fs $BEST best
ln -fs $WORST worst

