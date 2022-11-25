#!/usr/bin/env nix-shell
#!nix-shell -i bash /cfs/home/fpera/gmx_simulations/15_water_glyc/MD-nix_glycerol_water/nix_files/cpu.nix
#
#SBATCH -n64
#SBATCH -pcops
#SBATCH -Jgromacs
#SBATCH -c 2
#
#nix-sdist `which gmx_mpi`

#export OMP_NUM_THREADS=1

#Automatic selection of ntomp argument based on "-c" argument to sbatch
if [ -n "$SLURM_CPUS_PER_TASK" ]; then
    ntomp="$SLURM_CPUS_PER_TASK"
else
    ntomp="1"
fi

# Make sure to set OMP_NUM_THREADS equal to the value used for ntomp
# # to avoid complaints from GROMACS
 export OMP_NUM_THREADS=$ntomp

echo ' mpirun gmx_mpi mdrun -ntomp $ntomp -deffnm' $1
#mpirun gmx_mpi mdrun -ntomp $ntomp -deffnm $1
