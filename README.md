# MD-nix_lyso
An example of runing MD simulations using gromacs at Fysikum HPC. 
https://it.fysik.su.se/hpc/

The simulation includes 10 lysozyme molecules (~200mg/ml) in a 23%mol water/glycerol solution. 
Glycerol molecules are simulated using CGenFF, protein molecules with CHARMM36 and water with TIP4P-2005.
http://mackerell.umaryland.edu/charmm_ff.shtml

Gromacs packages are initialised using NixOS, see here. 
https://github.com/markuskowa/NixOS-QChem

-----

## Startup

Using ssh
```bash 
$ ssh -p 31422 username@sol-nix.fysik.su.se
```
and sshfs
```bash
$ sshfs -p 31422 username@sol-login.fysik.su.se:/cfs/home/username /local_path
```
and umount when finished
```bash
umount /local_path
```

## Run gmx interactively
activate nix for runing interactive tasks
```bash 
$ nix-shell -p qchem-unstable.gromacs
```
test by checking version
```bash 
$ gmx -version
```

## Run on GPU using slurm

submit job on cluster
```bash
$ sbatch slurm/cuda
```
check status
```bash
$ squeue -u username
```
