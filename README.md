# High Performance Computing using Habanero for SusDev PhD students

## Table of Contents
1. [Introduction](#introduction)
2. [Printouts](#some-printouts-r-based)
3. [Why run Jupyter on Habanero](#why-run-jupyter-on-habanero)
4. [Setup without Jupyter](#setup-habanero-without-jupyter)
5. [Setup with Jupyter](#setup-habanero-with-jupyter)
6. [Design-Notes](#design-notes)

## Introduction

This fork of Claire's repository but adds to it by providing instructions for working on Jupyter, GPUs, adding R and julia kernels. 

Habanero is a High Performance Computing (HPC) cluster that grants Columbia researchers and students access to shared supercomputing resources, i.e. a network of computers with professional computational capabilities. Use it when you are 
* You have a heavy computing 'job' or that is slowing down your personal computer, requires more memory/data than your personal computer can accomodate, or just would take too long.  (typically 1x 8GB node)
* Running a Monte Carlo simulation, one job per parameter setting (i.e. nx4GB nodes)
* Using a GPU for Neural network applications (i.e. GPU + cuda)
* Running a server (e.g. Jupyter!) 

Some HPC basics: 
* Get Access to Habanero by asking Doug or asking Eric Vlach at ISERP. Eric would add you to the Social Science Computing Committee (sscc) group.
* You will be interacting with a remote server: we do that through a Unix-shell, using the SSH (Secure Shell) Protocol.  For Mac users, use the 'Terminal' app. For Windows users, you will need to [SSH via PuTTY](https://www.ssh.com/ssh/putty/windows/).
* When you log in, you will typically see this Very Important Notice, so when you login you will either need to 'interactively' srun to a node (typically small one-off jobs,  *including while installing packages*) or sbatch (wrap a script that does all processing you want and saves all the output to disk in a wrapper) to send your script to a node.
    > ATTENTION ATTENTION!
Very Important Notice:
You are now on a login node. For any extended processing, please launch Slurm 
jobs via 'sbatch' and 'srun'.
Running processes longer than a few seconds and/or involving more than one core 
is STRICTLY FORBIDDEN on this node.
Users who break the above rule abuse this shared resource, cause delays for 
other cluster users, end up on our watch list - and eventually will get 
penalized. For more details, see:
[https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Submitting
+Jobs#Habanero-SubmittingJobs-RestrictionsonLoginNodeUsage](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Submitting+Jobs#Habanero-SubmittingJobs-RestrictionsonLoginNodeUsage)
* The more resources you are asking for, the more time it will take Habanero to get your 'job' done (because you will be put lower on the priority list -- many people are sending jobs to the cluster at the same time and the cluster needs to  queue/order those.) Typically a 4GB job takes less than a second to allocate. A 8GB job can be a few minutes.  More than that can take up to half an hour. 

## Some Printouts (R based)
* An **overview of the main steps** to interact with Habanero: [How_to_use_Habanero.pdf](https://github.com/ClairePalandri/HABANERO-HPC_material/blob/master/How_to_use_Habanero.pdf)
* A **stand-alone tutorial showing how to run a simple .R script from A to Z** on the cluster: folder [Tutorial_28Feb2020](https://github.com/ClairePalandri/HABANERO-HPC_material/blob/master/Tutorial_28Feb2020)
* **Cheatsheets**
  * a [cheatsheet with SBATCH commands](https://github.com/ClairePalandri/HABANERO-HPC_material/blob/master/cheatsheet_SBATCH-commands.pdf)
  * a [cheatsheet with ssh commands](https://github.com/ClairePalandri/HABANERO-HPC_material/blob/master/cheatsheet_SSH-commands.pdf)

## Why run Jupyter on Habanero?

[Jupyter](https://jupyter.org/) is a server-based IDE for hosting notebooks, which have become a great platform for hosting data, code, but especially for doing exploratory or visual work. Running it on the HPC is beneficial relative to running a jupyter notebook locally because you can:
 - use lots of processing power if needed (GPUs, parallelization)
 - access the server from school computers to give presentations!
 - keep it running over night without consuming your power or interrupting your daily flow.

This repo combines the following resources:
 - my own setup, 
 - Claire's presentation (forked) 
 - guides from the [Research Computing in Natural Sciences course](https://rabernat.github.io/research_computing/introduction-to-the-habanero-hpc-cluster.html) and the [Eaton Lab](https://eaton-lab.org/articles/Eaton-lab-HPC-setup/)
 - [official Habanero documentation](https://confluence.columbia.edu/confluence/display/rcs/Habanero+HPC+Cluster+User+Documentation) 
    
## Setup Habanero without Jupyter 
Basics (without Jupyter):
* [How_to_use_Habanero.pdf](https://github.com/ClairePalandri/HABANERO-HPC_material/blob/master/How_to_use_Habanero.pdf)
* [Habanero documentation](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Getting+Started)

## Setup Habanero with Jupyter

#### Preamble

NB: Replace <group> or with your account (e.g. cwc, sscc) and <user> or <UNI> or ${UNI} with your uni throughout this walkthrough. Replace ${scratch} or <scratch> with your path /rigel/<group>/users/ 
`<>` brackets mean you have to change them. `${}` means that if you set up variables then you can copy and paste the script including them inside. 

#### Access Habanero
 * You are entitled to a free account. Go here to submit [a request form](https://columbia.servicenow.com/cu?id=sc_cat_item_cu&sys_id=9876ecc213bd160006c376022244b00a) for free HPC access.
 * You can ask to be added as a new user to an existing HPC group (e.g.: cwc; sipa). Current HPC customers can request access to their HPC group for a new user by emailing rcs@columbia.edu (e.g.: to be added as a new user to the SIPA group, ask Doug to request that access for you)
 * (recommended) Eric Vlach is at ISERP and can give you access to the Social Science Computing Committee (sscc) group.  They have much more space than SIPA...

#### SSH into Habanero
SSH into habanero (windows requires the [PuTTY SSH client](https://www.ssh.com/ssh/putty/windows))
 >`ssh <UNI>@habanero.rcs.columbia.edu`
 * You can set up the command to just be `ssh habanero`, by [setting up an ssh alias](https://www.howtogeek.com/75007/stupid-geek-tricks-use-your-ssh-config-file-to-create-aliases-for-hosts/).
 * [(optional for github users) Add github keys to habanero(https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh). I tend to commit everything back and forth (apart from data which I exclude using [.gitignore](https://git-scm.com/docs/gitignore)) to sync my computer and habanero.
 
#### Scratch Storage
When you login to Habanero, you will be at your home directory `~` on a login node (holmes, watson). So you should see something like this:
`[pt2535@holmes ~]$`
This directory has 10GB. Appropriate for smaller files: docs, source code, scripts, but in general it's not enough. 

You also have your group account's scratch storage `/rigel/<group>`. It's known as scratch storage because it isn't backed up! Ex: /rigel/cwc and /rigel/sscc has size = 20 TB, no default User Quota.
 
We want to set up a 'personal folder' in the group directory that other people in the group can't access, delete or modify by changing their permission settings. Furthermore we want to make it easy to access (we'll create a shortcut known as a [symbolic link](https://en.wikipedia.org/wiki/Symbolic_link)) because 10GB runs out really quickly. 

```bash
# Navigate to your group accounts scratch storage
cd /rigel/<group>/users 
ls -l # notice that some people's security settings mean you can access their files.
# Sets up local variables 
scratch=$(pwd)
user=$(whoami)
# Make a directory isn't there make it
mkdir ${user}
# Download this directory to it
git clone git@github.com:taneugene/hpc_jupyter_setup.git
# Remove group access
chmod 2700 ${user}
# add a symbolic link to your home directory
ln -s ${scratch}/${user} ~/scratch
# Check that your symbolic link works! You should see this repository
cd ~/
cd scratch
```

#### Miniconda and Jupyter installation
We use miniconda as our package manager.  It's the easiest way to manage, share and distribute your computing environments for python. We don't use the module on slurm because it's out of date, causes some bugs when installing from conda-forge, and we can't update it ourselves.

Now we're going to do some computationally heavy installs. We don't want to install stuff on the login node because of the 'Very Important Notice' above. So we are going to use an [Interactive Job](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Submitting+Jobs#Habanero-SubmittingJobs-InteractiveJobs) to install. 

From the link:
> To submit an interactive job, run the following, where "<ACCOUNT>" is your group's account name.   
`srun --pty -t 0-01:00 -A <ACCOUNT> /bin/bash`

What this means is that you'll have an hour to run bash on this account. I like to not remember this, so I save it as a script ([sbash.sh](./sbash.sh)), which I put in my root directory `mv ~/scratch/hpc_jupyter_setup/sbash.sh ~` so I can always switch from login to interactive by typing just `~/sbash.sh'. You may have to give the script permission to execute `chmod 755 ~/sbash.sh`. I remove the walltime. If you're not on group sscc, you may need to modify that script. 
    
Running the srun script, you should notice that the bar is different: `[pt2535@node059 ~]$`. Now you're on a compute node! 

Now, you can copy over the [setup.sh](./setup.sh) script and just run it, or you can run each line by yourself:

```bash
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
```

#### Optional: Adding R and Julia Kernels to your jupyter notebook
    
```bash
# Create a rpackages directory in envs
cd ~/scratch/envs
mkdir rpackages
# Load the latest version of R from modules
module load R/3.6.2
# Run an install packages script (including IR kernel)
# Rscript ~/scratch/hpc_jupyter_setup/Tutorial_28Feb2020/install_Rpackages_HABANERO.R 
    
R
# From within R
.libPaths("~/scratch/envs/rpackages")
install.packages(c('repr', 'IRdisplay', 'IRkernel','pdbZMQ'), type = 'source')
IRkernel::installspec()
```
    
Julia to be added. Matlab in testing.

#### Accessing Jupyter from your local machine. 
Now you have setup jupyterlab, you want to run a server!

You need to set a password so not everyone can access your server. You can do this by typing in `jupyter notebook password` and following the interactive instructions. You can see some other methods [here](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#automatic-password-setup)
    
Now you want to copy [./sjupyter.sbatch](sjupyter.sbatch) to home. You will want to edit it suing vim or nano following the sbatch [cheatsheet](https://github.com/taneugene/hpc_jupyter_setup/blob/master/cheatsheet_SBATCH-commands.pdf), most likely for the memory (default 4GB), account (replace `sscc` with your `<group>`), and choose between Jupyterlab or jupyter notebook by commenting or uncommenting the last line.
    
```bash
# copy the sjupyter script to home directory    
cd ~
cp ~/scratch/hpc_jupyter_setup/sjupyter.sbatch ~
# submit an sbatch script that wraps your jupyter server
sbatch ~/sjupyter.sbatch
```
    
Now you've submitted a 'job' to slurm. At some point it will be fulfilled. You can check the status by running `squeue -u <user>`. You can also copy squeue.sh from this repo to your home directory and just run `~/squeue.sh` from anywhere at any time to check the status.
    
Once your job is running (no longer pending), you should see a log in your home directory. View it (`cat node<###>-<jobid>_jupyter.log`) and scroll to the top, and there some instructions.
    
On Mac, find this line that fits this format and copy and paste it. 
`ssh -N -L ${port}:${node}:${port} ${user}@habanero.rcs.columbia.edu`
On your local terminal, (just open a new tab on terminal), paste and run it!
The -L binds the port, and the -N just forwards the port.

Then find the line with:
```
'Use a Browser on your local machine to go to:
localhost:${port}  (prefix w/ https:// if using password)'
Enter that into your web browser and you should be prompted for your password, and you should have Jupyter lab up and running
```

#### Shutting down
Whenever you finish using Jupyter, save your work then run ./squeue.sh or `squeue -u <UNI>`. You should see a job number. Then finish your job by running `scancel JOBID`.

If you want to shut down the interactive job, just type `exit` onto the command line. 

## Design notes
This setup is geared towards Sustainable Development PhD students.  What that means is that I've optimized  for usage of:
* Large Datasets
    * Habanero only provides 10GB of private space, so we minimize use of that wherever possible, so we utilize the scratch space wherever possible.
    * So we installs environment(s) in the scratch space.   
    * We use miniconda in the home directory because conda 4.8 fixes a lot of bugs related to config and the latest version of conda on [modules](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Software) is 4.4
* Working with geopspatial and other software languages
    * GDAL (the base geospatial library for nearly anything) notoriously breaks installations if you don't do it right off the bat, so we do that when installing.
    * People use matlab, R, julia, python, and we want to set them up to be interoperable on jupyter. We'll use the julia version from modules, follow Claire's work on R but add IRkernel, and will figure out matlab eventually...
