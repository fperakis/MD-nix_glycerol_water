# Simulating a glycerol water mixture

-------------------------

# useful intstructions
https://gcm.upc.edu/en/members/luis-carlos/molecular-dynamics

# used the mol2 structure from zinc
# had to use SMILES to search in swissparam OCC(O)CO 
http://zinc.docking.org/substances/ZINC000000895048/

# uploaded to to swissparam to get the gromacs files
https://www.swissparam.ch/

# got the CHARMM foreciled files
http://mackerell.umaryland.edu/charmm_ff.shtml

------------------------
#activate nix
nix-shell -p qchem-unstable.gromacs

# make box
gmx insert-molecules -ci mol/glyc.pdb -nmol 230 -box 5 5 5 -o glycerol_box.gro

# solvate
gmx solvate -cp glycerol_box -cs tip4p -o glycerol_solv.gro -p topol.top -maxsol 770

(after this step check topology file - may need to add a new line after SOL)

# prepare minimisation
gmx grompp -f mdp/min.mdp -c glycerol_solv.gro -p topol.top -o em.tpr 
# modify slurm_cuda for em
sbatch slurm/cuda 

#analyse
gmx energy -f em.edr -o em_potential.xvg

# NVT
gmx grompp -f mdp/nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
# modify slurm_cuda for NVT
sbatch slurm/cuda

#analyse
gmx energy -f nvt.edr -o nvt_temperature.xvg

# NPT
gmx grompp -f mdp/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
# modify slurm_cuda for NPT
sbatch slurm/cuda

#analyse
gmx energy -f npt.edr -o npt_volume.xvg

# MD
gmx grompp -f mdp/md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
# modify slurm_cuda for MD
sbatch slurm/cuda

# analyse
gmx energy -f md_0_1.edr -o md_density.xvg

# make molecules whole
gmx trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_noPBC.xtc -pbc mol 

# extend simulation (by 100ns)
gmx convert-tpr -s md_0_1.tpr -extend 100000 -o md_0_1.tpr
sbatch slurm/slurm_cuda_continue

------------------------

