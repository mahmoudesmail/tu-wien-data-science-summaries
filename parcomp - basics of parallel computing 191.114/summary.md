# computer architecture

parallel computing = simultaneous use of compute

_cluster_

- contains multiple **nodes** / systems
- common in high performance computing, where each node has many processors connected with high bandwidth communication networks

_mainboard / system_

- a motherboard can have multiple **sockets** that each can house their own **CPU**

_cpu_

- https://stackoverflow.com/a/23795705/13045051
- processor / processing unit → ambiguous term, some say that the cores are the processors
- <100 parallel threads
- can contain multiple **cores**

_gpu_

- = graphics processing unit
- can be integrated into the CPU or be a dedicated card (ie. PCI)
- 1000+ parallel threads
- huge number of small **cores**

_core_

- smallest unit that can execute instructions
- equivalent to a standalone single-core CPUs
- contain: arithmetic logic unit ALU, floating point unit FPU, multiple levels of cache to hide memory access times, branch predictions etc.
- synced with an interconnedction network

_UMA / NUMA_

- 2 types of multi-processor systems
- based on how you place the main memory DRAM
- a) uniform memory access
     - = all CPUs access the same memory
- b) non-uniform memory access
     - = each CPU might get access to a different memory at a different time
     - happens when you place several CPUs on mainboard sockets
     - cache coherency is maintained

_processes vs. threads_

- **processes**:
     - can contain multiple threads
     - heavier, higher isolation, own address space
     - slow inter process communication
     - expensive context switches
- **threads**:
     - lightweight, lower isolation, shared address space
     - fast access to shared variables
     - cheap context switches
- **hyper-threads**:
     - intel term for: simultaneous multithreading SMT
     - logical cores = scheduling multiple thread instructions per core

*levels of parallelism*

- **parallelism at bit-level:** vector operations
- **pipeline parallelism:** overlaps the execution of multiple instructions by dividing the execution process into stages (ie. MIPS). if there are no dependencies between instructions, this allows for a higher throughput of instructions executed per unit time.
- **parallelism by multiple functional units:** modern processors are often multiple-issue processors, meaning they can execute multiple instructions simultaneously using independent functional units like ALUs (arithmetic logical unit), FPUs (floating-point unit), load/store units or branch units. this approach is also known as instruction-level parallelism (ILP).
- **parallelism at process or thread level:** multiple cores on a single processor chip each with its own control flow. multiprocessing, multithreading.

# metrics

_clock speed_

- modern processors do not run all cores with the same frequency
- breakeven efficiency = necessary utilization of a core to match the clock speed of the fastest core in the cpu

_bandwidth_

- number of bytes we can read/write from/to memory in a timeframe
- when we say bandwidth (theoretical) we actually mean throughput (practical metric)

_latency_

- delay between request and response
- when processes are on the same socket, the latency is lower

_speedup_

- $\large S_a(n,p) = \frac{T_{\text{seq}}(n)}{T_{\text{par}}(n,p)}$ = absolute speedup
- $\large S_r(n,p) = \frac{T_{\text{par}}(n, 1)}{T_{\text{par}}(n,p)}$ = relative speedup
- what difference does parallelization make?
- where:
     - $n$ = input size
     - $p$ = number of processors
     - $T_{\text{par}}(n,p)$ = parallel runtime
     - $T_{\text{seq}}(n)$ = sequential runtime
- use the relative speedup when there isn't a sequential implementation

_efficiency of parallelization_

- $\large E(n,p) = \frac{T_{\text{seq}}(n)}{p \cdot T_{\text{par}}(n,p)} = \frac{1}{p} \cdot S_a(n,p)$
- what difference does each processor make?

![](assets/SCR-20240427-cciz.png)

_amdahls law_

- $\large S(n,p)=\frac{   {T_{\text{seq}}^*(n)}}{s \cdot {T_{\text{seq}}^*(n)}   +\frac{1-s}{p} \cdot {T_{\text{seq}}^*(n)}   }=\frac{1}{s+\frac{1-s}p}\leq\frac1s$
- fix $n$, increase $p$, speedup converges to $1/s$
- where:
     - $s \in [0;1]$ = sequential fraction
     - $1 -s$ = parallel fraction that is perfectly parallelizable by $p$ processors
     - $T_{\text{seq}}^*(n)$ = best sequential runtime

_gustafson-barsis law_

