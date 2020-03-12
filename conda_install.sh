#We don't module load because there are errors in install that conda update conda would fix. 
# module load anaconda/3-5.1 

# Make sure that you run this file from your scratch space. 
scratch=$(pwd)
user=$(whoami)
# Downloads miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
# bash runs the script but installs it in your scratch space
bash ~/miniconda.sh -p ~/scratch/miniconda
# Adds conda to your path
eval "$/rigel/sscc/users/pt2535/miniconda/bin/conda shell.bash hook)"
# Sets up conda to always run whenever you access a new node
conda init
# Adds the conda-forge channel to get access to newer and more obscure packages
conda config --add channels conda-forge
# breaks with conda 3-5.1, need this for rasterio
# prioritizes conda-forge over the anaconda distribution
conda config --set channel_priority strict
# Makes your scratch space where you store environments (IMPORTANT)
conda config --add envs_dirs ${scratch}/envs
# Make a new environment called susdev with some common data science and geospatial libraries already installed
conda create -n susdev gdal scipy seaborn requests beautifulsoup4 jupyterlab rasterio -y
# Activate the enviroment
conda activate susdev
# Generate jupyter notebook config
jupyter notebook --generate-config
# Set up a password for Jupyter
jupyter notebook password
