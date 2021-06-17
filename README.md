# Pipelined-RISCV-Processor

In this release we submit a pipelined, efficient , processor with a single memory and all the hazard handling requirements. the processor supports all the Risc-V32I  instructions below, except that it (halts) ends the execution when an ECALL instruction is received, and it replaces the EBREAK, FENCE, FENCE.I, and CSR instructions with a NOP instructions.
In addition, it supports all the compressed instructions which are based on the RV32I instruction set.
note: some branching instructions are not working properly 

<img width="460" alt="RV32I" src="https://user-images.githubusercontent.com/52168271/122470872-dd643580-cfbe-11eb-88f2-962361442c56.png">


References for the instructions:
https://content.riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf and https://rv8.io/isa.html
