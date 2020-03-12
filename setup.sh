# Installs miniconda and an environment called susdev

# Conda setup

# Download miniconda to home
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
# run miniconda, install in your scratch directory
bash ~/miniconda.sh -p ~/scratch/miniconda
# add conda to your path 
eval "$(/rigel/sscc/users/pt2535/miniconda/bin/conda shell.bash hook)"
# set conda to run every time you login
conda init
# add a channel (with geospatial libraries) and prioritize it
conda config --add channels conda-forge
# this breaks with conda 4.5, so this is why we install miniconda manually
conda config --set channel_priority strict
# Set your default environment dircectory to be scratch
# IMPORTANT: we need the scratch symbolic link in the home directory as in the last section!
# https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#specify-environment-directories-envs-dirs
conda config --add envs_dirs ~/scratch/envs

# Working Environment Setup 
# Install conda with some geospatial and webscraping labs. The conda environment will be called 'susdev'
conda create -n susdev gdal scipy seaborn requests beautifulsoup4 jupyterlab rasterio -y
# This should change `base` in your command line to susdev, showing that those packages are loaded instead of the miniconda ones. 
conda activate susdev
# Install jupyter config
jupyter notebook --generate-config
# Add kernel to jupyter spec
jupyter kernelspec install ~/scratch/envs/susdev/ --user
