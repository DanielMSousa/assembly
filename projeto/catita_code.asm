extern printf
extern scanf
global main

section .data
  filename db 'catita.bmp', 0
  filename2 db 'catita2.bmp', 0
  fileHandle dd 0

section .bss
  fileBufferHeader RESB 54
  fileBuffer RESB 3

section .text

main:

global start
_start:

  ;ABRE O ARQUIVO catita1
  mov eax, 5
  mov ebx, filename ; sys_open
  mov ecx, 0 ; read_only
  mov edx, 777
  int 80h

  ;MOVE O PONTEIRO PARA O HANDLE
  mov [fileHandle], EAX

  ;jmp exit

  ;Lê o arquivo
  loop:
  mov eax, 3 ; sys_read
  mov ebx, [fileHandle] ;file_descriptor
  mov ecx, fileBufferHeader
  mov edx, 10
  int 80h

  ;compara eax com 0, se for igual pula para o final
  cmp eax, 0
  je exit
  
  ;ESCREVE O ARQUIVO
  mov eax, 4 ; sys_write
  mov ebx, 1;[fileHandle] -> escreve na tela ao invés do handler
  mov ecx, fileBuffer
  mov edx, 10
  int 80h

  jmp loop

  ;encerra o programa
  exit:
    mov EAX, 1
    xor EBX, EBX
    int 80h