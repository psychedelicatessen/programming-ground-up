# Purpose: Loop a pre-defined record 30 times 
#	   and write the results to a file.
#
.include "linux.s"
.include "record-def.s"

.section .data

record:
.ascii "Anon\0"
.rept 35
.byte 0
.endr

.ascii "Emoose\0"
.rept 33
.byte 0
.endr

.ascii "420 Nowhere\nHue, BR 696969\0"
.rept 213
.byte 0
.endr

.long 69

file_name:
.ascii "yeah.dat\0"

count:
.long 0

.equ ST_FILE_DESCRIPTOR, -4 

.globl _start
_start:

movl %esp, %ebp
subl $4, %esp

movl $OPEN, %eax
movl $file_name, %ebx
movl $03101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

movl %eax, ST_FILE_DESCRIPTOR(%ebp)

write_loop:
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $record
call write_record
addl $8, %esp 
incl count
cmpl $30, count
je end_loop
jmp write_loop

end_loop:
movl $CLOSE, %eax
movl ST_FILE_DESCRIPTOR(%ebp), %ebx
int $LINUX_SYSCALL

movl $EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
