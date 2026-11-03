.text
.global main
main:
    push {lr}

    ldr r0, =string
    bl printf

    mov r0, $5
    mov r1, $3
    add r0, r1
    mov r0, $0
    pop {lr}
    bx lr

.data
string: .asciz "Hello world\n"