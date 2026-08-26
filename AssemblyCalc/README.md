# AssemblyCalc
A calculator written in x86-64 assembly used on the command line.
The calculator works only with one operation and two operands.  
This small project came about because I wanted to try creating something using assembly language.
A calculator seemed easy enough to create.

## Getting Started
To make use of this project, one needs to run Linux and have [NASM](https://www.nasm.us/) installed.
One can build the project by using the included [build.sh](build.sh) file.

## Usage
To use the calculator one needs to put the operation and operands as arguments to the program, like shown below.

### Addition
```
./build/main ADD 10 10
```

### Subtraction
```
./build/main SUB 15 10
```

### Multiplication
```
./build/main MUL 7 7
```

### Division
```
./build/main DIV 42 7
```

## Issues
* Can not use signed integers.
* No checking if input operands are valid integers.
* Not handling overflow/underflow correctly.

## Sources Used
* [Modern x64 Assembly](https://www.youtube.com/watch?v=rxsBghsrvpI&list=PLKK11Ligqitg9MOX3-0tFT1Rmh3uJp7kA)
* [x64 Cheat Sheet](https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf)
* [assembly-tutorial](https://github.com/mschwartz/assembly-tutorial/tree/main)
* [Linux System Call Table](https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/)
* [FLAGS register](https://en.wikipedia.org/wiki/FLAGS_register)
* [CMP Instruction Explanation](https://stackoverflow.com/a/61568237)
* [x86_64 Linux Assembly #8 - Subroutine to Print Integers](https://www.youtube.com/watch?v=XuUD0WQ9kaE)
  * https://pastebin.com/PN2jKVae
* [x86_64 Linux Assembly #9 - Command Line Arguments](https://www.youtube.com/watch?v=xtFs1yBVinc)
* [converting Integer to String process ("under the hood")](https://stackoverflow.com/a/67212831)

