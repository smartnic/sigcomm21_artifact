# Artifact for submission "Synthesizing Safe and Efficient Kernel Extensions for Packet Processing"

## Abstract of the accepted paper

Extended Berkeley Packet Filter (BPF) has emerged as a powerful method to extend
packet-processing functionality in the Linux operating system.
BPF allows users to write code in high-level languages like C or Rust and attach
them to specific points in the kernel, such as the network device driver.
To ensure safe execution of a user-developed BPF program in kernel context,
Linux employs an in-kernel static checker, that only accepts the program if it
can be shown to be crash-free and isolated from the rest of kernel memory.

However, BPF programming is not easy. One, even modest-size BPF programs can be
rejected by the kernel checker as they are construed to be too large to
analyze. Two, the in-kernel static checker may incorrectly determine that an
eBPF program exhibits unsafe behaviors.
Three, even small performance optimizations to BPF code (e.g., 5% gains)
must be meticulously hand-crafted by expert developers.
Optimizing compilers for BPF are severely hampered because the kernel checker's
safety considerations are incompatible with rule-based optimizations used in
traditional compilers.

We present K2, a program-synthesis-based compiler that automatically
optimizes BPF bytecode with formal correctness and safety guarantees.
K2 leverages stochastic search, a formalization of BPF in first-order
logic, and several domain-specific techniques to accelerate equivalence checking
of BPF programs. Relative to `clang -O3`, K2 produces code with 6--26% reduced size, 
13--85 microseconds lower latency, and -0.03--5% higher throughput 
(packets per second per core), across programs drawn from
production systems at Cilium and the Linux kernel. BPF programs produced by
K2 can pass the kernel checker.

## Claims to validate
We provide instructions to help validate the following claims about the paper. 

*Artifact availability. (section 0).* Our compiler and all its peripheral code in subsidiary repositories have been made publicly available. The source code of the K2 compiler and supporting software (including evaluation scripts) are publicly available under https://github.com/smartnic/ Further, for easy experimentation, we provide a [Docker container](https://github.com/smartnic/sigcomm21_artifact#0-instructions-to-run-the-artifact). The `install.sh` script in this repository provides instructions to download all the required components if one is building a container image from scratch. Many of the experiments in this repository use the Docker container.

*Artifact functionality (sections 1 through 4).* We show that the compiler can be exercised with different inputs, input formats, and compiler parameters. 

