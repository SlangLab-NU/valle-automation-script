# Automated Slurm Training Workflow
This repository contains two scripts for managing a machine learning training workflow on a Slurm cluster. The train_job.sh script is used to submit individual training jobs, and the watchdog.sh script monitors the job status and automatically submits new jobs based on the latest checkpoint.

# Usage
## 1. Adjust parameters in train_job.sh
- `#SBATCH --output` and `#SBATCH --error` should be set to proper directory where you wish to store log files. The log files includes output by vall-e training scripts.
- `#SBATCH --mail-user` should be set to your email address so you can receive notifications when your training cycle begins and finishes. *Please remember to change this so you don't accidentally spam me.*
- `valle_root` should be pointing to the vall-e repo root directory. The file structure should mirror the one in the official [repo](https://github.com/lifeiteng/vall-e/tree/main).
- make sure `singularity_image` is set to proper singularity image path. Adjust training parameters as necessary.

## 2. Adjust parameters in watchdog.sh
- Adjust `valle_root` as you did in `train_job.sh`.
- Adjust `max_epochs` parameter, so the watchdog stop submitting the job when the epoch reaches this number.

## 3. Run the watchdog script
On login node, run watchdog script: `nohup ./watchdog.sh >watchdog.log 2>&1 &`

## 4. Monitor and stopping
You can monitor the progress in the log files, you will also receive job notifications in via email. The job name encodes train_{epoch}_{checkpoint} number.
To stop the watchdog prematurelly if there is a problem, use `jobs -l` to figure out the pid of the script, then kill it:
```
[user@login-01 automation]$ jobs -l
[1]+ 149769 Running                 nohup ./watchdog.sh > watchdog.log 2>&1 &
[user@login-01 automation]$ kill 149769
```
To stop an individual batch run, use `squeue` and `scancel`.

**Final Note:** The script is still under testing and development, so please bear with me if you encounter issues!



