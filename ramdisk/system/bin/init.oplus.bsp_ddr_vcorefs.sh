#!/system/bin/sh
#=============================================================================
#persist.debug.cpu.dvfs.config
#testing_phase=`getprop persist.debug.ddr.vcorefs.config`
#=============================================================================

echo "Just for CPU DVFS Debug"

#ntest*delay= 30S
ntest=200
delay=0.3	## 00ms
bimc_scaling_freq_list=(2736000 2092800 1804800 1555200 1353600 1017600 768000 681600 547200 451200 300000 200000)

display_freq() {
  if [ -f /sys/kernel/debug/clk/measure_only_mccc_clk/clk_measure ]; then
    # SM8150/8250
    echo "BIMC cur_freq: " $(< /sys/kernel/debug/clk/measure_only_mccc_clk/clk_measure)
  else
    echo "BIMC measure unsupported, try dercit read"
    echo "BIMC cur_freq: " $(< /sys/kernel/debug/clk/measure_only_mccc_clk/clk_measure)
  fi
}

bimc_freq_switch() {
  ## don't turn off thermal-engine, otherwise thermal reset will be triggered easily. #stop thermal-engine
  for REQ_KHZ in ${FREQ_LIST}; do
    #SM8150/8250
    if [ -f /sys/kernel/debug/aop_send_message ]; then
        echo "BIMC req_freq: ${REQ_KHZ}"
        echo "{class:ddr, res:fixed, val: $((${REQ_KHZ}/1000))}" > /sys/kernel/debug/aop_send_message
    elif [ -f /proc/aop_send_message ]; then
        echo "BIMC req_freq proc: ${REQ_KHZ}"
        echo "{class:ddr, res:fixed, val: $((${REQ_KHZ}/1000))}" > /proc/aop_send_message
    else
        echo "BIMC measure unsupported, try dercit set"
        echo "{class:ddr, res:fixed, val: $((${REQ_KHZ}/1000))}" > /sys/kernel/debug/aop_send_message
		echo "{class:ddr, res:fixed, val: $((${REQ_KHZ}/1000))}" > /proc/aop_send_message
    fi

    display_freq
    sleep ${delay}
  done
}


#cpu dvfs ramdom
do_ddr_vcorefs_random(){
	for i in $(seq 1 ${ntest})
	do
		# Seed random generator
		# randomly select the frequency from the list
		FREQ_LIST=${bimc_scaling_freq_list[$RANDOM % ${#bimc_scaling_freq_list[@]}]}
		bimc_freq_switch
	done
}


do_ddr_vcorefs_longstep_random(){
	for i in $(seq 1 ${ntest})
	do
		check=$(($RANDOM%2))
		if [ $check -eq 0 ]; then
			FREQ_LIST=${bimc_scaling_freq_list[0]}
		else
			FREQ_LIST=${bimc_scaling_freq_list[${#bimc_scaling_freq_list[@]}-1]}
		fi
		bimc_freq_switch
	done
}


do_ddr_vcorefs_max(){
	for i in $(seq 1 ${ntest})
	do
		FREQ_LIST=${bimc_scaling_freq_list[0]}
		bimc_freq_switch
	done
}


do_ddr_vcorefs_min(){
	for i in $(seq 1 ${ntest})
	do
		FREQ_LIST=${bimc_scaling_freq_list[${#bimc_scaling_freq_list[@]}-1]}
		bimc_freq_switch
	done
}


enable_ddr_vcorefs_test(){
	while [ 1 ] 
	do
		ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
		if [ "$ddr_testphase" = "done" ]; then
			break
		fi
		setprop persist.debug.ddr.vcorefs.config random
		ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
		echo "ddr_testphase:$ddr_testphase."
		if [ "$ddr_testphase" = "random" ]; then
			do_ddr_vcorefs_random
		fi

		ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
		if [ "$ddr_testphase" = "done" ]; then
			break
		fi
		setprop persist.debug.ddr.vcorefs.config max
		ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
		echo "ddr_testphase:$ddr_testphase."
		if [ "$ddr_testphase" = "max" ]; then
			do_ddr_vcorefs_max
		fi

		ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
		if [ "$ddr_testphase" = "done" ]; then
			break
		fi
		setprop persist.debug.ddr.vcorefs.config min
		ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
		echo "ddr_testphase:$ddr_testphase."
		if [ "$ddr_testphase" = "min" ]; then
			do_ddr_vcorefs_min
		fi

		ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
		if [ "$ddr_testphase" = "done" ]; then
			break
		fi
		setprop persist.debug.ddr.vcorefs.config longstep
		ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
		echo "ddr_testphase:$ddr_testphase."
		if [ "$ddr_testphase" = "longstep" ]; then
			do_ddr_vcorefs_longstep_random
		fi
	done
	echo "The ddr_vcorefs_test is done and PASS if no exception occurred."
}

enable_ddr_vcorefs_manual(){
	ddr_testphase=`getprop persist.debug.ddr.vcorefs.config`
	while [ 1 ] 
	do
		if [ "$ddr_testphase" != "done" ]; then
			break
		fi
		ddr_manualphase=`getprop persist.debug.ddr.vcorefs.manual`
		echo "ddr_manualphase:$ddr_manualphase."
		if [ "$ddr_manualphase" = "random" ]; then
			do_ddr_vcorefs_random
		elif [ "$ddr_manualphase" = "max" ]; then
			do_ddr_vcorefs_max
		elif [ "$ddr_manualphase" = "min" ]; then
			do_ddr_vcorefs_min
		elif [ "$ddr_manualphase" = "longstep" ]; then
			do_ddr_vcorefs_longstep_random
		elif [ "$ddr_manualphase" = "done" ]; then
			break
		else
			sleep 10
		fi
	done
	echo "The enable_ddr_vcorefs_manual is done and PASS if no exception occurred."
}


enable_ddr_vcorefs_test
enable_ddr_vcorefs_manual

