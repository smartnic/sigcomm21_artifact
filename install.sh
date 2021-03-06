apt-get install binutils g++ make libelf-dev python python3-pip pkg-config llvm
pip3 install prettytable numpy

mkdir dependencies

# install z3
cd dependencies
git clone https://github.com/Z3Prover/z3.git
cd z3; git checkout 1c7d27bdf31ca038f7beee28c41aa7dbba1407dd
python scripts/mk_make.py
cd build
make
make install
cd ../../

# install k2
cd dependencies
git clone https://github.com/smartnic/superopt.git
cd superopt; git checkout sigcomm2021_artifact
make k2_inst_translater.out
make main_ebpf.out
make z3server.out
cd ../../

# download k2 benchmark files
cd dependencies
git clone https://github.com/smartnic/superopt-input-bm.git
cd ../
# copy k2 benchmark files to destinations
cp -r dependencies/superopt-input-bm 4_reproduce_results/1_insn_count/
cp -r dependencies/superopt-input-bm 4_reproduce_results/2_eq_chk_time/
cd 4_reproduce_results/2_eq_chk_time/
mkdir -p src/isa/ebpf/
cp ../../dependencies/superopt/src/isa/ebpf/inst.runtime src/isa/ebpf/inst.runtime
cd ../../

# install comparison of equivalence-checking time
cd dependencies/superopt
make meas_solve_time_ebpf.out
cd ../../
cp dependencies/superopt/measure/meas_solve_time_ebpf.out 4_reproduce_results/2_eq_chk_time/meas_solve_time_ebpf.out

# install text extractor and patcher
object_file_path=2_different_inputs/3_object_file/tools/
object_file_path_to_root=../../../
k2_path=dependencies/superopt/
mkdir -p $object_file_path
cd $object_file_path
git clone https://github.com/smartnic/bpf-elf-tools.git
pip3 install -r bpf-elf-tools/patch_insns/requirements.txt

make -C bpf-elf-tools/text-extractor/ 
gcc bpf-elf-tools/text-extractor/staticobjs/* -lelf -lz -o elf_extract

cp ${object_file_path_to_root}${k2_path}main_ebpf.out .
cp ${object_file_path_to_root}${k2_path}z3server.out .

mkdir -p src/isa/ebpf/
cp ${object_file_path_to_root}dependencies/superopt/src/isa/ebpf/inst.runtime src/isa/ebpf/inst.runtime
cd ${object_file_path_to_root}

