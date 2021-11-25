# RUN: llvm-mc %s -triple=riscv32 -mattr=+guards \
# RUN:     | FileCheck -check-prefixes=CHECK-S %s
# RUN: llvm-mc %s -triple=riscv32 -mattr=+guards -riscv-no-aliases \
# RUN:     | FileCheck -check-prefixes=CHECK-S-NOALIAS %s
# RUN: llvm-mc -triple riscv32 -mattr=+guards -filetype=obj < %s \
# RUN:     | llvm-objdump -d --mattr=+c - \
# RUN:     | FileCheck -check-prefixes=CHECK-OBJ %s
# RUN: llvm-mc -triple riscv32 -mattr=+guards -filetype=obj < %s \
# RUN:     | llvm-objdump -d --mattr=+c -M no-aliases - \
# RUN:     | FileCheck -check-prefixes=CHECK-OBJ-NOALIAS %s

# CHECK-S:          tail    t
# CHECK-S-NEXT:     unimp
# CHECK-S-NEXT:     unimp
# CHECK-S-NOT:      unimp
#
# CHECK-OBJ:        auipc   t1, 0
# CHECK-OBJ:        jr      t1
# CHECK-OBJ-NEXT:   unimp
# CHECK-OBJ-NEXT:   unimp
# CHECK-OBJ-NOT:    unimp
t:
tail t

# CHECK-S:          jump    t, a0
# CHECK-S-NEXT:     unimp
# CHECK-S-NEXT:     unimp
# CHECK-S-NOT:      unimp
#
# CHECK-OBJ:        auipc   a0, 0
# CHECK-OBJ:        jr      -16(a0)
# CHECK-OBJ-NEXT:   unimp
# CHECK-OBJ-NEXT:   unimp
# CHECK-OBJ-NOT:    unimp
jump t, a0


# CHECK-S:                  ret
# CHECK-S-NEXT:             unimp
# CHECK-S-NEXT:             unimp
# CHECK-S-NOT:              unimp
#
# CHECK-S-NOALIAS:          jalr zero, 0(ra)
# CHECK-S-NOALIAS-NEXT:     unimp
# CHECK-S-NOALIAS-NEXT:     unimp
# CHECK-S-NOALIAS-NOT:      unimp
#
# CHECK-OBJ:                ret
# CHECK-OBJ-NEXT:           unimp
# CHECK-OBJ-NEXT:           unimp
# CHECK-OBJ-NOT:            unimp
#
# CHECK-OBJ-NOALIAS:        jalr zero, 0(ra)
# CHECK-OBJ-NOALIAS-NEXT:   unimp
# CHECK-OBJ-NOALIAS-NEXT:   unimp
# CHECK-OBJ-NOALIAS-NOT:    unimp
ret

# CHECK-S:                  ret
# CHECK-S-NEXT:             unimp
# CHECK-S-NEXT:             unimp
# CHECK-S-NOT:              unimp
#
# CHECK-S-NOALIAS:          c.jr ra
# CHECK-S-NOALIAS-NEXT:     unimp
# CHECK-S-NOALIAS-NEXT:     unimp
# CHECK-S-NOALIAS-NOT:      unimp
#
# CHECK-OBJ:                ret
# CHECK-OBJ-NEXT:           unimp
# CHECK-OBJ-NEXT:           unimp
# CHECK-OBJ-NOT:            unimp
#
# CHECK-OBJ-NOALIAS:        c.jr ra
# CHECK-OBJ-NOALIAS-NEXT:   unimp
# CHECK-OBJ-NOALIAS-NEXT:   unimp
# CHECK-OBJ-NOALIAS-NOT:    unimp
.option push
.option rvc
ret
.option pop

# CHECK-S:                  j j1
# CHECK-S-NEXT:             unimp
# CHECK-S-NEXT:             unimp
# CHECK-S-NOT:              unimp
#
# CHECK-S-NOALIAS:          jal zero, j1
# CHECK-S-NOALIAS-NEXT:     unimp
# CHECK-S-NOALIAS-NEXT:     unimp
# XCHECK-S-NOALIAS-NOT:      unimp
#
# CHECK-OBJ:                j 0x36 <j1>
# CHECK-OBJ-NEXT:           unimp
# CHECK-OBJ-NEXT:           unimp
# XCHECK-OBJ-NOT:            unimp
#
# CHECK-OBJ-NOALIAS:        jal zero, 0x36 <j1>
# CHECK-OBJ-NOALIAS-NEXT:   unimp
# CHECK-OBJ-NOALIAS-NEXT:   unimp
# XCHECK-OBJ-NOALIAS-NOT:    unimp
j1:
j j1

# CHECK-S:                  j j2
# CHECK-S-NEXT:             unimp
# CHECK-S-NEXT:             unimp
# CHECK-S-NOT:              unimp
#
# CHECK-S-NOALIAS:          c.j j2
# CHECK-S-NOALIAS-NEXT:     unimp
# CHECK-S-NOALIAS-NEXT:     unimp
# CHECK-S-NOALIAS-NOT:      unimp
#
# CHECK-OBJ:                j 0x42 <j2>
# CHECK-OBJ-NEXT:           unimp
# CHECK-OBJ-NEXT:           unimp
# CHECK-OBJ-NOT:            unimp
#
# CHECK-OBJ-NOALIAS:        c.j 0x42 <j2>
# CHECK-OBJ-NOALIAS-NEXT:   unimp
# CHECK-OBJ-NOALIAS-NEXT:   unimp
# CHECK-OBJ-NOALIAS-NOT:    unimp
.option push
.option rvc
j2:
j j2
.option pop
