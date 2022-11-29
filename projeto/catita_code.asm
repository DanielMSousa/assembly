;Daniel Moreira de Sousa
;20200016741

extern printf
extern scanf
global main

section .data
  ;Frases de pergunta para o usuário
  ask_inputname db 'Qual nome do arquivo de entrada? ',0H
  ask_outputname db 'Qual nome do arquivo de saida?',0H
  ask_color_channel db 'Qual canal de cores deseja alterar?',0AH,0H
  color_option_1 db '0. Azul',0AH,0H
  color_option_2 db '1. Verde',0AH,0H
  color_option_3 db '2. Vermelho',0AH,0H
  ask_color_intensity db 'Qual sera o valor adicionado a esse canal de cor?',0AH,0H

  ;Formatos para receber os dados
  formatinput: db "%d", 0
  formatinputstring: dd "%s", 0

  filename db 'catita.bmp', 0
  filename2 db 'catita2.bmp', 0
  cor_escolhida dd 0
  valor dd 0

  fileHandle dd 0
  fileHandle2 dd 0

section .bss
  fileBufferHeader RESB 54
  fileBuffer RESB 3

section .text

funcao:
  push EBP
  mov EBP, ESP

  xor EAX, EAX ;Zera EAX
  mov ECX, [EBP+8] ;Aponta pro pixel
  add ECX, [EBP+12] ;move a cor escolhida para ECX
  mov AL, BYTE[ECX] ;escolhe o byte atual, ou seja o byte 0, 1 ou 2 dependendo da cor escolhida
  add EAX, [EBP+16] ;Soma o valor escolhido

  ;Se o valor for maior que 255 altera ele
  cmp EAX, 255
  jbe menor_que

  ;Corrige as cores maiores que 255
  mov EAX, 255

  menor_que:
  mov BYTE[ECX], AL

  mov esp, ebp
  pop ebp
  ret

main:

global start
_start:

;pergunta o nome do arquivo de entrada
  push ask_inputname
  call printf
  add ESP, 4

  ;recebe o nome do arquivo de entrada
  push filename
  push formatinputstring 
  call scanf
  add ESP, 8

  ;pergunta o nome do arquivo de saída
  push ask_outputname
  call printf
  add ESP, 4

  ;recebe o nome do arquivo de saída
  push filename2
  push formatinputstring 
  call scanf
  add ESP, 8

  ;pergunta o nome do canal de cor
  push ask_color_channel
  call printf
  add ESP, 4

  ;Motra as 3 opções pro usuário
  push color_option_3
  push color_option_2
  push color_option_1
  call printf
  add ESP, 4
  call printf
  add ESP, 4
  call printf
  add ESP, 4

  ;recebe a cor escolhida
  push cor_escolhida
  push formatinput 
  call scanf
  add ESP, 8

  ;Pergunta ao usuário quanto será somado ao canal
  push ask_color_intensity
  call printf
  add ESP, 4

  ;Recebe o valor a ser somado ao canal
  push valor
  push formatinput 
  call scanf
  add ESP, 4

;ABRE O ARQUIVO catita
mov EAX, 5
mov EBX, filename ; sys_open
mov ECX, 0 ; read_only
mov EDX, 777
int 80h

;MOVE O PONTEIRO PARA O HANDLE
mov [fileHandle], EAX

;CRIA E ABRE catita2
mov EAX, 8           ; sys_creat 
mov EBX, filename2 
mov ECX, 777 
int 80h 

mov [fileHandle2], EAX

;Lê o header e já escreve em catita2
mov EAX, 3 ; sys_read
mov EBX, [fileHandle] ;file_descriptor
mov ECX, fileBufferHeader
mov EDX, 54
int 80h

mov EAX, 4 ; sys_write
mov EBX, [fileHandle2] ;1 -> escreve na tela ao invés do handler
mov ECX, fileBufferHeader
mov EDX, 54
int 80h


;Lê o arquivo
loop:
  mov EAX, 3 ; sys_read
  mov EBX, [fileHandle] ;file_descriptor
  mov ECX, fileBuffer
  mov EDX, 3 ;Antes era 10, está certo?
  int 80h

  ;Quando chega no final do arquivo, o registrador EAX é trocado por 0
  cmp EAX, 0
  je exit

  push DWORD[valor]
  push DWORD[cor_escolhida]
  push fileBuffer

  call funcao

  add ESP, 12

  ;ESCREVE O ARQUIVO
  mov EAX, 4 ; sys_write
  mov EBX, [fileHandle2] ;1 -> escreve na tela ao invés do handler
  mov ECX, fileBuffer
  mov EDX, 3 ;Antes era 10, está certo?
  int 80h

jmp loop

;encerra o programa
exit:
  mov EAX, 1
  xor EBX, EBX
  int 80h