# RISC-V simple sprite move program
#
# Dmitry Smekhov, 2021
#

            .text

            li a0, 0

            la a1, str_hello   # write address
            li a2, 0xA000
            li t6, 0xFFFF0000  # REG_HEX
	    #li t6, 0x2020	
            li t5, 0xF

            # for model - 660060
            li  a0, 0x048
            sh  a0, 0xC(t6)

            li  a0, 0x040
            sh  a0, 0xC(t6)

            # for fpga - 115200
            # li  a0, 0x1A8
            # sh  a0, 0xC(t6)

            # li  a0, 0x1A0
            # sh  a0, 0xC(t6)



start:      lb a0, 0(a1)
            addi a1, a1, 1
            andi a0, a0, 0xFF
            beq  a0, zero, second_stage

wait_tx_ready:
            lb a4, 0x0F(t6)
            sb a4, 0(t6)
            andi a4, a4, 0x08
            beq a4, zero, wait_tx_ready

            sb  a0, 0xE(t6)
            j start

                     
second_stage:                     
            j second_stage


#             li t6, 2  # REG_KEY0
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             beq t5, zero, check_key1  # key not pressed
#             li t5, 0  # reset key0
#             beq zero, zero, cycle_write

# check_key1:
#             li t6, 3  # REG_KEY1
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             beq t5, zero, start  # key not pressed
#             li t5, 0  # reset key1
#             beq zero, zero, cycle_read

# cycle_write:
            

#             li t6, 8 # REG_MODE_ADR
#             mv t5, a1

#             li t6, 9 # REG_MODE_DATA
#             mv t5, a3

#             li t6, 10 # REG_MODE_CNT
#             li t5, 4

#             li t6, 0x100  # START WRITE

# check_w_done:
#             li t6, 4  # REG_W_DONE
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             beq t5, zero, check_w_done  # w_done==0
            
#             addi a1, a1, 4
#             addi a3, a3, 1

#             beq zero, zero, start



# cycle_read:
            

#             li t6, 8 # REG_MODE_ADR
#             mv t5, a2

#             li t6, 10 # REG_MODE_CNT
#             li t5, 4

#             li t6, 0x200  # START READ

# check_r_done:
#             li t6, 5  # REG_R_DONE
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             beq t5, zero, check_r_done  # r_done==0
            
#             addi a2, a2, 4

#             li t6, 6  # REG_CALCULATE
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             addi a0, a0, 0     
#             mv a0, t5

#             li t6, 1  # REG_HEX
#             mv t5, a0               # show result

#             beq zero, zero, start            


.section .rodata

str_hello:  .string  "Hello, world! 123 \n"            
str_2:      .string  "next str" 




            
 
