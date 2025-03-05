#!/bin/bash

remote_user=aa.mohan
remote_host="login.discovery.neu.edu"
valle_root="/work/van-speech-nlp/aanchan/refactor-valle/VallE"
job_name="att3_train_refactor_8_0_1"
script_dir=$valle_root/scripts/$job_name
remote_script_path="$script_dir/check_and_submit.sh"

sleep_sec=3600

while true; do
	# SSH into the remote server and execute the check and submit script
	ssh -T ${remote_user}@${remote_host} "export VALLE_ROOT=${valle_root} && export script_dir=${script_dir}  && bash ${remote_script_path}"
	# Sleep for a specified amount of time before checking again
	sleep ${sleep_sec}
done
