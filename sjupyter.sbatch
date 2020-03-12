#!/bin/bash

#SBATCH --account=sscc # Account name is needed 
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --mem-per-cpu 4G
#SBATCH --time 1-0:00:00
#SBATCH --job-name jupyter-notebook
#SBATCH --output %N-%J_jupyter.log

# get tunneling info
# XDG_RUNTIME_DIR=""
unset XDG_RUNTIME_DIR
port=$(shuf -i8000-9999 -n1)
node=$(hostname)
user=$(whoami)
# This may be wrong, this only works on the Yale servers
cluster=$(hostname -f | awk -F"." '{print $2}')

# print tunneling instructions jupyter-log
echo -e "
For more info and how to connect from windows, see:
   https://docs.ycrc.yale.edu/clusters-at-yale/guides/jupyter/
   https://rabernat.github.io/research_computing/running-jupyter-notebooks-on-habanero.html
   https://confluence.columbia.edu/confluence/display/rcs/Habanero+HPC+Cluster+User+Documentation

MacOS or linux terminal command to create your ssh tunnel
ssh -N -L ${port}:${node}:${port} ${user}@habanero.rcs.columbia.edu

Windows MobaXterm info
Forwarded port:same as remote port
Remote server: ${node}
Remote port: ${port}
SSH server: ${cluster}.habanero.rcs.columbia.edu
SSH login: $user
SSH port: 22

Use a Browser on your local machine to go to:
localhost:${port}  (prefix w/ https:// if using password)
"

# load modules or conda environments here
module load R/3.6.2 julia/1.3.1 matlab/2019b

# uncomment the following two lines to use your conda environment called notebook_env
# you must activate an environment with jupyter installed first, which will be used as the base environment
source activate susdev

# DON'T USE ADDRESS BELOW.
# DO USE TOKEN BELOW
# Set your password first following the instructions in jupyternotebook config
jupyter-lab --no-browser --port=${port} --ip=${node}
# jupyter-notebook --no-browser --port=${port} --ip=${node}

