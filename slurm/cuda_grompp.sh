#!/usr/bin/env nix-shell
#!nix-shell -i bash /cfs/home/fpera/gmx_simulations/15_water_glyc/MD-nix_glycerol_water/nix_files/cuda.nix

# Number of tasks
#SBATCH -n1

# Number of threads per task
#SBATCH -c1

# requested number of GPUs
#SBATCH --gres gpu:a100:1
#SBATCH -pampere
#SBATCH -Jgromacs
#SBATCH -t0-01:00  # time limit: (D-HH:MM) 

# parse arguments
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -f)
      INPUT_FILE="$2"
      shift 
      ;;
    -c)
      STRUCTURE_FILE="$2"
      shift
      ;;
    -t)
      TRAJECTORY="$2"
      shift 
      ;;
    -o)
      OUTPUT_FILE="$2"
      shift 
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

# Automatic selection of ntomp argument based on "-c" argument to sbatch
if [ -n "$SLURM_CPUS_PER_TASK" ]; then
   ntomp="$SLURM_CPUS_PER_TASK"
else
   ntomp="1"
fi

# Make sure to set OMP_NUM_THREADS equal to the value used for ntomp
# to avoid complaints from GROMACS
export OMP_NUM_THREADS=$ntomp

echo "mpirun gmx_mpi grompp -f ${INPUT_FILE} -c ${STRUCTURE_FILE} -t ${TRAJECTORY} -p topol.top -o ${OUTPUT_FILE}"
#mpirun gmx_mpi grompp -f $1 -c $2 -t $3 -p topol.top -o $4
#mpirun gmx_mpi grompp -f mdp/md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr