Run Command:
robot -l log_`date +%F_%H%M%S`.html -r report_`date +%F_%H%M%S`.html --variable LOGNAME:logs/hc.log testcases/healthcheck.robot





Windows
-l log_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%.html -r report_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%.html