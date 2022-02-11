# MD-nix_lyso
An example of runing MD simulations using gromacs at Fysikum HPC. 
https://it.fysik.su.se/hpc/

Here is simulated several lysozyme molecules in water/glycerol mixture.

The packages are initialised using NixOS, see here. 
https://github.com/markuskowa/NixOS-QChem

-----

## USAGE

### startup

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

### run gmx interactively
activate nix for runing interactive tasks
```bash 
$ nix-shell -p qchem-unstable.gromacs
```
test by checking version
```bash 
$ gmx -version
```

### run on GPU using slurm

submit job on cluster
```bash
$ sbatch slurm/cuda_test
```
check status
```bash
$ squeue -u username
```
