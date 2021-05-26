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
of BPF programs. K2 produces code with 6--26% reduced size, reduces
average latency by 13--85 microseconds in our setup,
and improves the number of packets per second
processed per core by up to 5% relative to `clang -O3`,
across programs drawn from
production systems at Cilium and the Linux kernel. BPF programs produced by
K2 can pass the kernel checker.

## Claims to validate
We provide instructions to help validate the following claims about the paper. 

*Artifact availability. (section 0).* The source code of the K2 compiler and all subsidiary repositories and evaluation scripts are publicly available at https://github.com/smartnic/ We also make a [Docker container](https://github.com/smartnic/sigcomm21_artifact#0-instructions-to-run-the-artifact) available for anyone who wishes to quickly run the compiler and reproduce smaller results. The `install.sh` script in this repository provides instructions to download all the required components if one is building a container image from scratch.

*Artifact functionality (sections 1 through 4).* We show how to exercise the compiler through different inputs, input formats, and parameters. 

1. [Hello world](https://github.com/smartnic/sigcomm21_artifact#1-hello-world)
This task exercises all of K2's main software components by showing how to optimize a small, simple program. [total estimated machine time: 1 minute; human time: 5 minutes]

2. [Changing the input program.](https://github.com/smartnic/sigcomm21_artifact#2-Changing-the-input-program)
We show how a user might change the input program to K2 to obtain
different outputs. K2 accepts programs in three formats: [BPF C macros](https://github.com/smartnic/sigcomm21_artifact#21-bpf-c-macros)
used by the Linux kernel (file extension .bpf), a home-grown instruction format we
developed that we call this the [K2 macro language](https://github.com/smartnic/sigcomm21_artifact#22-k2-language-optional) (files with extension
.k2), and [pre-compiled BPF object files](https://github.com/smartnic/sigcomm21_artifact#23-bpf-object-file). The compiler will output
optimized versions of the programs in the same format that is
consumed. [total estimated machine time: 4 minutes; human time: 15 minutes]

3. [Changing compiler parameters.](https://github.com/smartnic/sigcomm21_artifact#3-changing-compiler-parameters)
We show how a user might modify the parameters fed to K2 by modifying
the K2 command line in our scripts. The [full set of available K2
parameters](https://github.com/smartnic/sigcomm21_artifact/wiki#k2-parameters) is available.
[total estimated machine time: 2 minutes; human time: 10 minutes]

4. [Specific ACM SIGCOMM criteria for artifact functionality.](https://github.com/smartnic/sigcomm21_artifact#4-Specific-ACM-SIGCOMM-criteria-for-artifact-functionality)
This section explicitly addresses the three criteria for artifact functionality described in the [call for artifacts](https://conferences.sigcomm.org/sigcomm/2021/cf-artifacts.html). [total estimated (human) time: 2 minutes]

*Reproduction of results (sections 5 through 7).* We show how to reproduce the main claims in the empirical evaluation of the paper.

5. [Instruction count reduction](https://github.com/smartnic/sigcomm21_artifact#5-improvements-in-program-compactness-from-k2-table-1-in-the-paper): We provide
scripts to reproduce a subset of results on the reductions in program
instruction counts that K2 can obtain (table 1 in the submitted
paper). The subset of benchmarks chosen corresponds to those programs
that we believe can run fast enough on a user's laptop -- we chose
benchmarks where the best programs were found within 30 minutes in our
submission. Our paper submission claims program compaction anywhere between
6 -- 26%. [total estimated time: 90 minutes.]

6. [Impact of optimizations on equivalence-checking time](https://github.com/smartnic/sigcomm21_artifact#6-reductions-in-equivalence-checking-time-table-3-in-the-paper): We provide scripts to
reproduce a subset of results on the impact of optimizations on
reductions in equivalence-checking time (table 3 in the submitted paper).
The subset of benchmarks chosen corresponds to those programs that 
we believe can run fast enough on a user's laptop -- we chose
benchmarks where the experiment can finish running within 1 hour in our
submission. Our paper submission claims an average 5 orders of magnitude reduction
in equivalence-checking time. However, the subset of (faster) benchmarks in the container
may only show about 4 orders of magnitude of benefit (10,000X or more).
[total estimated time: 120 minutes.]

7. [Latency/throughput benefits](): We provide scripts to reproduce a subset
of results from our empirical evaluation of throughput and latency of
programs optimized by K2 (table 2 in the submitted paper). This requires
[setting up an experiment on CloudLab]() using the credentials and disk
images that we provided. *This experiment takes a while to run* -- however,
it runs on a server-class machine that you will be set up to run on. Once
the longer experiments start, they require your attention only after a few
hours.  

Our paper submission claims that the best programs produced by K2
produce -0.03--5% higher throughput and 13--85 microseconds of lower
latency than the most optimized versions produced by Clang. Due to the
slightly different setup between the paper submission and the
replication setup, the exact numbers you will see will differ from
those in Table 2 in the submission.  However, our main claim about the
reduction in tail latencies (i.e., the latency at the MLFFR, see
section 8 in the submitted paper) with similar or better throughput
(i.e., the MLFFR) still holds.  [total estimated machine time: 15
hours; human time: 40 minutes]

## Notes and caveats
1. The results shown below can only be used for reference.
Since K2 leverages stochastic search, we cannot guarantee that the results
are exactly the same for every run.  We have observed that small programs
often exhibit deterministic behavior.

2. K2 is a synthesizing compiler that optimizes BPF programs better than
traditional compilers like clang. However, it does so at the expense
of additional compile time. When you run the compiler on a program,
you may often need to wait longer (e.g., than using `clang`) to see results. We have
made our best efforts to provide sample programs that can be
near-interactively compiled on a reasonably powerful laptop, and we
provide estimations of how long you might have to wait for each compilation to
finish.

3. The estimated times for the evaluation of the artifact are based on a machine 
with 3.1 GHz Dual-Core Intel Core i7 processor, 16 GB 1867 MHz DDR3 memory.

---

## #0. Instructions to run the artifact

### Downloading the prebuilt Docker Image

1. Install docker if it is not installed already by following the
[Docker install documentation](https://docs.docker.com/install/).

2. Download the prebuilt docker image (shasum: 469dbb6cb935342bd7fbd5687c395ba9cb7ef5e5)
```
https://drive.google.com/file/d/1Td3yM0PNLgBRf7Y_XlPAP9vbNHMeYrBl/view?usp=sharing
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
The compiler takes an input program `benchmark.k2` written in the K2 language, optimizes this program and produces an output
program `benchmark.k2.out` in the K2 language.

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
In this experiment, we introduce three input-output program formats supported by K2: BPF C macros, the K2 macro language, and pre-compiled BPF object files, and show how a user might modify a given program to see different outputs. Kernel developers often hard-code BPF assembly similar to the first format (BPF C macros); most real code that uses BPF is written in C and compiled by `Clang` into the BPF object file format, which corresponds to the third format (pre-compiled BPF object files). We show all three program formats since the first two formats are easier to read and understand (especially to understand specific optimizations), while the last format is practically the most used and deployed.

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
benchmark_before.bpf.out (the first two intructions)
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
One of the slots holds a 64-bit map descriptor.

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

This subsection discusses the same process as 2.1 (making a change to the input program and observing different outputs), with the main difference that the program is encoded in the K2 macro language. The language is mainly used inside our compiler for ease of development and is not something that regular BPF developers use as a surface language.  K2 opcodes have a one-to-one correspondence with the set of BPF assembly opcodes. You could look at the source code of our BPF interpreter (in /sigcomm21_artifact/dependencies/superopt/src/isa/ebpf/inst.cc in the container) for more details.

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
              // It means that (r10 - 7) to (r10 - 1) are set as 0, (r10 - 8) is set as 1
              // In your run, the immediate number could be others because of the stochastic search
```
K2 reduces 4 intructions to 1 instruction by directly storing an immediate number on the stack and removing redundant instructions.

---

### 2.3 BPF object file

K2 can optimize BPF object files (`.o` files) produced as a result of taking BPF code written in C and compiling with `clang`. The result is another (optimized) object file (`.o`), which can be used as a drop-in replacement for the original file.

#### Run
Estimated runtime: 1 minute.
```
cd ../3_object_file
sh k2.sh xdp1_kern.o xdp1
```
The second command feeds the program `xdp1` in the object file `xdp1_kern.o` to K2, and K2 will produce an output object file in `xdp1_kern.o.out`

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
`xdp1_kern.o.out`, then store the programs in the corresponding files with the extension of .objdump.
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

`Note`: In this section, We use `window [s,e]` to represent the program segment from `s` to `e` 
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
and stores output program in `benchmark_win2.bpf.out`


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

## Reproduction of empirical evaluation results

## 5 Improvements in program compactness from K2 (Table 1 in the paper)

### Run
Estimated runtime: 1 hour 30 minutes
```
cd ../4_reproduce_results/1_insn_count
sh insn_count.sh
```

#### Result for reference
Note: the result reproduced on your machine may be different to the result from our run
because of the stochastic search. The keypoint is that `Number of instructions` of K2
is the same as / similar to the table showing here.
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

## 6 Reductions in equivalence-checking time (Table 3 in the paper)

### Run
Estimated runtime: 2 hours
```
cd ../2_eq_chk_time
sh eq_chk.sh
```


#### Result for reference
Note: the result reproduced on your machine may be different from the result from our run.
The key point is that for each benchmark, equivalence-checking time with optimizations
I,II,III,IV is smaller than that without at least one of optimizations. Here is a sample result
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

The End. 
