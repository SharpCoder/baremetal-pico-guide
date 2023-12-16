entrypoint:
    ldr r0,=0x20040000 @ sram4 seems good for the sp
    mov sp,r0
    bl boot
    b .

.global put32
put32:
    str r1,[r0]
    bx lr

.global read32
read32:
    ldr r0,[r0]
    bx lr
