Run Command:
robot -l log_`date +%F_%H%M%S`.html -r report_`date +%F_%H%M%S`.html --variable LOGNAME:logs/hc.log healthcheck.robot