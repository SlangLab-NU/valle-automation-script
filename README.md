# Automated Slurm Training Workflow
This repository contains three scripts for managing a machine learning training workflow on NEU Slurm cluster. The train_job.sh script is used to submit individual training jobs, and the check_and_submit.sh script monitors the job status and automatically submits new jobs based on the latest checkpoint. Finally, we have watchdog.sh that periodically ssh into the cluster and run check_and_submit.sh

# Usage
## 1. Adjust parameters in train_job.sh
- `#SBATCH --output` and `#SBATCH --error` should be set to proper directory where you wish to store log files. The log files includes output by vall-e training scripts.
- `#SBATCH --mail-user` should be set to your email address so you can receive notifications when your training cycle begins and finishes. *Please remember to change this so you don't accidentally spam me.*
- `valle_root` should be pointing to the vall-e repo root directory. The file structure should mirror the one in the official [repo](https://github.com/lifeiteng/vall-e/tree/main).
- make sure `singularity_image` is set to proper singularity image path. Adjust training parameters as necessary.

## 2. Adjust parameters in check_and_submit.sh
- Adjust `valle_root` as you did in `train_job.sh`.
- Adjust `max_epochs` parameter, so the check_and_submit stop submitting the job when the epoch reaches this number.

## 3. Setup the watchdog script
You will need a server that is contantly on. Luckily we have Polaris. The watchdog periodically ssh into the cluster and run check_and_submit.sh to submit jobs for us. You might wonder, why don't we just run watchdog script on NEU login node? This is because NEU login node has watchdogs too, and they will kill your script as soon you logoff or get disconnected, even if you use nohup. 

First, we need to set up passwordless login. On polaris shell, run:
`ssh-copy-id -i ~/.ssh/id_rsa.pub your_neu_username@login.discovery.neu.edu`
after this runs successfully, you should try to ssh into login.discovery.neu.edu, and no password will be needed.

Then, modify the watchdog variable `remote_user` and `remote_script_path` as needed.
run watchdog script: `nohup ./watchdog.sh >watchdog.log 2>&1 &`, or use `screen` if you like interactive mode.

## 4. Monitor and stopping
You can monitor the progress in the log files, you will also receive job notifications in via email. The job name encodes train_{epoch}_{checkpoint} number.
To stop the watchdog prematurelly if there is a problem, use `jobs -l` to figure out the pid of the script, then kill it:
```
[user@polaris]$ jobs -l
[1]+ 149769 Running                 nohup ./watchdog.sh > watchdog.log 2>&1 &
[user@polaris]$ kill 149769
```
To stop an individual batch run, use `squeue` and `scancel`.

**Final Note:** The script is still under testing and development, so please bear with me if you encounter issues!



