extern printf
extern scanf
global main

section .data
  ;frase_num db ' %d ', 0
  
  ultimo_dado dd 1

  filename db 'catita.bmp', 0
  filename2 db 'catita2.bmp', 0
  
  fileHandle dd 0
  fileHandle2 dd 0

section .bss
  fileBufferHeader RESB 54
  fileBuffer RESB 3

section .text

main:

global start
_start:

  ;ABRE O ARQUIVO catita
  mov eax, 5
  mov ebx, filename ; sys_open
  mov ecx, 0 ; read_only
  mov edx, 777
  int 80h

  ;MOVE O PONTEIRO PARA O HANDLE
  mov [fileHandle], EAX

  ;CRIA E ABRE catita2
  mov eax, 8           ; sys_creat 
  mov ebx, filename2 
  mov ecx, 777 
  int 80h 

  mov [fileHandle2], EAX

  ;ATÉ AQUI CRIOU UM ARQUIVO CATITA2 VAZIO
  ;jmp exit

  ;Lê o arquivo
  loop:
    mov eax, 3 ; sys_read
    mov ebx, [fileHandle] ;file_descriptor
    mov ecx, fileBuffer
    mov edx, 10
    int 80h

    ;ESCREVE O ARQUIVO
    mov eax, 4 ; sys_write
    mov ebx, 1;[fileHandle2] ;1 -> escreve na tela ao invés do handler
    mov ecx, fileBuffer
    mov edx, 10
    int 80h

  ;Quando chega no final do arquivo EAX é trocado por 0
  cmp eax, 0
  jne loop
  
  ;push DWORD[fileBuffer]
  ;push frase_num
  
  ;printaria o bagulho na tela...
  ;push fileBuffer
  ;call printf
  ;add ESP, 3

  ;encerra o programa
  exit:
    mov EAX, 1
    xor EBX, EBX
    int 80h