1. [Hello world.](https://github.com/smartnic/sigcomm21_artifact#1-hello-world)
This task exercises all of K2's main software components by showing how to optimize a small, simple program. [total estimated machine time: 1 minute; human time: 5 minutes]

2. [Changing the input program.](https://github.com/smartnic/sigcomm21_artifact#2-Changing-the-input-program)
We show how a user might change the input program to K2 to obtain
different outputs. K2 accepts programs in three formats: [BPF C macros](https://github.com/smartnic/sigcomm21_artifact#21-bpf-c-macros)
used by the Linux kernel (file extension .bpf), a home-grown instruction format we
developed that we call this the [K2 language](https://github.com/smartnic/sigcomm21_artifact#22-k2-language-optional) (files with extension
.k2), and [pre-compiled BPF object files](https://github.com/smartnic/sigcomm21_artifact#23-bpf-object-file). The compiler will output
optimized versions of the programs in the same format that is
consumed. [total estimated machine time: 4 minutes; human time: 15 minutes]

3. [Changing compiler parameters.](https://github.com/smartnic/sigcomm21_artifact#3-changing-compiler-parameters)
We show how a user might modify the parameters fed to K2 by modifying
the K2 command line in our scripts. The [full set of K2
parameters](https://github.com/smartnic/sigcomm21_artifact/wiki#k2-parameters) is available.
[total estimated machine time: 2 minutes; human time: 10 minutes]

4. [Specific ACM SIGCOMM criteria for artifact functionality.](https://github.com/smartnic/sigcomm21_artifact#4-Specific-ACM-SIGCOMM-criteria-for-artifact-functionality)
This section explicitly addresses the three criteria for artifact functionality described in the [call for artifacts](https://conferences.sigcomm.org/sigcomm/2021/cf-artifacts.html). [total estimated (human) time: 2 minutes]

*Reproduction of results (sections 5 through 8).* We show how to reproduce the main claims in the empirical evaluation of the paper.

5. [Instruction count reduction](#5-improvements-in-program-compactness-from-k2-table-1-in-the-submitted-paper): We provide
scripts to reproduce a subset of results on the reductions in program
instruction counts that K2 can obtain (table 1 in the submitted
paper). The subset of benchmarks chosen corresponds to those programs
that we believe can run fast enough on a user's laptop -- we chose
benchmarks where the best programs were found within 30 minutes in our
submission. Our paper submission claims program compaction anywhere between
6 -- 26%. [total estimated time: 90 minutes.]

6. [Impact of optimizations on equivalence-checking time](#6-reductions-in-equivalence-checking-time-table-3-in-the-submitted-paper): We provide scripts to
reproduce a subset of results on the impact of optimizations on
reductions in equivalence-checking time (table 3 in the submitted paper).
The subset of benchmarks chosen corresponds to those programs that 
we believe can run fast enough on a user's laptop -- we chose
benchmarks where the experiment can finish running within 1 hour in our
submission. Our paper submission claims an average 5 orders of magnitude reduction
in equivalence-checking time. However, the subset of (faster) benchmarks in the container
may only show about 4 orders of magnitude of benefit (10,000X or more).
[total estimated time: 120 minutes.]

7. [Latency/throughput benefits](#7-latencythroughput-benefits-table-2-in-the-submitted-paper): 
We provide scripts to reproduce a subset
of results from our empirical evaluation of throughput and latency of
programs optimized by K2 (table 2 in the submitted paper). This requires
[setting up an experiment on the NSF CloudLab testbed](#72-cloudlab-experiment-setup) 
using the credentials and disk
images that we provide. *This experiment takes a while to run* -- however,
it runs on a server-class machine that you log into, and once
the longer experiments start, they require your attention only after a few
hours.  Our paper submission claims that the best programs produced by K2
produce -0.03--5% higher throughput and 13--85 microseconds of lower
latency than the most optimized versions produced by Clang. Due to the
slightly different nature of the experimental setup between the paper submission and the
replication (i.e., this document), the exact numbers you will see will differ from
those in Table 2 in the submission. See our [caveat](#71-an-important-caveat-about-latency-and-throughput-numbers-from-this-experiment)
for more details. Instead of validating the exact improvements, the main claim to validate is 
that there is a reduction in tail latency (i.e., the latency at the MLFFR, see
section 8 in the submitted paper) with similar or better throughput
(i.e., the MLFFR).  [total estimated machine time: 15
hours; human time: 40 minutes]

8. [Efficacy of safety checks](#8-efficacy-of-safety-checks-table-7-in-the-submitted-paper-appendix): We provide scripts to reproduce the results on checking the safety of K2-produced programs
using the kernel checker (table 7 in the submitted paper appendix). 
We test whether K2 programs can pass the kernel checker by _loading_ each
BPF program into the kernel. If the load succeeds, it means that the program
can pass the kernel checker. The result shows that 35 among 38 programs can pass 
the kernel checker.
[total estimated machine time: 2 minutes 30 seconds; human time: 5 minutes.]

## Notes and caveats
1. The results shown below can only be used for reference.
Since K2 leverages stochastic search, we cannot guarantee that the results
are exactly the same for every run. Further, experimentation on throughput
and latency can show variations from run to run. We have observed that small programs
often exhibit deterministic behavior.

2. K2 is a synthesizing compiler that optimizes BPF programs better than
traditional compilers like clang. However, it does so at the expense
of additional compile time. When you run the compiler on a program,
you may often need to wait longer (e.g., than using `clang`) to see results. We have
made our best efforts to provide sample programs that can be
near-interactively compiled on a reasonably powerful laptop, and we
provide estimations of how long you might have to wait for each compilation to
finish.

3. The estimated times for the evaluations running in the Docker container
are based on a machine with 3.1 GHz Dual-Core Intel Core i7 processor, 
16 GB 1867 MHz DDR3 memory. We have tested the container on a few different laptops,
and expect the experiments to run without too much trouble on a relatively modern laptop.

4. Experiments 1--6 can be run in any order once you've [set up the
Docker
container.](https://github.com/smartnic/sigcomm21_artifact#0-instructions-to-run-the-artifact)
Experiments 7 and 8 can be run in either order once you've [set up the
CloudLab
experiment.](#72-cloudlab-experiment-setup)

---

## #0. Instructions to run the artifact

### Downloading the prebuilt Docker Image

1. Install docker if it is not installed already by following the
[Docker install documentation](https://docs.docker.com/install/).

2. Download the prebuilt docker image (shasum: 469dbb6cb935342bd7fbd5687c395ba9cb7ef5e5)
```
https://drive.google.com/file/d/1FT0YjxDlJYzAiu16V-pyNaDoBvcXC0aa/view?usp=sharing
```


3.  Run the docker image:
```
docker load < docker.tar.gz
docker run -it sigcomm21_artifact:v1 bash
cd sigcomm21_artifact
```

---
## 1 Hello World
In this experiment, we get started with a Hello World program to show the basic functionality of K2.
The compiler takes an input program `benchmark.k2` written in the K2 language, optimizes this program,
and produces an output program `benchmark.k2.out` in the K2 language.

### Run
Estimated runtime: 20 seconds.
```
cd 1_hello_world
sh k2.sh
```

### Result for reference 
After running the above commands, you will see some prints on the screen. The key information is about the performance costs (i.e., instruction count) of the input and output programs. It shows that K2 reduces 3 instructions to 2 instructions for the input program.
```
...
original program's perf cost: 3
...
top 1 program's performance cost: 2
...
```
Run the following commands to have a look at the input and output programs.

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

Here are some comments to help understand the meanings of the two programs. Each line of the benchmark files is one instruction. `r0, r1, ...` are BPF registers.

benchmark.k2

```
MOV64XC 0 1 // r0 = 1
ADD64XY 0 0 // r0 += r0
EXIT        // exit, return r0
```
benchmark.k2.out
```
MOV64XC 0 2 // r0 = 2
EXIT        // exit, return r0
```

---

## 2 Changing the input program
In this experiment, we introduce three input-output program formats supported by K2: BPF C macros, the K2 language, and pre-compiled BPF object files, and show how a user might modify a given program to see different outputs. Kernel developers often hard-code BPF assembly similar to the first format (BPF C macros); most real code that uses BPF is written in C and compiled by `Clang` into the BPF object file format, which corresponds to the third format (pre-compiled BPF object files). We show all three program formats since the first two formats are easier to read and understand (especially to understand specific optimizations), while the last format is practically the most used and deployed.

### 2.1 BPF C macros

The Linux kernel supports utilizing [BPF C macros](https://elixir.bootlin.com/linux/v5.4/source/samples/bpf/bpf_insn.h) to write BPF assembly programs ([an example](https://elixir.bootlin.com/linux/v5.4/source/samples/bpf/sock_example.c#L47)).
In this experiment, we show K2 takes a program written in BPF C macros and produces an optimized program also written in BPF C macros.
We also use an example to show how a user might change the input program.

#### Run
Estimated runtime: 40 seconds.
```
cd ../2_different_inputs/1_bpf_insn
sh k2.sh benchmark_before.bpf
```

The second command feeds program `benchmark_before.bpf` to K2, and K2 will produce an output program in
`benchmark_before.bpf.out`

#### Result for reference
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
We can see that 2 two-byte load-and-store operations are optimized to 1 four-byte load-and-store operation.
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

Here are some comments to help understand the programs.

benchmark_before.bpf
```
BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1, 0),    // r0 = *(u16 *)(r1 + 0)
BPF_STX_MEM(BPF_H, BPF_REG_10, BPF_REG_0, -4),  // *(u16 *)(r10 - 4) = r0
BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1, 2),    // r0 = *(u16 *)(r1 + 2)
BPF_STX_MEM(BPF_H, BPF_REG_10, BPF_REG_0, -2),  // *(u16 *)(r10 - 2) = r0
BPF_LD_MAP_FD(BPF_REG_1, 4),                    // r1 = map fd 4
BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),           // r2 = r10
BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),          // r2 += -4
BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem), // call map_lookup_elem
BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),          // if r0 == 0, jmp 1 (exit)
BPF_MOV64_IMM(BPF_REG_0, 1),                    // r0 = 1
BPF_EXIT_INSN(),                                // exit, return r0
```
benchmark_before.bpf.out (the first two instructions)
```
BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1, 0),   // r0 = *(u32 *)(r1 + 0)
BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -4), // *(u32 *)(r10 - 4) = r0
```

The comment `call map_lookup_elem` refers to the instruction `r0 = map_lookup_elem(map, &key)`.
The first function parameter `map` is read from `r1`, the second `&key` is read from `r2`.
This function reads a key from the stack memory (in this experiment, key size is set as 4 bytes,
so key = `*(u32 *)r2`), looks up this key in the map pointed to by `r1`,
and returns the value address (i.e., &map[key]) if the key exists in the map,
else returns `NULL` (i.e., 0).

The instruction `BPF_LD_MAP_FD` occupies two "slots", i.e., the space of two "regular" BPF instructions. 
A 64-bit map descriptor is divided into two 32-bit immediate numbers stored in two separate slots.

#### Changing the input program

Suppose we wanted to modify the input program from `benchmark_before.bpf` to `benchmark_after.bpf`. 
We can recompile the program and observe the new output that K2 will produce.

Run the command to see the difference between `benchmark_before.bpf` and `benchmark_after.bpf`.
```
diff benchmark_before.bpf benchmark_after.bpf
```

You should see
```
1,4c1,4
< BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1, 0),
< BPF_STX_MEM(BPF_H, BPF_REG_10, BPF_REG_0, -4),
< BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1, 2),
< BPF_STX_MEM(BPF_H, BPF_REG_10, BPF_REG_0, -2),
---
> BPF_MOV64_IMM(BPF_REG_0, 0),
> BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -4),
> BPF_MOV64_IMM(BPF_REG_0, 1),
> BPF_STX_MEM(BPF_B, BPF_REG_10, BPF_REG_0, -5),
```

Here are some notes to understand the changes in the `benchmark_after.bpf` program relative to `benchmark_before.bpf`.

You may observe that the third and fourth instructions are redundant, since the rest of the program does not read from
`(r10 - 5)`.

```
BPF_MOV64_IMM(BPF_REG_0, 0),                   // r0 = 0
BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -4), // *(u32 *)(r10 - 4) = r0
BPF_MOV64_IMM(BPF_REG_0, 1),                   // r0 = 1
BPF_STX_MEM(BPF_B, BPF_REG_10, BPF_REG_0, -5), // *(u8 *)(r10 - 5) = r0
```

Let's run the command that invokes K2 to optimize `benchmark_after.bpf`. The output is stored in `benchmark_after.bpf.out`
This usually takes about 40 seconds.

```
sh k2.sh benchmark_after.bpf
```

Run the following command to see the difference between the input and output programs
```
diff benchmark_after.bpf benchmark_after.bpf.out
```

You may get (this is the result from one of our runs)
```
1,4c1
< BPF_MOV64_IMM(BPF_REG_0, 0),
< BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -4),
< BPF_MOV64_IMM(BPF_REG_0, 1),
< BPF_STX_MEM(BPF_B, BPF_REG_10, BPF_REG_0, -5),
---
> BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),
```

K2 has discovered an optimization using the instruction
```
BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),  // *(u32 *)(r10 - 4) = 0
```
K2 reduces 4 instructions to 1 instruction by directly storing an immediate number on the stack and removing the redundant instructions.

---

### 2.2 K2 language (optional)

This subsection discusses the same process as 2.1 (making a change to the input program and observing different outputs), with the main difference that the program is encoded in the K2 language. The language is mainly used inside our compiler for ease of development and is not something that regular BPF developers use as a surface language.  K2 opcodes have a one-to-one correspondence with the set of BPF assembly opcodes. You could look at the source code of our BPF interpreter (in /sigcomm21_artifact/dependencies/superopt/src/isa/ebpf/inst.cc in the container) for more details.

#### Run
Estimated runtime: 25 seconds.
```
cd ../2_k2_inst
sh k2.sh benchmark_before.k2
```
The second command feeds program `benchmark_before.k2` to K2, and K2 will produce an output program in
`benchmark_before.k2.out`

#### Result for reference
You will see K2 reduces 12 instructions to 10. 
```
...
original program's perf cost: 12
...
top 1 program's performance cost: 10
...
```
Run the following command to see the difference between the input and output programs.
```
diff benchmark_before.k2 benchmark_before.k2.out 
```
We can see that two one-byte load-and-store operations are optimized to one two-byte load-and-store operation.
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

Here are some comments to help understand programs.

Note: `call map_lookup_elem` calls funtion `r0 = map_lookup_elem(map, &key)`.
The first parameter `map` is read from `r1`, the second `&key` is read from `r2`.
This function reads key from the stack (in this experiment, key size is set as 2 bytes,
so key = `*(u16 *)r2`), then looks up this key in the map,
returns the value address (i.e., &map[key]) if the key is in the map,
else returns `NULL` (i.e., 0).

benchmark_before.k2:
```
LDXB 0 1 0    // r0 = *(u8 *)(r1 + 0)
STXB 10 -2 0  // *(u8 *)(r10 - 2) = r0
LDXB 0 1 1    // r0 = *(u8 *)(r1 + 1)
STXB 10 -1 0  // *(u8 *)(r10 - 1) = r0
LDMAPID 1 0   // r1 = map fd 0
MOV64XY 2 10  // r2 = r10
ADD64XC 2 -2  // r2 += 2
CALL 1        // call map_lookup_elem
JEQXC 0 0 1   // if r0 == 0, jmp 1 (exit)
MOV64XC 0 1   // r0 = 1
EXIT          // exit, return r0

```

benchmark_before.k2.out: (the first two instructions)
```
LDXH 0 1 0    // r0 = *(u16 *)(r1 + 0)
STXH 10 -2 0  // *(u16 *)(r10 - 2) = r0
```

#### Changing the input program

Here, we modify the input program from `benchmark_before.k2` to `benchmark_after.k2`. 
We can observe that K2 will produce a different output.

Run the command to see the difference between `benchmark_before.k2` and `benchmark_after.k2`.
```
diff benchmark_before.k2 benchmark_after.k2
```

You will get
```
1,4c1,4
< LDXB 0 1 0
< STXB 10 -2 0
< LDXB 0 1 1
< STXB 10 -1 0
---
> MOV64XC 0 0 
> STXH 10 -2 0
> MOV64XC 0 1
> STXB 10 -5 0
```

Here are some comments to help understand `benchmark_after.k2`.

Note: the third and fourth instructions are redundant, since the remaining program does not read from
`(r10 - 5)`.
```
MOV64XC 0 0   // r0 = 0
STXH 10 -2 0  // *(u16 *)(r10 - 2) = r0
MOV64XC 0 1   // r0 = 1
STXB 10 -5 0  // *(u8 *)(r10 - 5) = r0
```

Run the following command to invoke K2 to optimize `benchmark_after.k2` and store the output in `benchmark_after.k2.out` (estimated runtime: 20 seconds.)
```
sh k2.sh benchmark_after.k2
```

Run the following command to see the difference between the input and output programs
```
diff benchmark_after.k2 benchmark_after.k2.out
```

You may see (this is the result from our run)
```
1,4c1
< MOV64XC 0 0 
< STXH 10 -2 0
< MOV64XC 0 1
< STXB 10 -5 0
---
> STDW 10 -8 1
```

Comment to understand the modification:
```
STDW 10 -8 1  // *(u64 *)(r10 - 8) = 1
              // It means that Mem[r10 - 7: r10 - 1] is set as 0, while Mem[r10 - 8] is set as 1
              // In your run, the immediate number could be others because of the stochastic search
```
K2 reduces 4 instructions to 1 instruction by directly storing an immediate number on the stack and removing redundant instructions.

---

### 2.3 BPF object file

K2 can optimize BPF object files (`.o` files) produced as a result of taking BPF code written in C and compiling with `clang`. The result is another (optimized) object file (`.o`), which can be used as a drop-in replacement for the original file.

#### Run
Estimated runtime: 1 minute.
```
cd ../3_object_file
sh k2.sh xdp1_kern.o xdp1
```
The second command feeds the program `xdp1` in the object file `xdp1_kern.o` to K2, and K2 will produce an output object file `xdp1_kern.o.out`.

#### Result for reference
You will see K2 reduces 61 instructions to 59. 
```
...
original program's perf cost: 61
...
top 1 program's performance cost: 59
...
```
Run the following command to see the difference between the input and output programs. The first
and second commands use `llvm-objdump` to get the disassembly programs from `xdp1_kern.o`and 
`xdp1_kern.o.out`, then store the programs in the corresponding files with the extension of `.objdump`.
```
llvm-objdump -d xdp1_kern.o > xdp1_kern.o.objdump
llvm-objdump -d xdp1_kern.o.out > xdp1_kern.o.out.objdump
diff xdp1_kern.o.objdump xdp1_kern.o.out.objdump
```

We can see that there are two `goto +0` instructions in the output program. For convenience, we use `goto +0` instead of NOP for marking the deletion of this instruction.
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

## 3 Changing compiler parameters

K2 uses stochastic search to find higher-performance programs that are semantically equivalent to the input.
The search uses several parameters. (If you wish to take a look, the [full set of available K2
parameters](https://github.com/smartnic/sigcomm21_artifact/wiki#k2-parameters) is available.)

Optimizing smaller regions of the program at a time allows K2 to scale
to larger program sizes by performing synthesis and verification over smaller programs, 
and composing the smaller results to form larger results (see more details in section 5, `Modular verification`,
in our accepted PDF paper.) We call these smaller (contiguous) program regions _windows_.
There are constraints on the instructions that these windows can contain, documented
in the Appendix of our paper.

In this experiment, we will show how to set the optimization window parameters 
for K2. The manual window setting is mainly for illustration: in practice, we auto-detect
and set these program windows. Specifically, we show explicit settings of two different window 
parameters for the same input program. 

`Note`: In this section, We use `window [s,e]` to represent the program segment from instruction `s` to `e` 
for convenience.

### Run over one window
Estimated runtime: 40 seconds
```
cd ../../3_change_parameters/
sh k2.sh benchmark.bpf 0 3 benchmark_win1.bpf.out
```

This command invokes K2 to optimize window [0,3] for program `benchmark.bpf`, and store the output
program in `benchmark_win1.bpf.out`.


#### Result for reference
For window [0,3], in our run, K2 reduces 16 instructions to 14.

```
...
original program's perf cost: 16
...
top 1 program's performance cost: 14
...
```

Run the following command to see the difference between the input and output programs (window [0,3]).

```
diff benchmark.bpf benchmark_win1.bpf.out
```

We can see that if window is set as [0,3], the first 4 instructions are optimized.

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

Here are some comments to help understand the program.

```
1,4c1,2
< BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1, 0),    // r0 = *(u16 *)(r1 + 0)
< BPF_STX_MEM(BPF_H, BPF_REG_10, BPF_REG_0, -4),  // *(u16 *)(r10 - 4) = r0
< BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1, 2),    // r0 = *(u16 *)(r1 + 2)
< BPF_STX_MEM(BPF_H, BPF_REG_10, BPF_REG_0, -2),  // *(u16 *)(r10 - 2) = r0
---
> BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1, 0),    // r0 = *(u32 *)(r1 + 0)
> BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -4),  // *(u32 *)(r10 - 4) = r0
```


### Run over second window
Estimated runtime: 40 seconds
```
sh k2.sh benchmark.bpf 4 5 benchmark_win2.bpf.out
```

For this command, K2 takes the same program `benchmark.bpf` as an input to optimize window [4,5] 
and stores the output program in `benchmark_win2.bpf.out`


#### Result for reference
For window [4,5], the number of instructions is reduced to 15.

```
...
original program's perf cost: 16
...
top 1 program's performance cost: 15
...
```

Run the following command to see the difference between the input and output programs (window [4,5]).
```
diff benchmark.bpf benchmark_win2.bpf.out
```
We can see that instructions 4 to 5 are optimized if window is set as [4,5].

```
5,6c5
< BPF_MOV64_IMM(BPF_REG_0, 1),
< BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -16),
---
> BPF_ST_MEM(BPF_DW, BPF_REG_10, -16, 1),
```

Here are some comments to help understand the programs.

```
< BPF_MOV64_IMM(BPF_REG_0, 1),                      // r0 = 1
< BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -16),  // *(u64 *)(r0 - 16) = r0
---
> BPF_ST_MEM(BPF_DW, BPF_REG_10, -16, 1),           // *(u64 *)(r0 - 16) = 1
```

If you take a look at [the full command line](https://github.com/smartnic/sigcomm21_artifact/blob/master/3_change_parameters/k2.sh#L38) that is used to invoke the compiler in this exercise, you may see that the window settings are incorporated using the flags `--win_s_list` and `--win_e_list`. 

---

## 4 Specific ACM SIGCOMM criteria for artifact functionality

[Estimated reading time: 2 minutes]

_Documentation_: Our artifact includes the Docker container, which includes the primary source code of the compiler as well as some subsidiary repositories containing experimental evaluation scripts. This README serves as the documentation of the compiler showing how to exercise the artifact.

_Completeness_: The source code of the compiler attached in the container (see the `dependencies` folder in the container) contains all the main components of the compiler described in the paper. Inside the folder `/sigcomm21_artifact/dependencies/superopt` in the container:

`src/search` contains the code related to the stochastic search (section 3 in the paper)

`src/verify` contains the generic framework for program equivalence checking within K2 (high-level section 4 logic)

`src/isa/ebpf` contains the formalization of the BPF instruction set in first-order logic, for both program equivalence checking and safety (sections 4, 5, 6)

_Exercisability_: The code needed to run the experiments in the paper is in the folder `4_reproduce_results` in the container image. Detailed instructions to reproduce the results are provided below.

---

# Reproduction of empirical evaluation results

## 5 Improvements in program compactness from K2 (Table 1 in the submitted paper)

### Run
Estimated runtime: 1 hour 30 minutes
```
cd ../4_reproduce_results/1_insn_count
sh insn_count.sh
```

#### Result for reference
Note: the result reproduced on your machine may be different to the result from our run
because of the stochastic search. The key point is that `Number of instructions` of K2
is the same as/similar to the corresponding results in the table showing here.
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

## 6 Reductions in equivalence-checking time (Table 3 in the submitted paper)

### Run
Estimated runtime: 2 hours
```
cd ../2_eq_chk_time
sh eq_chk.sh
```


#### Result for reference
Note: the result reproduced on your machine may be different from the result from our run.
The key point is that for each benchmark, equivalence-checking time with optimizations
I,II,III,IV is smaller than that without at least one optimizations. Here is a sample result
that we obtained.

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

## 7 Latency/Throughput Benefits (Table 2 in the submitted paper)
This section describes how to validate the experimental claim about latency/throughput improvements in code produced by K2. _This experiment takes the longest time to run among all our experiments._ (total estimated machine time: 15 hours, human time: 40 minutes). The high-level steps are as follows.

1) [Set up an experiment on the NSF CloudLab testbed](#72-cloudlab-experiment-setup) using credentials that we provided on hotCRP. 
2) [Measure the latency-throughput profile of one benchmark](#73-measure-and-interpret-one-benchmark-program) by varying the offered load and measuring the benchmark program's packet-processing rate, packet drop rate, and the round-trip latency of the packets that were successfully processed without dropping. The experiment graphs these quantities as a function of the offered load. We will describe how to obtain the throughput (MLFFR) and the tail latency (latency at the MLFFR) of the benchmark from the corresponding curve.
3) [Run a long-lived experiment covering multiple benchmarks](#74-obtain-all-latency-throughput-curves) to obtain similar curves for all variants of benchmark programs. 

### 7.1 An important caveat about latency and throughput numbers from this experiment
We are using a different setup from the one used in the paper submission for replicating this experiment. We are using a machine with an Intel architecture (cloudlab instance `xl170`) rather than an AMD architecture (cloudlab instance `d6515`). This change occurred due to two reasons.
(1) We consistently found it hard to obtain `d6515` machines on CloudLab, due to conflicting reservations from other users. There are just more instances of `xl170` available.
(2) We found results from the Intel architecture more repeatable and reliable, with the benefits of additional performance-enhancing features that we plan to use for the final numbers in the camera-ready version of our paper.
For these reasons, the throughput and latency numbers won't exactly match those in Table 2 in the paper submission. Instead, the main claim we wish to validate is that: relative to the best version produced by `clang`, code produced by K2 has (1) similar or better throughput (MLFFR), and (2) lower tail latency (i.e., the latency at the MLFFR).

### 7.2 CloudLab Experiment Setup 

[Estimated Human Time: 30 minutes]

#### Step 1: Create Experiment

Visit https://cloudlab.us/ and click the "Log in" button. Please use the CloudLab account username and password provided in our SIGCOMM21 artifact hotCRP submission to log into the CloudLab console.

##### Step 1.1: Start Experiment 
<img src="instruction-images/start.png" width="700px" />

##### Step 1.2: Change Profile
<img src="instruction-images/change-profile.png" width="700px" />

##### Step 1.3: Select xl170-centos7-ubuntu20 Profile
<img src="instruction-images/save-profile.png" width="700px" />

##### Step 1.4: Name Experiment (optional)
<img src="instruction-images/name-expr.png" width="700px" />

##### Step 1.5: Start or Schedule Experiment
You can choose to start the experiment right away (just click "Finish" in the screen below) or schedule it to start at some time in the future. 

The default/initial duration for which an experiment may run (i.e., the time that the machines will be available to you) is 16 hours. You can extend an experiment later after the experiment boots up.

<img src="instruction-images/schedule.png" width="700px" />

*You may encounter the following failures/slow cases:*

Sometimes, starting an experiment can fail when CloudLab has insufficient resources available. If your experiment fails due to insufficient resources, you can check for future resource availability at https://www.cloudlab.us/resinfo.php -- look for the future availability of machine instances of type "xl170" in the Utah cluster. You need at least 2 available machines for our experiment. You can also make reservations for machines at a future time by following instructions from http://docs.cloudlab.us/reservations.html. Please contact us if you have any difficulty.

If your experiment is successfully scheduled, it might still keep you waiting with the message `Please wait while we get your experiments ready`. This can happen sometimes since we use a custom disk image. Please be patient for a few minutes. 

Contact us or the CloudLab mailing list (https://groups.google.com/g/cloudlab-users) if you have any difficulties.

#### Step 2: Configure The Nodes

The experiment consists of two nodes, labeled node-0 and node-1. Node-0 serves as the device-under-test (DUT), which runs the packet processing programs we're evaluating. Node-1 runs a traffic generator. By sending and receiving from the same machine, the traffic generator measures both the throughput and the round-trip latencies of packets that are processed by the device under test. The detailed setup is described in section 8 of the submitted paper.

<img src="instruction-images/latency-throughput-setup.png" width="400px">

##### Step 2.1: Update Node 1 (Traffic Generator) Configurations
1) SSH into node-1.  You can determine the name of the node-1 and node-0 machines from the CloudLab console (go to "list view" once the experiment is ready)
 
 <img src="instruction-images/cloudlab-listview.png" width="700px">
 
 You must use the private key provided as part of our hotCRP submission to login into the machine labeled node-1 (`hp125.utah.cloudlab.us` in the example above). Suppose you've named the file containing the private key (from hotCRP) `my.key`.  Type
 
 ```
 ssh -p 22 -i my.key reviewer@hp125.utah.cloudlab.us
 ```
 
 Sometimes, this step might fail with the error `Permission denied (publickey)`. If that happens to you, consider adding the private key to your SSH agent, using the command `ssh-add my.key` and re-try SSHing.
 
3) Once logged into node-1, use your favorite text editor to add the following line to ~/.bash_profile.

   ```export PYTHONPATH=/usr/local/v2.87/automation/trex_control_plane/interactive``` 


4) `cd /usr/local/trex-configuration/`

5) Run `./update-scripts.sh`. When prompted, enter the following details for your experiment. The user@DUT (device under test) string is `reviewer@<insert node-0 name you found above>` and the device type should be `xl170`. For the example shown above, the full exchange looks like the following:

```
reviewer@node-1 trex-configuration]$ ./update-scripts.sh 
Setting up some information
Enter DUT as (username@machine):reviewer@hp124.utah.cloudlab.us
Enter Device type (d6515 or xl170):xl170
```

6) Exit the session and log into node-1 again. 
 
##### Step 2.2: Upload the Given SSH Private Key to node-1

You will upload the SSH private key provided to you on hotCRP into node-1, so that it can remotely control node-0 (the DUT). Suppose your private key is stored in a file `my.key` on your local machine.

1) *On your own machine*, run the command
```
scp -i my.key my.key reviewer@hp125.utah.cloudlab.us:~/.ssh/id_ed25519
```

2) *On node-1*, test that you can ssh into node-0. _Do not skip this check!_ On the node-1 machine you're currently logged into, type 

```
ssh -p 22 reviewer@hp124.utah.cloudlab.us
```

where you will replace hp124.utah.cloudlab.us by the name of the node-0 machine from the CloudLab console. You should be able to connect to node-0. Then, exit out of node-0 session.

### 7.3 Measure and Interpret One Benchmark Program

[Total Estimated Machine Time: 1 hour; Human Time: 10 minutes]

Now that the experiment is fully set up, we can stress test the DUT with traffic from the traffic generator at various offered loads (Tx rates) and look at how throughput (Rx rate) and latencies (average latency of packets returned to the traffic generator) vary with the offered load.  Some of our benchmarks just drop packets at high speeds (a useful capability in itself, e.g., for DDoS mitigation). For those benchmarks, we can only measure throughput as reported by a program running on the DUT itself. We show both kinds of programs (benchmarks that will forward packets back as well as those that just drop) below.  We consider the experiments in this section as "warm-ups" since they tell you how to measure and interpret one trial of one benchmark program; the full set of experiments for all benchmarks are in the next subsection. 

Note: All data and logs, graphs are saved in your home directory on Cloudlab. The CloudLab server images don't come with GUIs, so in order to view graphs, you will need to copy the file to local computer. Instructions are provided below.

#### Warmup 1: Run one trial of a benchmark that FORWARDS PACKETS BACK to the traffic generator. 
[Estimated Machine Run Time: 30 minutes; human time: 1 minute]

1) SSH into node-1: e.g. `ssh -p 22 -i my.key reviewer@hp125.utah.cloudlab.us` where `my.key` is the private SSH key on your local computer and `hp125.utah.cloudlab.us` is replaced with the name of the `node-1` machine in your experiment.
2) Change to directory: `cd /usr/local/v2.87`
3) Start run: `nohup python3 -u run_mlffr.py -b xdp_fwd -v o1 -d xdp_fwd/ -n 1 -c 6 &`. This proccess will run in the background. Just press Enter. 
4) Check progress of logs `tail -f $HOME/nohup.out`
5) Once it has completed running (it will say *Completed Full Script* in the logs, takes about 30 minutes), you will now generate the graphs. `cd /usr/local/trex-configuration/visualize-data-scripts/`
6) Generate throughput graph: `python3 rx_plot.py -d ~/xdp_fwd -v o1 -b xdp_fwd -r 0`  
The graph will be located in the `$HOME/xdp_fwd/rx` directory and is called `0.png`. 
7) Generate latency graph: `python3 latency.py -d ~/xdp_fwd -type avg -v o1 -b xdp_fwd`  
The graph will be located in `$HOME/xdp_fwd/` directory and is called `o1_avgL.png`.
8) Copy the graphs and view them on your computer. *On your machine*, execute the following commands.
`scp -i my.key reviewer@hp025.utah.cloudlab.us:/users/reviewer/xdp_fwd/rx/0.png .`  
`scp -i my.key reviewer@hp025.utah.cloudlab.us:/users/reviewer/xdp_fwd/o1_avgL.png .`   
where you will replace `hp025.utah.cloudlab.us` with the name of your corresponding `node-1` machine.

##### Interpreting the graphs

Sample graphs that you obtain may look like the following:

<img src="instruction-images/0.png" width="400px"> <img src="instruction-images/O1_avgL.png" width="400px">

The graph on the left-hand side shows the rate at which packets were forwarded (labeled `Rx rate`) by the BPF program `xdp_fwd` in millions of packets per second per core, plotted against the offered load from the traffic generator (labeled `Tx rate`). Here, the variant of `xdp_fwd` being evaluated is the BPF bytecode generated by compiling the source with `clang -O1`. The graph on the right-hand side shows the average round-trip latency (reported in microseconds) for packets that were processed successfuly by `xdp_fwd` and returned to the traffic generator. (The average latency does not include dropped packets, which have "infinite" latency).

We define the throughput as the _maximum loss-free forwarding rate (MLFFR)_ (RFC 1242/2544), i.e., the Rx rate after the Rx rate tilts away from its linear growth with respect to the Tx rate and flattens out. The latency at the MLFFR (read off at the corresponding x-value from the graph on the right-hand side) is the tail latency of the program. In the graph above, we might report the throughput of `xdp_fwd -O1` to be slightly above 4.9 Mpps with a tail latency of ~75 microseconds, which is the latency at 4.9 Mpps. (These numbers won't exactly match those in Table 2 in the paper, see our [caveat](#An-important-caveat-about-latency-and-throughput-numbers-from-this-experiment)). The latency curve tapers off at 200 microseconds, which corresponds to the buffering available (e.g., in the NIC) before packet drops occur.

#### Warmup 2: Run one trial of a benchmark that DROPS ALL PACKETS.
[Estimated Machine Run Time: 30 minutes; human time: 1 minute]

1) SSH into node-1: e.g. `ssh -p 22 -i my.key reviewer@hp125.utah.cloudlab.us` where `my.key` is your private ssh key on your local computer and hp125 will be replaced with node-1 in your experiment.
2) Change to directory: `cd /usr/local/v2.87`
3) Start run: `nohup python3 -u run_mlffr_user.py -b xdp_map_access -v o1 -d xdp_map -n 1 -c 6 > $HOME/map.txt &`. This proccess will run in the background; therefore, press enter. 
4) Check progress of logs `tail -f $HOME/map.txt`
5) Once it has completed running (it will say *Completed Full Script* in the logs), you will now generate the graphs. The logs are located in node0.
6) SSH to node0. e.g. `ssh -p 22 -i my.key reviewer@hp124.utah.cloudlab.us`
7) `cd /usr/local/trex-configuration/visualize-data-scripts/` 
8) Generate throughput graph: `python3 generate_user_graphs.py -d ~/xdp_map -v o1 -b xdp_map_access -r 0`  
The graph will be located in `$HOME/xdp_map/rx/` and is called `0.png`.
7) Copy Graphs and View Graphs on your computer. Execute the following on your LOCAL computer.   
`scp -i my.key reviewer@hp024.utah.cloudlab.us:/users/reviewer/xdp_map/rx/0.png .`
where hp024 is node-0

