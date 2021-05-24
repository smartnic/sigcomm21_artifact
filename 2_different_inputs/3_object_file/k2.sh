#!/bin/bash
echo "Running K2 to optimize benchmark..."
benchmark=xdp1_kern.o
section=xdp1
if [ $# -gt 0 ]; then
  benchmark=$1
fi
if [ $# -gt 1 ]; then
  section=$2
fi
echo "Benchmark is" $benchmark $section
output_file=$benchmark.out

bm_name=${benchmark%??}
cp run_k2.py tools/
cp $bm_name.* tools/
cd tools/
if [ ! -d "output" ]; then
  mkdir output
fi
python3 run_k2.py $bm_name.o $bm_name.desc $bm_name.k2_args --programs $section > run_k2_log.tmp
cd ../
mv tools/output/${section}_modified.o $output_file
echo "Finish running:"
grep "original" tools/output/log.txt
echo "best program found by K2: "
grep "top 1 " tools/output/log.txt
echo "Optimized program is stored in" $output_file
grep "compiling" tools/output/log.txt
rm -rf tools/output
rm -f tools/run_k2.py
rm -f tools/$bm_name.*
rm -rf $bm_name.insns
rm -rf run_k2_log.tmp
rm -rf old-extracted-files

