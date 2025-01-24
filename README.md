# NASM x86 Assembly Programs

This repository contains a collection of assembly programs written in NASM x86. The current program is a Pong bootloader, and more programs will be added in the future.

## Introduction
This repository is dedicated to exploring x86 assembly programming using NASM. It contains various programs that demonstrate different aspects of low-level system programming, including bootloaders, simple utilities, and more.

## How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/Godvein/x86_nasm.git
   cd repo_name

2. To run any program in the repository:
- Navitage to the directory of the program you want to run
- Use the provided Makefile to build and run the program
- For example:
    ```bash
	cd bootloader/pong   # Replace with your program directory
	make                 # Assembles the program
	qemu-system-i386 -drive format=raw, file=build/pong.img # Runs the program (using QEMU or similar emulator)


