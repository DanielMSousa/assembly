;Daniel Moreira de Sousa
;20200016741

extern printf
extern scanf
global main

section .data
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

  ;EBP + 8 ; => pixel
  ;EBP + 12; => cor
  ;EBP + 16; => valor

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

;Coloca a cor escolhida pelo usuário na variável
;0 - azul, 1 - verde e 2 - vermelho (BGR)
mov EAX, 0
mov [cor_escolhida], EAX

;Aumento
mov EAX, 255
mov [valor], EAX

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

;jmp exit

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

  ADD esp, 12

  ;ESCREVE O ARQUIVO
  mov EAX, 4 ; sys_write
  mov EBX, [fileHandle2] ;1 -> escreve na tela ao invés do handler
  mov ECX, fileBuffer
  mov EDX, 3 ;Antes era 10, está certo?
  int 80h

;push DWORD[fileBuffer]
;push frase_num

;printaria o bagulho na tela...
;push fileBuffer
;call printf
;add ESP, 3

;A menos que o programa pule direto para o exit
;Ele vai permanecer voltando ao loop onde lê do arquivo1
;e passa pro arquivo2
jmp loop

;encerra o programa
exit:
  mov EAX, 1
  xor EBX, EBX
  int 80h