#!/bin/bash

remote_user="zhang.tianyi9"
remote_host="login.discovery.neu.edu"
remote_script_path="/scratch/zhang.tianyi9/automation/check_and_submit.sh"
sleep_sec=3600

while true; do
	# SSH into the remote server and execute the check and submit script
	ssh -T ${remote_user}@${remote_host} "bash ${remote_script_path}"
	# Sleep for a specified amount of time before checking again
	sleep ${sleep_sec}
done
