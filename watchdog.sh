#!/bin/bash

remote_user="lewis.jor"
remote_host="login.discovery.neu.edu"
remote_script_path="/work/van-speech-nlp/valle-automation-script/check_and_submit.sh"
sleep_sec=3600

while true; do
	# SSH into the remote server and execute the check and submit script
	ssh -T ${remote_user}@${remote_host} "bash ${remote_script_path}"
	# Sleep for a specified amount of time before checking again
	sleep ${sleep_sec}
done
