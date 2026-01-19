#Student Grades Calculator
#------------------------

.data
M:.word 20 , 25 , 10 , 18 , 22 #This is all the grades for Midterm
Q:.word 10 , 20 , 12 , 15 , 18 #This is all the grades for Quizze
P:.word 12 , 18 , 15 , 20 , 20 #This is all the grades for Project 
F:.word 22 , 29 , 21 , 22 , 23 #This is all the grades for Final
MIN: .space 16 #Array for sroring the min values 
MAX: .space 16 #Array for sroring the max values 
AVG: .float 0.0 , 0.0 , 0.0 , 0.0 #Array for sroring the AVG values 
Total: .space 20 #Array for sroring the total for each student 
passOrFail: .space 20 #Array for sroring passing or faill for each student  
float_value: .float 5.0

.text
.globl main

main:
la $s0 , MIN #load the base address of array MIN
la $s1 , MAX #load the base address of array MAX
la $s2 , AVG #load the base address of array AVG

# ----- compute for M -----
la $a0 , M #load the base address of array M  
lw $a1 , 0($a0) #Load the first element and assume is the Min
lw $a2 , 0($a0) #Load the first element and assume is the Max
lw $t7 , 0($a0)
add $a3 , $0 , $t7 # load the first element in sum 
jal compute
sw $v0 , 0($s0)
sw $v1 , 0($s1)
swc1 $f0 , 0($s2)

# ----- compute for Q -----
la $a0 , Q #load the base address of array Q 
lw $a1 , 0($a0) #Load the first element and assume is the Min
lw $a2 , 0($a0) #Load the first element and assume is the Max
lw $t7 , 0($a0)
add $a3 , $0 , $t7 # load the first element in sum 
jal compute
sw $v0 , 4($s0)
sw $v1 , 4($s1)
swc1 $f0 , 4($s2)

# ----- compute for P -----
la $a0 , P #load the base address of array P
lw $a1 , 0($a0) #Load the first element and assume is the Min
lw $a2 , 0($a0) #Load the first element and assume is the Max
lw $t7 , 0($a0)
add $a3 , $0 , $t7 # load the first element in sum 
jal compute
sw $v0 , 8($s0)
sw $v1 , 8($s1)
swc1 $f0 , 8($s2)

# ----- compute for F -----
la $a0 , F #load the base address of array F
lw $a1 , 0($a0) #Load the first element and assume is the Min
lw $a2 , 0($a0) #Load the first element and assume is the Max
lw $t7 , 0($a0)
add $a3 , $0 , $t7 # load the first element in sum 
jal compute
sw $v0 , 12($s0)
sw $v1 , 12($s1)
swc1 $f0 , 12($s2)

j DoneComputing

compute:
addi $t0 , $0 , 1 #i = 1
addi $t1 , $0 , 5 #loop terminal number 

#compute min , Max , and average for M,Q,P,and F 
loop:
slt $t2 , $t0 , $t1
beq $t2 , $0 , doneLoop # Exit loop
sll $t3 , $t0 , 2 # $t3 = i * 4
add $t4 , $a0 , $t3 #Move to new address
lw $t5 , 0($t4) #Load the value into register 

# ----- check for new Min ----- 
slt $t6 , $t5 , $a1   #Compare the new element with min
beq $t6 , $0 , checkMax
add $a1 , $0 , $t5

checkMax:
# ----- check for new Max ----- 
slt $t6 , $a2 , $t5 #Compare the new element with Max
beq $t6 , $0 , sum
add $a2 , $0 , $t5

sum:
add $a3 , $a3 , $t5 #updata the sum value 
addi $t0 , $t0 , 1  # i++
j loop

doneLoop:
mtc1 $a3 , $f0  # Convet the integer to float 
cvt.s.w $f0 , $f0 
l.s $f1 , float_value # Load the imm value into float reigster 
div.s $f0 , $f0 , $f1

add $v0 , $0 , $a1 #Saving the min value
add $v1 , $0 , $a2 #Saving the max value

jr $ra

DoneComputing:
#Naw calculate the total score, and store if the student passes or fails
addi $t0 , $0 , 0 #i = 0
addi $t1 , $0 , 5 #loop terminal number 

la $a0 , M #load the base address of array M
la $a1 , Q #load the base address of array Q
la $a2 , P #load the base address of array P
la $a3 , F #load the base address of array F

jal total
j doneProgram

total:
la $s4 , Total #load the base address of array Total
la $s5 , passOrFail #load the base address of array passOrFail

totalLoop:
slt $t2 , $t0 , $t1
beq $t2 , $0 , totalDone # Exit loop

sll $t3 , $t0 , 2 # $t3 = i * 4
add $s0 , $a0 , $t3
add $s1 , $a1 , $t3
add $s2 , $a2 , $t3
add $s3 , $a3 , $t3

add $s6 , $s4 , $t3
add $s7 , $s5 , $t3

lw $t4 , 0($s0) #Load the value from M 
lw $t5 , 0($s1) #Load the value from Q 
lw $t6 , 0($s2) #Load the value from P 
lw $t7 , 0($s3) #Load the value from F

add $t8 , $t4 , $t5 # Add M[i] + Q[i]
add $t9 , $t6 , $t7 # Add P[i] + F[i]

# ----- store total score ----- 
add $t8 , $t8 , $t9 # Add M[i] + Q[i] + P[i] + F[i]
sw $t8 , 0($s6)

# ----- check pass/fail ----- 
add $t9 , $0 , 60
slt $t4 , $t8 , $t9

bne $t4 , 0 , fail
addi $t5 , $0 , 1
sw $t5 , 0($s7) # Store ONE if the student Passes
addi $t0 , $t0 , 1
j totalLoop

fail:
sw $0 , 0($s7) #Store ZERO if the student Fails
addi $t0 , $t0 , 1
j totalLoop

totalDone:
jr $ra

doneProgram:
li $v0 , 10
syscall 






















 



