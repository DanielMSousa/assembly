;segmento = parte de uma sessão
segment .data
	;Esse código aqui é só pra nomear essas operações
	;Você está criando variáveis para elas.
	LF       equ 0xA  ; Line Feed -> quebra linha
	NULL     equ 0xD  ; Final da string 
	SYS_CALL equ 0x80 ; Envia inforamação pro SO
	
	;EAX
	;SYS_READ e SYS_WRITE são mandados para EAX...
	;Indicam a operação
	SYS_EXIT  equ 0x1 ; Código de chamada para finalizar
	SYS_READ  equ 0x3 ; Operação de leitura
	SYS_WRITE equ 0x4 ; operação de escrita

	;EBX
	RET_EXIT  equ 0x0 ;operação realizada com sucesso
	STD_IN    equ 0x0 ;entrada padrão
	STD_OUT   equ 0x1 ;Saída padrão

;section data é para constantes
section .data
	msg db "Entre com seu nome: ", LF, NULL
	tam equ $- msg

;section bss é para variáveis
;resb 1 significa que vai guardar bytes, e que vai guardar de byte em byte
section .bss
	nome resb 1

section .text

global _start

_start:
	mov EAX, SYS_WRITE
	mov EBX, STD_OUT
	mov ECX, msg
	mov EDX, tam
	int SYS_CALL

    mov EAX, SYS_READ
    mov EBX, STD_IN
    mov ECX, nome ; recebe entrada
    mov EDX, 0xA ; diz o tamanho da entrada
    int SYS_CALL

    ;finaliza o programa
    mov EAX, SYS_EXIT
    mov EBX, RET_EXIT
    int SYS_CALL