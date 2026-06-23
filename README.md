# Parallel Processing Systems - NTUA

**Authors:**
* Kostis Gizis (03119013)
* Filippos Ploumis (03120049)
* Michalis Raftopoulos (03120114)

This repository contains the laboratory assignments and coursework for the **Parallel Processing Systems** course (9th Semester) offered at the National Technical University of Athens (NTUA). 

The primary objective of these assignments is the design, implementation, and performance evaluation of parallel algorithms across diverse computational architectures. The implementations explore shared-memory multiprocessing, distributed-memory systems, and highly parallel GPU architectures.

## Repository Structure

The coursework is partitioned into four major assignments, each focusing on specific parallel programming paradigms and frameworks:

### Assignment 1: Conway's Game of Life (OpenMP)
- **Objective:** Parallelization of cellular automata simulations.
- **Technologies:** C, OpenMP
- **Description:** Implementation of Conway's Game of Life. The baseline sequential approach is parallelized utilizing OpenMP to exploit multi-core CPU architectures. 

### Assignment 2: Graph Algorithms and Clustering (OpenMP)
- **Objective:** Advanced shared-memory parallelization techniques, focusing on loop dependencies and reduction operations.
- **Technologies:** C, OpenMP
- **Description:** 
  - **Floyd-Warshall Algorithm:** Parallel implementation of the all-pairs shortest path problem.
  - **K-Means Clustering:** Evaluation of OpenMP constructs by implementing both naive parallelization and optimized reduction-based approaches for centroid recalculation.

### Assignment 3: K-Means Clustering Acceleration (CUDA)
- **Objective:** Massively parallel processing and GPU optimization strategies.
- **Technologies:** C/C++, NVIDIA CUDA
- **Description:** Migration of the K-Means clustering algorithm to GPU architectures. The assignment investigates progressive optimizations, including:
  - Naive CUDA implementations.
  - Exploitation of GPU shared memory to reduce global memory latency.
  - Data layout transformations (matrix transposition) to ensure coalesced memory accesses.

### Assignment 4: Distributed Computing and PDE Solvers (MPI)
- **Objective:** Distributed-memory parallelism and inter-process communication.
- **Technologies:** C, Message Passing Interface (MPI)
- **Description:**
  - **Heat Transfer Simulation:** Numerical solutions to the 2D Heat Equation using iterative finite difference methods (Jacobi, Gauss-Seidel SOR, and Red-Black SOR). Transitioning from serial implementations to distributed execution via MPI.
  - **K-Means Clustering (MPI):** Adaptation of the K-Means algorithm for distributed memory clusters, focusing on minimizing inter-node communication overhead.

## Technologies and Frameworks
* **Languages:** C, C++
* **Shared-Memory Parallelism:** OpenMP
* **Distributed-Memory Parallelism:** MPI (Message Passing Interface)
* **GPU Programming:** CUDA (Compute Unified Device Architecture)

## Disclaimer
This codebase is provided for academic and archival purposes. It reflects coursework completed at the National Technical University of Athens (NTUA).
