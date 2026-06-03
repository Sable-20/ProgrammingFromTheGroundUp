# show how to compute the powers using two arguments

.section .data #everything is stored in registers so no need for any predefined variables

.section .text
.globl _start
_start:
  pushl $3        # push first argument
  pushl $2        # push second argument
  call power      # call power function
  addl $8, %esp   # move the stack pointer back
  pushl %eax      # saving the first answer
  pushl $2        # first argument
  pushl $5        # second argument
  call power 
  addl $8, %esp   # push stack pointer back
  popl %ebx       # the second answer is saved in eax, 
                  # since we saved the first answer to the stack we can pop it  # into abex
  addl %eax, %ebx # add the two values and save to ebx (return value)

  movl $1, %eax
  int $0x80

# computer power
# first argument is the base
# second argument is the power to raise it to
# return value in eax
# power must be one or greater
# %ebx holds base number
# %ecx holds power
#
# -4(%ebp) holds current result
# eax used for temporary storage

.type power, @function
power:
  pushl %ebp              # save old base pointer
  movl %esp, %ebp         # make SP the BP
  subl $4, %esp           # save room for local storage

  movl 8(%ebp), %ebx      # put first argument into ebx (base)
  movl 12(%ebp), %ecx     # second argument into ecx (power)

  movl %ebx, -4(%ebp)     # store current result

power_loop_start:
  cmpl $1, %ecx 
  je end_power
  movl -4(%ebp), %eax     # store current result in eax
  imull %ebx, %eax        # multiply current result by the base
  movl %eax, -4(%ebp)     # store current result
  decl %ecx 
  jmp power_loop_start

end_power:
  movl -4(%ebp), %eax     # return value goes in eax
  movl %ebp, %esp         # restore SP
  popl %ebp               # restore BP
  ret