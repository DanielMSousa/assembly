extern printf
extern scanf
global main

section .data
  filename db 'catita.bmp', 0
  filename2 db 'catita2.bmp', 0

  fileHandle dd 0
  fileHandle2 dd 0

  cor_escolhida dd 0

section .bss
  fileBufferHeader RESB 54
  fileBuffer RESB 3

section .text

main:

global start
_start:

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

  ;Esse é o trecho que vai virar função

  xor EAX, EAX
  mov ECX, fileBuffer
  add ECX, 2
  mov AL, BYTE[ECX]
  add EAX, 50

  ;Se o valor for maior que 255 altera ele
  cmp EAX, 255
  jbe menor_que

  ;Corrige as cores maiores que 255
  mov EAX, 255

  menor_que:
  mov BYTE[ECX], AL

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