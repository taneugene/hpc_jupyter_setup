#Make sure that you cloned the git directory to your scratch space. 
scratch=$(pwd)
user=$(whoami)

# Go to scratch space for the sscc group
cd ${scratch}

# if the directory isn't there make it
mkdir ${user}

# change security 
chmod 2700 ${user}

# add a symbolic link
cd ~
ln -s ${scratch}/${user} scratch

# Set your default environment dircectory to be scratch
# https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#specify-environment-directories-envs-dirs
# Append scratch to conda rc

# we don't use module load because there are errors in install that conda update conda would fix. 
module load anaconda/3-5.1 

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -p ~/scratch/miniconda
eval "$(/rigel/sscc/users/pt2535/miniconda/bin/conda shell.bash hook)"
conda init
conda config --add channels conda-forge
# breaks with conda 3-5.1, need this for rasterio
conda config --set channel_priority strict
conda config --add envs_dirs ~/scratch/envs
conda create -n susdev gdal scipy seaborn requests beautifulsoup4 jupyterlab rasterio -y
conda activate susdev
jupyter notebook --generate-config
jupyter notebook password