You may obtain a graph that looks like this. This throughput measurement is reported by a program running directly on the DUT, and not on the traffic generator. Since this only consists of one run, the actual throughput may vary up and down around a certain value, as offered load increases. The throughputs stabilize with more trials. With this single run, we would record the MLFFR throughput at ~15.0 Mpps.

<img src="instruction-images/exercise-2.png" width="400px">

### 7.4 Obtain all latency-throughput curves
[Total estimated machine time: 14 hours]

#### Run three trials of a benchmark that FORWARDS PACKETS back to the traffic generator
[Estimated machine run time: 8 hours; human time: 10 minutes]
1) SSH into node-1: e.g. `ssh -p 22 -i my.key reviewer@hp125.utah.cloudlab.us` where `my.key` is your private ssh key on your local computer and hp125 will be replaced with node-1 in your experiment.
2) Change to directory: `cd /usr/local/v2.87`
3) Start run: `nohup python3 -u run_mlffr.py -b xdp_fwd -d xdp_fwd_all -n 3 -c 6 > $HOME/xdp_fwd_log.txt &`. This proccess will run in the background; therefore, press enter. 
4) Check progress of logs `tail -f $HOME/xdp_fwd_log.txt`
5) Once it has completed running (it will say *Completed Full Script* in the logs), you will now generate the graphs.
`cd /usr/local/trex-configuration/visualize-data-scripts/` 
5) Generate throughput and latency graphs: `python3 generate_graphs.py -d ~/xdp_fwd_all -b xdp_fwd -r 3`
6) The latency graph is located in `~/xdp_fwd_all/avgL/avg.png` and the throughput graph is located in `~/xdp_fwd_all/rx/avg.png`.

