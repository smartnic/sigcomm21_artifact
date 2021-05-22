apt-get install binutils g++ make libelf-dev python python3-pip pkg-config llvm

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
cd 3_reproduce_results/1_insn_count/
git clone https://github.com/smartnic/superopt-input-bm.git
cd ../../

# install text extractor and patcher
object_file_path=2_different_inputs/3_object_file/
object_file_path_to_root=../../
k2_path=dependencies/superopt/
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

