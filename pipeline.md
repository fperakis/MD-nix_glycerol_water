## Simulating a glycerol water mixture

### Useful links
https://gcm.upc.edu/en/members/luis-carlos/molecular-dynamics

* used the mol2 structure from zinc
* had to use SMILES to search in swissparam OCC(O)CO 
http://zinc.docking.org/substances/ZINC000000895048/

* uploaded to to swissparam to get the gromacs files
https://www.swissparam.ch/

* got the CHARMM foreciled files
http://mackerell.umaryland.edu/charmm_ff.shtml

------------------------
### Prepare system

* Activate `nix` shell (fix this to activate nix file instead)
 ```bash
nix-shell -p qchem-unstable.gromacs 
 ```
 
* Make simulation box: insert glycerols, solvate (after this step check topology file - may need to add a new line after SOL)
 ```bash
gmx insert-molecules -ci mol/glyc.pdb -nmol 320 -box 10 10 10 -o glycerol_box.gro
gmx solvate -cp glycerol_box -cs tip4p -o glycerol_solv.gro -p topol.top -maxsol 9680
 ```

------------------------
### Equilibrate energy, NVT, NPT

* Energy minimisation: modify slurm_cuda for em, prepare and submit em, analyse results
 ```bash
gmx grompp -f mdp/min.mdp -c glycerol_solv.gro -p topol.top -o em.tpr 
sbatch slurm/cuda 
gmx energy -f em.edr -o em_potential.xvg
 ```
 
* NVT - modify slurm_cuda for NVT, analyse results
 ```bash
gmx grompp -f mdp/nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx energy -f nvt.edr -o nvt_temperature.xvg
sbatch slurm/cuda
 ```

* NPT - modify slurm_cuda for NPT, analyse results
```bash
gmx grompp -f mdp/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
sbatch slurm/cuda
gmx energy -f npt.edr -o npt_volume.xvg
 ```
------------------------
### Run MD

* MD - modify slurm_cuda for MD, analyse results, make molecules whole
```bash
gmx grompp -f mdp/md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
sbatch slurm/cuda
gmx energy -f md_0_1.edr -o md_density.xvg
gmx trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_noPBC.xtc -pbc mol 
 ```
 
* extend simulation (by 100ns)
```bash
gmx convert-tpr -s md_0_1.tpr -extend 100000 -o md_0_1.tpr
sbatch slurm/slurm_cuda_continue
 ```
------------------------

