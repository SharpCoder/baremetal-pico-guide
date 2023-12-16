.global put32
put32:
    str r1,[r0]
    bx lr

.global delay
delay:
    sub r0,#1
    cmp r0,#0
    bne delay
    bx lr
