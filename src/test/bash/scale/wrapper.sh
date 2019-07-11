#!/bin/bash

# Facilitates scale testing of Exchange. Runs the specified number of instances of test.sh in the background and waits for them to finish.
# For true scale testing use a higher level script (not supplied) to run wrapper.sh on multiple systems.

if [[ -z $1 ]]; then
	echo "Usage: $0 <num instances of test-script> [test-script]"
	exit 1
fi

numInstances=$1

script="${2:-test.sh}"

# default of where to write the summary or error msgs. Can be overridden
EX_PERF_REPORT_DIR="${EX_PERF_REPORT_DIR:-/tmp/exchangePerf}"

dir=`dirname $0`

function checkrc {
	if [[ $1 != $2 ]]; then
		echo "curl failed with rc $1"
		exit $1
	fi
}

# Clear out all of the summaries (in case we are running with a lower number than previous)
rm -rf $EX_PERF_REPORT_DIR/*

for (( i=1 ; i<=$numInstances ; i++ )) ; do
	$dir/$script $i &
done

#todo: if we gathered a list of the pids and specified them here, would wait give us the highest exit code?
wait