The results are the average of three trials. The raw data is located in `~/xdp_fwd_all/avgL-data.csv` and `~/xdp_fwd_all/rx-data.csv`. You may see graphs that look like this:

<img src="instruction-images/avg.png" width="400px" /> <img src="instruction-images/avg-latency-xdpfwd.png" width="400px" />

(If needed, see [how to interpret throughput-latency graphs](#interpreting-the-graphs) for a refresher on understanding one curve from this graph.) From the graphs above, we would write down the MLFFR throughput of the `-O1` variant of `xdp_fwd` as 4.9 Mpps. With the resolution available in the Tx rates on the x-axis, the MLFFR of the other variants (`-O2` and all the variants produced by K2, labeled `kX`) is also roughly 4.9 Mpps. The latency at the MLLFR of the best clang variant is ~57 microseconds (for `-O2`) and that of the best K2 variant (for `k2`) is ~50 microseconds.

#### Run three trials of a benchmark that DROP ALL PACKETS
[Estimated machine run Time: 6 hours, human time: 10 minutes]
1) SSH into node-1: e.g. `ssh -p 22 -i my.key reviewer@hp125.utah.cloudlab.us` where `my.key` is your private ssh key on  your local computer and hp125 will be replaced with node-1 in your experiment.
2) Change to directory: `cd /usr/local/v2.87`
3) Start run: `nohup python3 -u run_mlffr_user.py -b xdp_map_access -d xdp_map_all -n 3 -c 6 > $HOME/map_all.txt &`. This proccess will run in the background; therefore, press enter. 
4) Check progress of logs `tail -f $HOME/map_all.txt`
5) Once it has completed running (it will say *Completed Full Script* in the logs), you will now generate the graphs.
`cd /usr/local/trex-configuration/visualize-data-scripts/` 
5) Generate throughput graphs: `python3 generate_user_graphs.py -d ~/xdp_map_all -b xdp_map_access -r 3 -average`
6) The throughput graph is located in  `~/xdp_map_all/rx/avg.png`

