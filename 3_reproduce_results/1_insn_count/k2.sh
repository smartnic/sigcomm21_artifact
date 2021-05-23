path_to_root=../../
bm_file_prefix=superopt-input-bm/input_bm_0108_ab7e41e/
cp ${path_to_root}dependencies/superopt/z3server.out .
cp ${path_to_root}dependencies/superopt/main_ebpf.out .
mkdir -p src/isa/ebpf
cp ${path_to_root}dependencies/superopt/src/isa/ebpf/inst.runtime src/isa/ebpf/inst.runtime

output_prefix=output/
# socket/1
echo "socket/1..."
bm_file=${bm_file_prefix}ebpf_samples/sockex3_kern_socket-1
output_dir=${output_prefix}socket-1/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 0 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 5000 --win_s_list 1 --win_e_list 9 --path_res $output_dir -n 25000"
$k2_cmd > ${output_dir}log.txt
#grep "top 1 " ${output_dir}log.txt

# socket/0
echo "socket/0..."
bm_file=${bm_file_prefix}ebpf_samples/sockex3_kern_socket-0
output_dir=${output_prefix}socket-0/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 0 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 5000 --win_s_list 1 --win_e_list 6 --path_res $output_dir -n 25000"
$k2_cmd > ${output_dir}log.txt

# xdp_exception
echo "xdp_exception..."
bm_file=${bm_file_prefix}ebpf_samples/xdp_monitor_kern_tracepoint-xdp-xdp_exception
output_dir=${output_prefix}xdp_exception/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 5000 --win_s_list 12 --win_e_list 14 --path_res $output_dir -n 25000"
$k2_cmd > ${output_dir}log.txt

# xdp_redirect_err
echo "xdp_redirect_err..."
bm_file=${bm_file_prefix}ebpf_samples/xdp_monitor_kern_tracepoint-xdp-xdp_redirect_err
output_dir=${output_prefix}xdp_redirect_err/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 50000 --win_s_list 12 --win_e_list 14 --path_res $output_dir -n 400000"
$k2_cmd > ${output_dir}log.txt

# xdp1_kern/xdp1
echo "xdp1_kern/xdp1..."
bm_file=${bm_file_prefix}ebpf_samples/xdp1_kern_xdp1
output_dir=${output_prefix}xdp1_kern-xdp1/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 80000 --win_s_list 56,56,5,48 --win_e_list 58,58,8,49 --path_res $output_dir -n 900000"
$k2_cmd > ${output_dir}log.txt

# xdp_map_access
echo "xdp_map_access..."
bm_file=${bm_file_prefix}simple_fw/xdp_map_access_kern_xdp_map_acces
output_dir=${output_prefix}xdp_map_access/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 1 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 50000 --win_s_list 2,8 --win_e_list 5,9 --path_res $output_dir -n 100000"
$k2_cmd > ${output_dir}log.txt

# xdp_devmap_xmit
echo "xdp_devmap_xmit..."
bm_file=${bm_file_prefix}ebpf_samples/xdp_monitor_kern_tracepoint-xdp-xdp_devmap_xmit
output_dir=${output_prefix}xdp_devmap_xmit/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 1 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 80000 --win_s_list 15,31,12,21,26,1 --win_e_list 18,33,14,23,28,2 --path_res $output_dir -n 1500000"
$k2_cmd > ${output_dir}log.txt

# sys_enter_open
echo "sys_enter_open..."
bm_file=${bm_file_prefix}ebpf_samples/syscall_tp_kern_tracepoint-syscalls-sys_enter_open
output_dir=${output_prefix}sys_enter_open/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 0 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 80000 --win_s_list 10,10,0 --win_e_list 12,12,3 --path_res $output_dir -n 350000"
$k2_cmd > ${output_dir}log.txt

# xdp_cpumap_enqueue
echo "xdp_cpumap_enqueue..."
bm_file=${bm_file_prefix}ebpf_samples/xdp_monitor_kern_tracepoint-xdp-xdp_cpumap_enqueue
output_dir=${output_prefix}xdp_cpumap_enqueue/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 5 --st_ex 1 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 50000 --win_s_list 22,22,14,18 --win_e_list 24,24,16,20 --path_res $output_dir -n 450000"
$k2_cmd > ${output_dir}log.txt

# xdp_fw
echo "xdp_fw..."
bm_file=${bm_file_prefix}simple_fw/xdp_fw_kern_xdp_fw
output_dir=${output_prefix}xdp_fw/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 5 --st_ex 0 --st_eq 0 --st_avg 0 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 50000 --win_s_list 10,2,52 --win_e_list 13,5,55 --path_res $output_dir -n 200000"
$k2_cmd > ${output_dir}log.txt

# xdp_pktcntr
echo "xdp_pktcntr..."
bm_file=${bm_file_prefix}katran/xdp_pktcntr_xdp-pktcntr
output_dir=${output_prefix}xdp_pktcntr/
mkdir -p $output_dir
k2_cmd="./main_ebpf.out --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 80000 --win_s_list 17,17,0 --win_e_list 19,19,2 --path_res $output_dir -n 400000"
$k2_cmd > ${output_dir}log.txt

python3 print_res.py
rm -rf $output_dir

