# High Performance Computing using Habanero for SusDev PhD students

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
 
This setup is geared towards Sustainable Development PhD students.  What that means is that we'll account for usage of:
* Large Datasets
    * Habanero only provides 10GB of private space, so we minimize use of that wherever possible, so we utilize the scratch space wherever possible.
    * So we installs environment(s) in the scratch space.   
    * We use miniconda in the home directory because conda 4.8 fixes a lot of bugs related to config and the latest version of conda on [modules](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Software) is 4.4
* Working with geopspatial and other software languages
    * GDAL (the base geospatial library for nearly anything) notoriously breaks installations if you don't do it right off the bat, so we do that when installing.
    * People use matlab, R, julia, python, and we want to set them up to be interoperable on jupyter. We'll use the julia version from modules, follow Claire's work on R but add IRkernel, and will figure out matlab eventually...
    
## Setup Habanero with Jupyter 
Basics (without Jupyter):
* [How_to_use_Habanero.pdf](https://github.com/ClairePalandri/HABANERO-HPC_material/blob/master/How_to_use_Habanero.pdf)
* [Habanero documentation Getting Started](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Getting+Started)

1. Set up ssh
* [(optional) Add github keys to habanero(https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)
* [(optional) Set up an ssh alias](https://www.howtogeek.com/75007/stupid-geek-tricks-use-your-ssh-config-file-to-create-aliases-for-hosts/)
 > Write `ssh habanero` instead of `ssh <UNI>@habanero.rcs.columbia.edu`. If transferring lots of data, it's also worth setting up an alias for [habaxfer](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Working+on+Habanero)
1. Set up your scratch space
 > `cd /rigel/{group}/users/
 > ls -l
 > mkdir {UNI}
 > chmod 2700 {UNI}
 > cd {UNI}
 > scratch=$(pwd)
 > user=$(whoami)
 > add a symbolic link
 > cd ~
 > ln -s ${scratch}/${user} scratch
1. Install miniconda
 Run sbash.sh (this is just srun --pty -A <group> /bin/bash)
     > mv sbash.sh ~ # move sbash script to your home directory
     > mv conda_install.sh ~ 
     > chmod 755 sbash.sh # change permissions so you can run a script
     > chmod 755 conda_install.sh
     > ./sbash # Runs the script.  In a few seconds, you'll have a 4GB interactive core on a *node* running bash. Keep this here because you can always access a node quickly using it.
     > 
 
 



In addition you may want to:



* In addition to the above 
## Instructions
   
   






Steps:
 * Set up your habanero account. Ask Eric Vlach at ISERP to give you access!
 * Figure out habaxfer, which we use to transfer big files instead of habanero
 * setup ssh aliases so you don't need to remember IP addresses
 * ssh into habanero!
  * clone this directory!
  * move everything into home directory
  * download the miniconda installer
  * set up your scratch space
	* permissions so that other people can't access it (make it private except from the administrators)
	* symbolic link from home directory
	* now you can access your scratch space at ~/scratch.
 * srun 
	* Installing takes processing power
	* Using processing power on a login node will get you kicked off habanero
 * Now download miniconda
 * Install miniconda
 * Install base anaconda requirements (with gdal) into your scratch space, give that environment a name!
 * source or conda activate that environment
 * install any other packages you want there. 
 * (Optional) Set up another environment with just R, matlab, julia kernels
 * Basic scripts
	* Squeue.sh is squeue -u $UNI
	* sbash.sh is srun --pty -A sscc /bin/bash
 * Sbatch scripts
	* Setup your jupyter notebook
	* In addition to Claire's stuff, you'll have a bunch of stuff to set up a SERVER on the cluster. 
	* The server can allow you to forward a port to your computer. 
	* You can then ssh into the port, accessing the jupyter notebook server running on the node in addition to the login node you have. 
	* It will also activate the environment of your choice. 

More online information & support is provided by Columbia:
  * https://cuit.columbia.edu/shared-research-computing-facility
  * https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Getting+Started