- $\large S(n,p) =\frac{s+p \cdot (1-s)}{s+(1-s)}=s+p \cdot (1-s)$
- because: $s + (1-s) = 1$
- scale $n$ with $p$, but the runtime stays the same – but if the parallel load would have been executed sequentially, it would have taken $p$ times longer
- improves amdahls law: the serial fraction doesn't limit speedup if the problem (workload) $n$ can scale with the number of $p$. in that case you can get more done in the same amount of time.

_strong vs. weak scaling_

- strong scaling experiment → fix $n$, increase $p$
- weak scaling experiment → scale $n$ with $p$ (keep problem size per core fixed)
     - ideally the runtime should stay constant, the scaled speedup should be linear
     - be careful with the fraction you scale $n$ with for each added $p$

_cost_

- cost:
     - $C = p \cdot T_{\text{par}}(p,n)$
     - usage time of all $p$ processors (necessity for them to be available, but not necessarily utilized)
- cost optimal:
     - $p \cdot T_{\text{par}}(p,n) \in O(T_{\text{seq}}(n))$
     - having the same asymptotic growth as the fastest-known sequential algorithm

_work_

- work:
     - $W$
     - number of instructions that are executed
- work optimal:
     - $W \in O(T_{\text{seq}}(n))$
     - having the same asymptotic growth as the fastest-known sequential algorithm
     - means perfect load balancing between each of $p$

# openmp

```
#pragma omp directive-name [args...]
```

paradigm: fork-join parallelism / single program multiple data SMPD.

main flow is sequential and manages forking/joining of a "thread team" in a "parallel region".

*directives overview*

- loop constructs - like `for`
- sections - independent execution of parallel regions
- task constructs - independent tasks, similar to sections
- single constructs - like `single`, where only one thread is working

*"for" directive*

- eliminate loop-carried dependencies:
	- read-after-write RAW: flow dependence
	- write-after-write WAW: output dependence
	- write-after-read WAR: antidependence
	- read-after-read RAR: input dependence
- loops must be in "canonical form":
	- loop counter variable must be a private integer, that's not modified inside the loop
	- loop invariant must not change during execution (ie. `i<k`)
	- loop increment must grow linearly (ie. not `i*=2`)
	- now `break` instruction. `goto`, `throw` only allowed if the destination is the loop again
- can have conditions, ie. `if(<cond>)`
- if loops are nested with no intermediary instructions, use `collapse(<depth>)`

*"task" directive*

- mostly used for recursion inside a parallel section. distributed among threads in a thread-team.
- `task shared(i)` - share intermediate results
- `taskwait` - barrier for previous task calls
- `depend(in/out/inout:var)` - completion dependency graph between tasks. you can also use `depend(iterator(...))` to run tasks inside a loop

*shared memory*

- variables can be `shared` or `private` / `firstprivate` / `lastprivate`

*static vs. dynamic load balancing*

- static:
	- = precromputed assignment of tasks to workers
	- good: low overhead
	- bad: possibly inefficient if a worker gets all heavy tasks
- dynamic:
	- = tasks assigned as soon as workers are free again
	- good: fair distribution of work
	- bad: massive overhead

*synchronization*

- enable/disable barrier:
	- `barrier` - barrier synchronization for all threads in team.
	- `no wait` - disable barrier synchronization at the end of parallel region.
- directive args:
	- `reduction(<op>:var)` - use in a for-loop that works similar to `reduce()` in python
	- `master` - only ran by master thread. no implicit barrier at the end.
	- `single` - only ran by a single thread.
	- `critical` - mutual exclusion in critical segment.
	- `atomic` - mutual exclusion for a single instruction.

# optimization tricks

*false sharing*

- the cache sits between CPU and main memory MM
- the cache holds copies of chunks of data from MM as cache-lines/blocks
- multicore systems that are cache-coherent have shared caches at some level
- if a thread updates a cache-line, then the `dirty` flag gets set, which invalidates the cache from all other threads and forces them to load the most recent state from DRAM
- by using a specific write
- you can monitor cache misses on all levels with the `LIKWID` tool

example:

- 4 threads, each writing into `int counter[4];`
- cache line size = 64 Bytes (see:  `cat /proc/cpuinfo | grep cache`)
- integer size = 4 Bytes
- integers per cache line = 64/4 = 16 int
- runtime when just using `malloc()` = 1.374864
- runtime when using `posix_memalign((void**)&counter, 64, nt*64);` = 0.330840
- see: https://stackoverflow.com/a/6563142/13045051

*write-allocate policy*

- avoid write-misses (opposite to cache-misses)
- allocate memory before writes, so hopefully subsequent writes go to cache

*loop unrolling*

- increases instruction level parallelism if used with the right optimization flags during compilation.

