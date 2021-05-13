# Common Linux definitions

# Sys calls
.equ EXIT, 1
.equ READ, 3
.equ WRITE, 4
.equ OPEN, 5
.equ CLOSE, 6
.equ BRK, 45

# sys interrupt
.equ LINUX_SYSCALL, 0X80

# STDIO
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# Common status codes
.equ END_OF_FILE, 0