You might see a result that looks like this. These are averages over 3 trials. The raw data is in `~/xdp_map_all/avg_parsed_data.csv`.

<img src="instruction-images/avg-mapaccess.png" width="400px" />

The peak throughput of the best K2 variant is ~15.5 Mpps (`k1`) and that of the best `clang` variant (`O1`) is ~15 Mpps.

---

## 8 Efficacy of safety checks (Table 7 in the submitted paper appendix)

_Note: this experiment runs on the NSF cloudlab testbed. If you haven't finished [setting up the CloudLab experiment](#72-cloudlab-experiment-setup), please do that first._

This section evaluates whether the programs optimized by K2 can pass the kernel checker. We test this by
`loading` the BPF programs into the kernel. If the program can be successfully loaded, it means this program passes
the kernel checker. Otherwise, we will receive an error from the kernel checker. Since it takes a long time 
(more than 12 hours) for K2 to optimize all benchmarks in table 7, we directly use the optimized programs 
from the [compiler logs](https://github.com/smartnic/throughput-experiments/tree/main/completed-programs) 
produced by K2 when we submitted the manuscript.

`Note.` There is a typo in Table 7 in the submitted paper. K2 produced 3 unique programs for benchmark 
`xdp_pktcntr` instead of 5. We will fix this error in the camera-ready version.

### Run

Estimated runtime: 2 minutes 30 seconds

SSH into node-0: suppose currently you are on the node-1 machine
```
ssh -p 22 reviewer@hp124.utah.cloudlab.us
```
where you will replace hp124.utah.cloudlab.us by the name of the node-0 machine from the CloudLab console.

```
cd /usr/local/trex-configuration/safety_chk
sudo python3 safety_chk.py
```

### Expected result:
```
+-----------------+---------------------+------------------------------+
|    Benchmark    | # variants produced | # accepted by kernel checker |
+-----------------+---------------------+------------------------------+
|       xdp2      |          5          |              4               |
|      xdp_fw     |          5          |              5               |
| xdp_router_ipv4 |          5          |              4               |
|     xdp_fwd     |          5          |              5               |
|   xdp_pktcntr   |          3          |              3               |
|       xdp1      |          5          |              5               |
|  xdp_map_access |          5          |              5               |
|   xdp_redirect  |          5          |              4               |
+-----------------+---------------------+------------------------------+
```

---

The End. 