```C
for(i=...) {
    sum += a * b[i]
}

// unrolling loop
for(i=...) {
    sum0 += a * b[i]
    sum1 += a * b[i + 1]
    sum2 += a * b[i + 2]
    sum3 += a * b[i + 3]
    ...
}
sum += sum0 + sum1 + ...
```

# roofline model

> S. Williams, A. Waterman, and D. Patterson. “Roofline: An Insightful Visual Performance Model for Multicore Architectures”. In: Communications of the ACM 52.4 (Apr. 2009), p. 65

see: https://crd.lbl.gov/divisions/amcr/computer-science-amcr/par/research/roofline/introduction/

performance models help us estimate how fast code can run at most.

we want to attain peak performance (FLOPs/s) but performance is limited by finite reuse of data and bandwidth.

- **compute limit**:
	- = max GFLOPs/s for floating point operations per processor
- **communication limit**:
	- = max GB/s for memory bandwidth to read data from DRAM to CPU (stream bandwidth)
- **arithmetic intensity AI**:
	- = FLOPs/Bytes of kernel is its ratio of computation vs. traffic
	- programs are kernels: they are thought of as "sequences of computational kernels". in example matrix-vector operations, FFT, Stencil, …
	- we want to know the performance of computational kernels
	- use `LIKWID` to measure

the fastest runtime in GFLOPs/s is bounded by the minimum of either:

- **a) compute-bound**: the machine's max GFLOPs/s
- **b) bandwidth-bound**: arithmetic intensity $\cdot$ the machine's max GB/s

# cuda

docs:

- there are no emulators, you need an nvidia gpu to write cuda
- https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html
- https://developer.nvidia.com/blog/cuda-refresher-cuda-programming-model/

*overview of accelerators*

- **hardware**:
	- nvidia: GPUs
	- amd: ROCm
	- intel: xeon phi series
	- fpgas (field programmable gate arrays)
- **software**:
	- openACC:
		- pragma-based, similar to openMP
	- openMP with offloading:
		- not market-ready, gcc and clang don't work well
	- openCL (open computing language):
		- portable, works on both multicore cpus and gpus, very low level and verbose
	- cuda:
		- nvidia's proprietary api for their gpus
		- c, c++, fortran bindings
		- wrappers in julia, python that use LLVM to generate code

*cuda terminology*

- **host** (cpu, memory) launches kernels on **device** (gpu, memory) and then copies results back to own memory
- a device can run multiple kernels concurrently

*cuda architecture*

- based on: single instruction multiple thread SIMT
- cuda core / streaming processor **SP** $\in$ streaming multiprocessor **SM** $\in$ **GPU**
	- SP = one instruction per thread at a time. optimized for floating-point operations. have their own registers, shared memory, cache.
	- warp = 32 threads in the SM, executing the same instruction at a same time, but on different data. smallest possible execution unit.
	- thread block = group of 1 to 64 warps
	- scheduler/dispatcher = compute resource manager
- thread $\in$ thread block $\in$ kernel grid
	- thread – ran on a single SP
	- thread block – ran on a single SM
	- kernel grid – ran on a single GPU

*memory*

- global memory: `cudaMalloc`
	- shared between all thread blocks
	- memory access pattern is important for latency:
		- memory alignment = utilize max space in memory blocks with respect to boundaries
		- memory coalescing = access contiguous chunks of memory
- unified memory (since version 6.0): `cudaMallocManaged`
	- unified virtual addressing UVA
	- accessible by host and device
	- simpler code, but reduces performance

*syntax*

```
kernel <<<num_Blocks,threads_per_block>>> (args...);

cudaDeviceSynchronize();
```

- kernels are functions
- max number depends on hardware specs
- threads and thread-blocks can be organized into 1D-3D arrays with own coordinates

# mpi

docs: https://www.mpi-forum.org/docs/mpi-3.1/

*mpi*

- = message passing interface
- interprocess communication IPC library for distributed memory computing
	- start: all machines call `MPI_Init` to each create a bunch of processes that make up the `MPI_COMM_WORLD`, visible globally by all processes, used for distributed communication.
	- end: all machines call `MPI_FINALIZE` to clean up memory.
- processes have a rank (id), and are part of a group
- messages have a tag (id), type, number of elems

*p2p communication*

- = point-to-point communication
- can be blocking or non-blocking
- sender: `MPI_Send`
- receiver: `MPI_Recv`

*collective communication*

- broadcast: `MPI_Bcast`
- scatte, gather: `MPI_Scatter`, `MPI_Gather`
- block until all receive: `MPI_Barrier`
- reduce: `MPI_Reduce`, `MPI_Allreduce`
