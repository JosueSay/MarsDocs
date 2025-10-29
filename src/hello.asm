.data
msg:    .asciiz "Hello World\n"

.text
.globl main
main:
        # imprimir cadena
        li   $v0, 4
        la   $a0, msg
        syscall

        # salir del programa
        li   $v0, 10
        syscall