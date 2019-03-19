# PURPOSE: create a new file named heynow.txt
#	   and write the words "hey diddle diddle!" into it#
# PROCESSING: 1) Open the output file
#	      2) Write the text into the file
# 	      3) Close the file

.section .data

###CONSTANTS###

# system call numbers
.equ OPEN, 5
.equ WRITE, 4
.equ READ, 3
.equ CLOSE, 6
.equ EXIT, 1

# options for open
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# system call interrupt
.equ LINUX_SYSCALL, 0x80

# declare the text to be written to the file
heynow:
.ascii "hey diddle diddle!\n"

# find the length of the text by subtracting
# the label memory locations
heynow_end:
.equ heynow_len, heynow_end - heynow

# declare the name for the file to be created
filename:
.ascii "heynow.txt"

.section .text

# open file for output
open_fd_out:
movl $OPEN, %eax
movl $filename, %ebx
movl $O_CREAT_WRONLY_TRUNC, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

# use the resulting file descriptor
# to write the text into the file
movl %eax, %ebx
movl $heynow, %ecx
movl $heynow_len, %edx
movl $WRITE, %eax
int $LINUX_SYSCALL

# close the file written
# the descriptor is already in the %ebx register
# so only move the CLOSE system call into %eax
movl $CLOSE, %eax
int $LINUX_SYSCALL

# set up the registers for
# program exit, return code is 0.
movl $0, %ebx
movl $EXIT, %eax
int $LINUX_SYSCALL

# In order to assemble and run this program on an x86_64 GNU/Linux system
# 
# as --32 -o heynow.o heynow.s
# ld -m elf_i386 -o heynow heynow.o
# ./heynow
# 
# A file called "heynow.txt" should be created
# with the contents "hey diddle diddle!"
