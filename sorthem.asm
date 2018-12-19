;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Name: Harshil Modi
;Student number: #########
;Date: December 7th, 2018
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


%include "asm_io.inc"
global asm_main
extern rconf

section .data
con1 db   "Initial configuration",10,0
con2 db   "Final configuration", 10, 0
error1 db "Error command line arg not equal to 1",10,0  ; error message arguments check
error2 db "Error input must be unsigned integer between from 2 to 9!",10,0  ;error message input check
peg2: dd 0,0,0,0,0,0,0,0,0  ;initalizing pegs

p1: db  "          o|o          ",0  ; Initalizing pegs
p2: db  "         oo|oo         ",0
p3: db  "        ooo|ooo        ",0
p4: db  "       oooo|oooo       ",0
p5: db  "      ooooo|ooooo      ",0
p6: db  "     oooooo|oooooo     ",0
p7: db  "    ooooooo|ooooooo    ",0
p8: db  "   oooooooo|oooooooo   ",0
p9: db  "  ooooooooo|ooooooooo  ",0
base: db"XXXXXXXXXXXXXXXXXXXXXXX",0


section .bss
num_peg: resd 1 ; input variable number of pegs

section .text
  global asm_main

asm_main:
  enter 0, 0
  pusha                  ; push all registers on stack

  mov edx, dword 0       ; sets edx to zero
  mov eax, dword [ebp+8] ; eax contains argv
  cmp eax, dword 2       ; checks if number of command line arguments is correct
  jne Error1             ; jumps of command line argument is not 1

  mov ebx, [ebp+12]      ; saves fist argument into ebx
  mov ecx, [ebx+4]       ; saves input argument to ecx
  mov al, byte [ecx]     ; move first bit into al

  cmp al, 32h            ; compare al to '2'
  jb Error2              ;jumps if below
  cmp al, 39h            ; compare al to '9'
  ja Error2              ;jumps if above

  mov [num_peg], al      ; store value in variable
  sub dword [num_peg], 48 ; 48 repersents `0`
  mov eax, dword[num_peg] ; move number of pegs to eax

  push eax               ; push number of pegs
  mov ebx, peg2          ; move pointer to peg2 to ebx
  push ebx               ; push peg2 array pointer

  call rconf             ; call c program rconf
  add esp, 8             ; increase current stack pointer by 8
  mov eax, con1
  call print_string
  mov eax, dword[num_peg] ; move number of pegs into eax
  push ebx                ; push peg2 array pointer
  push eax                ; push number of pegs

  call showp              ; call subprogram for displaying peg
  pop eax                 ; pop stack
  pop eax

  call read_char          ; wait for user input
  mov eax, dword[num_peg] ; move number of pegs to eax
  mov ebx, peg2           ; mov peg2 array pointer to ebx

  push ebx                ; push peg2 array pointer
  push eax                ; push number of pegs

  call sorthem            ; call subprogram sorthem
  pop eax                 ; pop stack
  pop eax                 ; pop stack

  mov ecx, peg2           ; mov peg2 array pointer to ecx
  mov ebx, dword[num_peg] ; mov number of pegs to ebx

  swapfirst:              ; The following lines swaps the first element
  cmp ebx, 1              ; loop counter
  je finish_loop          ; end loop if counter is zero
  dec ebx
  mov eax, [ecx + 4]      ; move next element to eax
  mov edx, [ecx]          ; move current element to edx

  cmp edx, eax            ; compare eax and edx
  ja end_swap_loop        ; end swap if current element is larger

  mov [ecx + 4], edx      ; preform the swap
  mov [ecx], eax          ; preform the swap

;  mov eax, peg2           ; move pointer to peg2 into eax
;  push eax                ; push pointer to peg2 onto stack
;  mov eax, dword [num_peg] ; move number of pegs onto eax
;  push eax                 ; push number of pegs onto stack
;  call showp               ; display the pegs
;  pop eax                  ; pop the stack
;  pop eax                  ; pop the stack
;  call read_char           ; wait for user input

  end_swap_loop:           ; loop counter
  add ecx, 4               ; move to next element
  jmp swapfirst            ; jump back to start of loop

  finish_loop:
  mov eax, peg2
  push eax
  mov eax, dword[num_peg]
  push eax
  call showp
  call read_char
  pop eax
  pop eax
  mov eax, con2
  call print_string
  mov eax, peg2
  push eax
  mov eax, dword [num_peg]
  push eax
  call showp
  pop eax
  pop eax
  call read_char                  ; end loop
  jmp asm_main_end         ; jump to terminate program

sorthem:
  enter 0,0                ; This program checks adjacent pegs and swaps them

  mov ebx, [ebp + 8 ]      ;num of pegs
  mov ecx, [ebp + 12]      ;peg2 array pointer

  cmp ebx, 1
  je base_condition
    dec ebx
  add ecx, 4
  push ecx
  push ebx
  call sorthem            ; calls sorthem recursively
  pop ebx
  pop ecx

;  mov eax, peg2
;  push eax
;  mov eax, dword [num_peg]
;  push eax
;  call showp
;  pop eax
;  pop eax
;  call read_char

  swaploop:               ; check if a swap is needed
  cmp ebx, 1
  je endloop
  dec ebx
  mov eax, [ecx + 4]
  mov edx, [ecx]

  cmp edx, eax
  ja endswap

  mov [ecx + 4], edx      ; swaps if needed
  mov [ecx], eax

;  mov eax, peg2
  endloop:

  mov eax, peg2
  push eax
  mov eax, dword [num_peg]
  push eax
  call showp
  pop eax
  pop eax
  call read_char
  leave
  ret

showp:
  enter 0,0            ;This sub-function displays the peg configuration
  pusha

  mov edx, [ebp + 12]
  mov ecx, [ebp + 8]
  mov ebx, edx
  mov eax, 4
  mul ecx
  sub eax, 4
  add ebx, eax

  printloop:             ;eq 1 to 8 are used to print the pegs

     cmp dword [ebx], 1
     jne eq1
     mov eax, p1
     call print_string
     jmp endlo

     eq1:
     cmp dword [ebx], 2
     jne eq2
     mov eax, p2
     call print_string
     jmp endlo

     eq2:
     cmp dword [ebx], 3
     jne eq3
     mov eax, p3
     call print_string
     jmp endlo

     eq3:
     cmp dword [ebx], 4
     jne eq4
     mov eax, p4
     call print_string
     jmp endlo

     eq4:
     cmp dword [ebx], 5
     jne eq5
     mov eax, p5
     call print_string
     jmp endlo

     eq5:
     cmp dword [ebx], 6
     jne eq6
     mov eax, p6
     call print_string
     jmp endlo

     eq6:
     cmp dword [ebx], 7
     jne eq7
     mov eax, p7
     call print_string
     jmp endlo

     eq7:
     cmp dword [ebx], 8
     jne eq8
     mov eax, p8
     call print_string
     jmp endlo

     eq8:
     mov eax, p9
     call print_string

     endlo:               ; end of loop check if another loop is needed
     call print_nl
     sub ebx, 4
     dec ecx
     cmp ecx, 1
     jge printloop

     mov eax, base
     call print_string
     call print_nl

    popa
    leave
    ret


  Error1:                  ; eeror 1 output
    mov eax, error1
    call print_string
    jmp asm_main_end

  Error2:                  ; error 2 output
    mov eax, error2
    call print_string
    jmp asm_main_end

asm_main_end:              ; terminate program
  popa
  leave
  ret