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
    
## Setup Habanero without Jupyter 
Basics (without Jupyter):
* [How_to_use_Habanero.pdf](https://github.com/ClairePalandri/HABANERO-HPC_material/blob/master/How_to_use_Habanero.pdf)
* [Habanero documentation](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Getting+Started)

## Setup Habanero with Jupyter

#### Access Habanero
 * You are entitled to a free account. Go here to submit [a request form](https://columbia.servicenow.com/cu?id=sc_cat_item_cu&sys_id=9876ecc213bd160006c376022244b00a) for free HPC access.
 * You can ask to be added as a new user to an existing HPC group (e.g.: cwc; sipa). Current HPC customers can request access to their HPC group for a new user by emailing rcs@columbia.edu (e.g.: to be added as a new user to the SIPA group, ask Doug to request that access for you)
 * (recommended) Eric Vlach is at ISERP and can give you access to the Social Science Computing Committee (sscc) group.  They have much more space than SIPA...

#### SSH into Habanero
1. SSH into habanero (windows requires the [PuTTY SSH client](https://www.ssh.com/ssh/putty/windows))
 * `ssh <UNI>@habanero.rcs.columbia.edu`
 * You can set up the command to just be `ssh habanero`, by [setting up an ssh alias](https://www.howtogeek.com/75007/stupid-geek-tricks-use-your-ssh-config-file-to-create-aliases-for-hosts/)
 * [(optional) Add github keys to habanero(https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)
 
#### Scratch Storage
When you login to Habanero, you will be at your home directory `~` on a login node (holmes, watson). So you should see something like this:
`[pt2535@holmes ~]$`
This directory has 10GB. Appropriate for smaller files: docs, source code, scripts, but in general it's not enough. 

You also have your group account's scratch storage /rigel/<group>. It's known as scratch storage because it isn't backed up!
 > Ex: /rigel/cwc and /rigel/sscc has size = 20 TB, no default User Quota.
We want to set up a 'personal folder' in the group directory that other people in the group can't access, delete or modify by changing their permission settings. Furthermore we want to make it easy to access (we'll create a shortcut known as a [symbolic link](https://en.wikipedia.org/wiki/Symbolic_link)) because 10GB runs out really quickly. 

NB: Replace <group> or with your account (e.g. cwc, sscc) and <user> or <UNI> or ${UNI} with your uni throughout this walkthrough. Replace ${scratch} pr <scratch> with your path /rigel/<group>/users/
```
# Navigate to your group accounts scratch storage
cd /rigel/<group>/users 
ls -l # notice that some people's security settings mean you can access their files.
# Sets up local variables 
scratch=$(pwd)
user=$(whoami)
# Make a directory isn't there make it
mkdir ${user}
# Remove group access
chmod 2700 ${user}
# add a symbolic link to your home directory
cd ~
ln -s ${scratch}/${user} scratch
```




This setup is geared towards Sustainable Development PhD students.  What that means is that we'll account for usage of:
* Large Datasets
    * Habanero only provides 10GB of private space, so we minimize use of that wherever possible, so we utilize the scratch space wherever possible.
    * So we installs environment(s) in the scratch space.   
    * We use miniconda in the home directory because conda 4.8 fixes a lot of bugs related to config and the latest version of conda on [modules](https://confluence.columbia.edu/confluence/display/rcs/Habanero+-+Software) is 4.4
* Working with geopspatial and other software languages
    * GDAL (the base geospatial library for nearly anything) notoriously breaks installations if you don't do it right off the bat, so we do that when installing.
    * People use matlab, R, julia, python, and we want to set them up to be interoperable on jupyter. We'll use the julia version from modules, follow Claire's work on R but add IRkernel, and will figure out matlab eventually...
 
### 

 * > 
 * > mkdir {UNI}
 * > chmod 2700 {UNI}
 * > cd {UNI}
 * > scratch=$(pwd)
 * > user=$(whoami)
 * > add a symbolic link
 * > cd ~
 * > ln -s ${scratch}/${user} scratch
1. Install miniconda
 Run sbash.sh (this is just srun --pty -A <group> /bin/bash)
     > mv sbash.sh ~ # move sbash script to your home directory
     > mv conda_install.sh ~ 
     > chmod 755 sbash.sh # change permissions so you can run a script
     > chmod 755 conda_install.sh
     > ./sbash # Runs the script.  In a few seconds, you'll have a 4GB interactive core on a *node* running bash. Keep this here because you can always access a node quickly using it.