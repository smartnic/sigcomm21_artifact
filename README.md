# Artifact for submission "Synthesizing Safe and Efficient Kernel Extensions for Packet Processing"

## Claims to reproduce.
In this artifact, we provide instructions to reproduce the following claims in the paper.

1. K2's functionality of optimizing BPF programs.

2. Optimization impacts on equivalence-checking time.

3. ...

`Note`. To make it feasible to run the artifact quickly, we removed some benchmarks that
take more than 30 minutes. The expected results showing below are only used for reference, 
since K2 leverages stochastic search so that we cannot guarantee the results are exactly the same 
for every run. Expected time for the evaulation of the artifact is around 4 hours (based on a 
machine with 3.1 GHz Dual-Core Intel Core i7 processor, 16 GB 1867 MHz DDR3 memory).

---

## Instructions to run the artifact.

### Downloading prebuilt Docker Image

1. Install docker if it is not installed already by following the
documentation [here](https://docs.docker.com/install/).

2. Download the prebuilt docker image (shasum: c9600ada1b7bd57ced8362cc3f437cc7794537cb)
```
https://drive.google.com/file/d/1gOhTuI4mbXN00KZOHzrF_2aM8kyBWsWq/view?usp=sharing
```


3.  Run the docker image:
```
docker load < docker.tar.gz
docker run -it sigcomm21_artifact:v1 bash
cd sigcomm21_artifact
```


---
### Hello World
In this experiment, we get started with a Hello World example to check whether installation and setup are prepared, and to show the basic functionality of K2: take an original program in K2 language and produce an optimized one.

#### Run
Estimated runtime: 1 minute.
```
cd 1_hello_world
sh k2.sh
```

#### Expected Result 
After running the above commands, you will see some prints on the screen. The key information is about the performance costs (i.e., instruction count) of the original and optimized programs. It shows that K2 reduces 3 instructions to 2 instructions for the original program.
```
...
original program's perf cost: 3
...
top 1 program's performance cost: 2
...
```
The original program is in `benchmark.k2`, and K2 stores the optimized program in `benchmark.k2.out`. Run commands 
```
cat benchmark.k2
cat benchmark.k2.out
```
you will see the program 
```
MOV64XC 0 1
ADD64XY 0 0
EXIT
```
is optimized to
```
MOV64XC 0 2
EXIT
```

---

### Different inputs
In this experiment, we introduce three input-output types supported by K2: K2 language, BPF C macros and BPF object file, and examples of modifying the original program.

---

#### BPF C macros

Linux kernel supports utilizing [BPF C macros](https://elixir.bootlin.com/linux/v5.4/source/samples/bpf/bpf_insn.h) to write [BPF assembly programs](https://elixir.bootlin.com/linux/v5.4/source/samples/bpf/sock_example.c#L47). K2 can take a program in BPF C marcos and produce an optmized one in BPF C marcos.

##### Run
Estimated runtime: 2 minutes.
```
cd ../2_bpf_insn
sh k2.sh benchmark_before.bpf
```
##### Expected result
You will see K2 reduces 12 instructions to 10. 
```
...
original program's perf cost: 12
...
top 1 program's performance cost: 10
...
```
Run the following command to see the difference between the original and optimized programs.
```
diff benchmark_before.bpf benchmark_before.bpf.out
```
We can see that 2 two-byte load and store operations are optimized to 1 four-byte load and store.
```
1,4c1,2
< BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1, 0),
< BPF_STX_MEM(BPF_H, BPF_REG_10, BPF_REG_0, -4),
< BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1, 2),
< BPF_STX_MEM(BPF_H, BPF_REG_10, BPF_REG_0, -2),
---
> BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1, 0),
> BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -4),
```

##### Change the original program
todo

---

#### K2 language (optional)
K2 supports taking a program written in K2 language and producing an optimized program in K2. K2 language is a self-defined instruction set. Each instruction contains an opcode and one or multiple operands. Here(todo: add a link) is the documentation of K2 instructions. 

##### Run
Estimated runtime: 1 minute.
```
cd ../2_different_inputs/1_k2_inst
sh k2.sh benchmark_before.k2
```
##### Expected result
You will see K2 reduces 12 instructions to 10. 
```
...
original program's perf cost: 12
...
top 1 program's performance cost: 10
...
```
Run the following command to see the difference between the original and optimized programs.
```
diff benchmark_before.k2 benchmark_before.k2.out 
```
We can see that 2 one-byte load and store operations are optimized to 1 two-byte load and store.
```
1,4c1,2
< LDXB 0 1 0
< STXB 10 -2 0
< LDXB 0 1 1
< STXB 10 -1 0
---
> LDXH 0 1 0
> STXH 10 -2 0
```

##### Change the original program

todo

---

#### BPF object file

We also optimize the object files of BPF programs (i.e., *.o files from the compilier).

##### Run
Estimated runtime: 2 minutes.
```
cd ../3_object_file
sh k2.sh xdp1_kern xdp1
```
##### Expected result
You will see K2 reduces 61 instructions to 59. 
```
...
original program's perf cost: 61
...
top 1 program's performance cost: 59
...
```
Run the following command to see the difference between the original and optimized programs.
```
llvm-objdump -d xdp1_kern.o > xdp1_kern.o.objdump
llvm-objdump -d xdp1_kern.o.out > xdp1_kern.o.out.objdump
diff xdp1_kern.o.objdump xdp1_kern.o.out.objdump
```
We can see that there are two `goto +0` instructions in the optimized program. For convenience, we use `goto +0` instead of NOP for marking the deletion of this instruction.
```
...
<        5: 71 13 0c 00 00 00 00 00 r3 = *(u8 *)(r1 + 12)
<        6: 71 14 0d 00 00 00 00 00 r4 = *(u8 *)(r1 + 13)
<        7: 67 04 00 00 08 00 00 00 r4 <<= 8
<        8: 4f 34 00 00 00 00 00 00 r4 |= r3
---
>        5: 69 13 0c 00 00 00 00 00 r3 = *(u16 *)(r1 + 12)
>        6: 05 00 00 00 00 00 00 00 goto +0 <xdp_prog1+0x38>
>        7: bc 34 00 00 00 00 00 00 w4 = w3
>        8: 05 00 00 00 00 00 00 00 goto +0 <xdp_prog1+0x48>
```

---

### Reproduce the results

---

#### Improvements in program compactness from K2 (Table 1 in the paper)

#### Run
Estimated runtime: 1 hour 30 mins
```
cd ../../3_reproduce_results/1_insn_count
sh k2.sh
```

##### Expected result
```
+----------------------------------------------------+
|               Number of instructions               |
+--------------------+--------+----+-----------------+
|     Benchmark      | -O2/O3 | K2 | Compression (%) |
+--------------------+--------+----+-----------------+
|      socket-0      |   29   | 27 |       6.9       |
|      socket-1      |   32   | 30 |       6.25      |
|   sys_enter_open   |   24   | 20 |      16.67      |
|   xdp1_kern-xdp1   |   61   | 56 |       8.2       |
| xdp_cpumap_enqueue |   26   | 22 |      15.38      |
|  xdp_devmap_xmit   |   36   | 30 |      16.67      |
|   xdp_exception    |   18   | 16 |      11.11      |
|       xdp_fw       |   72   | 67 |       6.94      |
|   xdp_map_access   |   30   | 26 |      13.33      |
|    xdp_pktcntr     |   22   | 19 |      13.64      |
|  xdp_redirect_err  |   18   | 16 |      11.11      |
+--------------------+--------+----+-----------------+
+------------------------------------------------------------------+
|             Elapsed time for finding programs (sec)              |
+--------------------+------------------------------+--------------+
|     Benchmark      | Time to the smallest program | Overall time |
+--------------------+------------------------------+--------------+
|      socket-0      |             1.9              |      30      |
|      socket-1      |             1.2              |      38      |
|   sys_enter_open   |            1266.5            |     1564     |
|   xdp1_kern-xdp1   |            585.5             |     671      |
| xdp_cpumap_enqueue |            252.6             |     291      |
|  xdp_devmap_xmit   |            992.5             |     1178     |
|   xdp_exception    |             2.7              |      21      |
|       xdp_fw       |            248.5             |     304      |
|   xdp_map_access   |             23.0             |      49      |
|    xdp_pktcntr     |            164.3             |     270      |
|  xdp_redirect_err  |             78.8             |     178      |
+--------------------+------------------------------+--------------+
```
---

#### Reductions in equivalence-checking time (Table 3 in the paper)

##### Run
Estimated runtime: 2 hours
```
cd ../../3_reproduce_results/2_eq_chk_time
sh eq_chk.sh
```


##### Expected result
```

+-----------------------------------------------------------------------------------+
|                               Time consumption (us)                               |
+--------------------+-------------+-----------+-----------+-----------+------------+
|     Benchmark      | I,II,III,IV |  I,II,III |    I,II   |     I     |    None    |
+--------------------+-------------+-----------+-----------+-----------+------------+
|   xdp_exception    |    48887    |  1280730  |  3239100  |  1954550  |  50623600  |
|  xdp_redirect_err  |    35126    |   884464  |  1594880  |  1599790  | 143212000  |
|  xdp_devmap_xmit   |    69242    | 297381000 | 419262000 | 634626000 | 2430860000 |
| xdp_cpumap_kthread |    24184    | 111865000 | 103730000 | 125594000 | 605124000  |
| xdp_cpumap_enqueue |    301844   | 125391000 | 147459000 | 192472000 | 716662000  |
|    xdp_pktcntr     |     4056    |  3549610  |  15479500 |  17264000 |  89449200  |
+--------------------+-------------+-----------+-----------+-----------+------------+
+--------------------------------------------------------+
|   Slow down (how many times slower than I,II,III,IV)   |
+--------------------+----------+-------+-------+--------+
|     Benchmark      | I,II,III |  I,II |   I   |  None  |
+--------------------+----------+-------+-------+--------+
|   xdp_exception    |   26x    |  66x  |  40x  | 1036x  |
|  xdp_redirect_err  |   25x    |  45x  |  46x  | 4077x  |
|  xdp_devmap_xmit   |  4295x   | 6055x | 9165x | 35107x |
| xdp_cpumap_kthread |  4626x   | 4289x | 5193x | 25022x |
| xdp_cpumap_enqueue |   415x   |  489x |  638x | 2374x  |
|    xdp_pktcntr     |   875x   | 3816x | 4256x | 22054x |
+--------------------+----------+-------+-------+--------+
```

---

