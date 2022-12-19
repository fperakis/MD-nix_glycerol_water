{} :

let
  v = import ./versions.nix;
  nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/${v.nixpkgs}.tar.gz";
  overlay = builtins.fetchTarball "https://github.com/markuskowa/NixOS-QChem/archive/${v.qchem}.tar.gz";

  pkgs = import nixpkgs {
    config = {
      allowUnfree = true;
      qchem-config = {
       optAVX = true;
      };
    };
    overlays = [
      (self: super: { cudatoolkit = super.cudatoolkit_11; })
      (import "${overlay}/overlays/cuda.nix")
      (import "${overlay}/overlay.nix")
    ];
  };

  nvidiaVersion = "465.19.01";

  nixGL = (pkgs.qchem.nixGL {
    inherit nvidiaVersion pkgs;
  }).nixGLNvidia;

in pkgs.mkShell {
  buildInputs = with pkgs; [
    # CUDA MPI version
    nixGL qchem.gromacsCudaMpi
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=$(nixGLNvidia-${nvidiaVersion} printenv LD_LIBRARY_PATH):$LD_LIBRARY_PATH

    if [ -z $SLURM_CPUS_PER_TASK ]; then
      export OMP_NUM_THREADS=1
    else
      export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
    fi

    export GMX=gmx_mpi
  '';
}
