org 0x7e00
jmp 0x0000:start


;CONSTANTES
    VIDMEM equ 0B800h       ;início na memória de vídeo do modo de texto
    COLUNAS equ 80          ;80 colunas => 640 pixels
    LINHAS equ 25           ;25 linhas => 200 pixels (640 x 200)
    WIN equ 7               ;condição para vencer: comer dez eletrons
    ;ELETRON e ATOMO sao lidos do seguinte modo: o primeiro numero é a sua cor, o segundo é a cor do foreground, e o 20 ê o caractere espaco, tudo em hexadecimal
    ELETRON equ 4020h       ;4h = 4(dec) p/ eletron vermelho   
    ATOMO equ 2020h         ;2h = 2(dec) p/ atomo verde 
    CLOCK equ 046ch         ;lugar da memória ROM que guarda o valor do clock do computador        
    XPOS equ 1000h          ;posição x do atomo           
    YPOS equ 2000h          ;posição y do atomo
    CIMA equ 0
    BAIXO equ 1
    ESQUERDA equ 2
    DIREITA equ 3


;VARIÁVEIS
    atomox dw 20        ;posição x do atomo
    atomoy dw 10        ;posição y do atomo
    eletronx dw 16         ;posição y do eletron
    eletrony dw 8          ;posição y do eletron
    direcao db 4        ;0-cima,1-baixo,2-esquerda,3-direita
    muda_cor db 16      ;muda_cor da cor do background
    contador_eletron db 0
    cont db 0

txt1:  db "       -------------------------",13,10,0     
txt2:  db "       |   (:     Ola!    :)   |",13,10,0
txt3:  db "       -------------------------",13,10,0
txt4:  db "Digite 'a' para ir ao jogo do atomo",13,10,0
txt5:  db "Digite 'b' para ver a imagem",13,10,0
txt6:  db "Digite 'c' para creditos ",13,10,0
txt7:  db "Digite 'd' para curiosidade ",13,10,0

msg1:  db "         Quebrando as moleculas",13,10,0
msg2:  db '                   .',13,10,0
msg3:  db '                   .',13,10,0
msg4:  db '                   .',13,10,0
msg5:  db "O objetivo do jogo eh 'comer' 7 pacotes de energia para atingir um novo estado (camada)!",13,10,0
msg6:  db "Voce eh o eletron verde e os pacs de energia sao os vermelhos. Cuidado para nao bater nas paredes!",13,10,0
msg7:  db "w -> cima,  a -> esquerda" ,13,10,0
msg7.1: db "s -> baixo, d ->direita"  ,13,10,0
msg8:  db "Digite alguma tecla quando estiver pronto!!",13,10,0
msg9:  db '3',13,10,0
msg10: db '2',13,10,0
msg11: db '1',13,10,0
msg12: db "             Chorou bb :(",13,10,0
msg13: db " :::::::::::::::GG WP::::::::::::::::: :)",13,10,0
msg14: db "::::::::::::::::::::SCORE::::::::::::::::::::::::"

msg_credits_1        db 'Este jogo foi desenvolvido para a cadeira Infraestrutura de software por:', 0
msg_credits_danilo   db '                  - Danilo Nogueira', 0
msg_credits_lucas    db '           - Lucas Lins', 0
msg_credits_rodrigoS db '           - Rodrigo Santos', 0
msg_credits_rodrigoR db '           - Rodrigo Rocha', 0
msg_credits_2 db 'Agradecimentos especiais aos slides dos monitores e a todos os tutoriais da internet', 0
msg_credits_goto db 'Pressione qualquer tecla para voltar', 0

msg_txt1 db 'Os eletrons estao distribuidos de acordo com suas distancias em relacao ao nucleo ',0
msg_txt2 db 'descrevendo orbitas circulares ao redor deste sem ganhar ou perder energia.',0
msg_txt3 db ' Esses niveis eletronicos, conforme o numero de elementos quimicos conhecidos ',0 
msg_txt4 db 'sao numerados de 1 a 7 ou representados pelas letras K, L, M, N, O, P e Q, a partir ',0 
msg_txt5 db 'do nivel mais interno, que eh o mais proximo do nucleo.',0

msg_txt6 db ' Ao receber energia o eletron pode saltar da camada em que esta para uma camada mais externa',0
msg_txt7 db ' quando cessa a fonte de energia, ela retorna para a camada de origem, liberando sob a forma de',0 
msg_txt8 db ' luz a energia anteriormente recebida.',0

msg_txt9 db ' A energia em forma de luz eh emitida quando o eletron retorna ah sua camada eletronica inicial',0
msg_txt10 db ' e a cor da luz dependerah de cada elemento quimico',0



imagem: db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,0 ,0 ,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,0 ,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,0 ,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,0 ,0 ,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,15,15,15,15,15,15,0 ,4 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,0 ,4 ,15,15,15,15,15,15,15,15,15,0 ,15,0 ,15,15,15,15,15,15,4 ,4 ,4 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,4 ,4 ,4 ,15,15,15,15,15,15,15,0 ,15,15,0 ,15,15,15,15,15,15,15,4 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,4 ,0 ,15,15,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,0 ,15,15,0 ,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,0 ,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,15,0 ,15,15,15,15,0 ,15,15,0 ,15,15,15,15,15,0 ,15,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,15,15,0 ,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,0 ,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,0 ,15,15,0 ,15,0 ,15,15,15,2 ,2 ,2 ,15,15,0 ,15,15,0 ,15,15,0 ,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,0 ,0 ,15,15,15,2 ,2 ,2 ,2 ,2 ,15,15,0 ,15,0 ,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,4 ,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,15,15,15,15,2 ,2 ,2 ,2 ,2 ,15,15,15,0 ,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,4 ,4 ,4 ,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,15,15,15,15,2 ,2 ,2 ,2 ,2 ,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,4 ,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,0 ,0 ,15,15,15,2 ,2 ,2 ,2 ,2 ,15,15,15,0 ,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,0 ,15,0 ,15,15,15,2 ,2 ,2 ,15,15,15,0 ,15,0 ,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,0 ,15,15,15,0 ,15,15,0 ,0 ,15,15,15,15,15,0 ,0 ,15,15,0 ,15,15,0 ,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,0 ,15,15,15,15,15,0 ,15,15,15,15,15,0 ,15,0 ,15,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,0 ,15,15,4 ,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,4 ,4 ,4 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,4 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,15,0 ,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,15,0 ,15,15,15,15,15,15,15,15,15,0 ,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,0 ,0 ,15,0 ,15,15,15,15,15,15,15,15,15,15,15,0 ,15,0 ,0 ,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,0 ,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,0 ,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0 ,0 ,0 ,0 ,0 ,0 ,0 ,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
;a imagem é um átomo(60x42)


print:;pra printar uma string
    lodsb
    cmp al, 0
    je fim
    mov ah, 0eh
    mov bh, 00h
    int 10h
    jmp print
    fim:
        ret

delay:
    mov cx, 0fh          ;delay de aprox 1 s
    mov dx, 4240h
    mov ah, 86h
    int 15h
    ret

_putchar:
    mov ah, 0eh          ; código para função que imprime o valor de al na tela
    mov bh, 0            ; página onde será impresso o caracter
    int 10h
    ret

%macro putchar 1
    mov al, %1
    call _putchar
%endmacro

getchar:
    mov ah, 0x00         ; código para a função que coloca em al o valor da tecla que foi pressionada
    int 16h              ; chamada para interrupção da bios 16h
    ret

endl:
    mov al, 0ah          ; coloca em al o caracter de quebra de linha
    call _putchar
    mov al, 0dh          ; coloca em al o caracter de carriage return
    call _putchar
    ret

;seta um delay por uma quantidade de tempo pré definida
timer10:
    .loop:
        lodsb
        mov al, 5
        cmp al, [cont]
        je .endloop
        inc byte[cont]
        call delay
        jmp .loop
    .endloop:
ret 


_msg_print:
    xor ax, ax
    int 10h
ret

set_video_mod:
    xor ax,ax
    mov ah, 00h
    mov al, 03h ;http://vitaly_filatov.tripod.com/ng/asm/asm_023.1.html
    int 10h
ret

%macro msg_print 1
    ;call _msg_print
    mov si, %1
    call print
    call delay
%endmacro

%macro msg_print2 1
    ;call _msg_print
    mov si, %1
    call print
%endmacro



%macro template 1
    mov ah, 0xb
    mov bh, 0
    mov bl, %1
    int 10h
%endmacro



menu:
    xor dx, dx
    xor cx, cx
    xor ax, ax
    int 10h

    msg_print msg1
    msg_print msg2
    msg_print msg3
    msg_print msg4

    msg_print2 txt1 ;printando msg de boas vindas
    msg_print2 txt2
    msg_print  txt3
    msg_print2 txt4
    msg_print2 txt5
    msg_print2 txt6
    msg_print2 txt7

    call endl

    .get_options:        ; Compara qual opção foi escolhida pelo usuário (1, 2 ou 3) e o redireciona para a tela correspondente
        call getchar
        cmp al, 'a'

        je setando_configs
        cmp al, 'b'
        je desenho

        cmp al, 'c'
        je creditos

        cmp al, 'd'
        je curiosidade

    ;daqui p\ frente é se a letra 'a' n foi pressionada
    desenho:
        mov al, 13;modo de video
        mov ah, 0
        int 10h

        mov cx, 100;pra printar "no centro"
        mov dx, 100
        mov si, imagem
        for1:;é como um for da linguagem c
            cmp dx, 142;42 linhas
            je endfor1
            mov cx, 100
            for2:
                cmp cx, 160;60 colunas
                je endfor2
                lodsb
                mov ah, 0ch 
                int 10h 
                inc cx 
                jmp for2
                endfor2:
                    inc dx
                    jmp for1
                    endfor1:
                        call timer10
                        jmp return
    ;daqui pra frente é o jogo
    setando_configs:
        call endl
        msg_print msg5

        call endl
        msg_print2 msg6
        call endl
        msg_print2 msg7
        msg_print2 msg7.1
        call endl
        msg_print2 msg8

        call getchar          ;espera uma tecla do teclado
        call endl
        msg_print msg9
        msg_print msg10

        msg_print msg11

        mov ax, 0003h       ;setando o modo de vídeo como o modo vga 3
        int 10h 
        mov ax, VIDMEM      ;setando a memória de vídeo
        mov es, ax          ;es aponta para b800 e di(o offset a partir de es) para 0000
        mov ax, [atomox]    ;setando a cabeça do atomo
        mov word[XPOS], ax  ;movendo para XPOS a posição x da cabeça
        mov ax, [atomoy]
        mov word[YPOS], ax  ;movendo para YPOS a posição y da cabeça
        call game_loop 
        ret

    creditos:
        call set_video_mod
        template 8
        msg_print2 msg_credits_1
        msg_print2 msg_credits_danilo
        call endl
        msg_print2 msg_credits_lucas
        call endl
        msg_print2 msg_credits_rodrigoS
        call endl
        msg_print2 msg_credits_rodrigoR
        
        call endl
        call endl
        msg_print2 msg_credits_2
        call endl

        msg_print2 msg_credits_goto
        call endl
        call delay
        call getchar
        jmp return
    ret

    curiosidade:
        call set_video_mod
        template 9
        call endl
        call endl

        msg_print2 msg_txt1
        msg_print2 msg_txt2
        msg_print2 msg_txt3
        msg_print2 msg_txt4
        msg_print2 msg_txt5
        msg_print2 msg_txt6
        msg_print2 msg_txt7
        msg_print2 msg_txt8
        msg_print2 msg_txt9
        msg_print2 msg_txt10

        call endl
        call endl

        msg_print2 msg_credits_goto
        call delay
        call endl
        call getchar
        jmp return
    ret




start:
    call menu

game_loop:              ;é o loop que representa o game
    mov al, 32       ;limpando a tela a cada iteração do loop
    mov ah, byte[muda_cor];isso aqui muda a cor do background
    xor di, di          ;di aponta novamente para 0000
    mov cx, COLUNAS*LINHAS ;quantidade de vezes que deve se repetir a stosw, ou seja, 80x25 vezes
    rep stosw           ;armazena oq está em ax (w é de word) em es:di e dps incrementa di
    ;por isso essas quatro linhas "limpam" a tela


    mov ax, ATOMO        ;a cor do atomo
    .fazendo_atomo:
        imul di, [YPOS], COLUNAS*2 ;imul é a operação de multiplicação com sinal
        ;o resultado da mult é armazenado em di
        ;multiplicamos COLUNAS por 2 pq cada char no modo VGA vale por 2 bytes
        imul dx, [XPOS], 2
        ;no x só multiplicamos por 2 pq usamos o que está em di como um offset
        add di, dx          ;agora, em di está a exata posição do atomo
        stosw               ;armazena onde di aponta o que está em ax
        ;aqui é feito o eletron
        imul di, [eletrony], COLUNAS*2 ;parecido com fazendo o atomo
        imul dx, [eletronx], 2
        add di, dx
        mov ax, ELETRON                ;cor do eletron
        stosw


        ;move o atomo na direção q o usuário escolher
        mov al, [direcao]
        cmp al, CIMA    
        je pra_cima                 ;se al == 0, ent vai pra cima
        cmp al, BAIXO
        je pra_baixo                ;se al == 1, ent vai pra baixo
        cmp al, ESQUERDA
        je pra_esquerda             ;se al == 2, ent vai pra esquerda
        cmp al, DIREITA
        je pra_direita              ;se al == 3, ent vai pra direita
        jmp atualiza_atomo         ;se n for nenhum desses
        pra_cima:                   ;decrementar o valor de atomoy
            dec word[atomoy]
            jmp atualiza_atomo
        pra_baixo:                  ;incrementar o valor de atomoy
            inc word[atomoy]
            jmp atualiza_atomo
        pra_esquerda:               ;decrementar o valor de atomox
            dec word[atomox]
            jmp atualiza_atomo
        pra_direita:                ;incrementar o valor de atomox
            inc word[atomox]        ;nessa n tem jmp atualiza_atomo pra poupar espaço
        atualiza_atomo:                 ;atualiza o corpo do atomo a partir das mudanças de direções          
            mov ax, [atomox]            ;atualizando XPOS e YPOS com o novos valores
            mov word[XPOS], ax
            mov ax, [atomoy]
            mov word[YPOS], ax


                                        ;essa parte verifica se perdeu 
                                        ;o unico modo de perder é bater em alguma parede
        cmp word[atomoy], -1           ;bateu na parede de cima
        je perdeu
        cmp word[atomoy], LINHAS        ;bateu na parede de baixo
        je perdeu
        cmp word[atomox], -1            ;bateu na parede da esquerda
        je perdeu
        cmp word[atomox], COLUNAS       ;bateu na parede da direita
        je perdeu

    usuario:                            ;pegando as entradas do usuário
        mov bl, [direcao]               ;guardando a direção atual
        mov ah, 1                       ;essa interrupção seta a FLAG ZF (zero flag) se alguma tecla for apertada no teclado
        int 16h                         ;serviços do teclado
        jz verifica_eletron                ;se ZF == 0 (logo, nd foi apertado), entao vai pra verifica_eletron
        xor ah, ah                      ;armazena a tecla apertada em al
        int 16h
        cmp al, 'w'                     ;vê se a tecla apertada foi 'w'
        je apertou_w                    ;se sim, vai pra apertou_w
        cmp al, 's'                     ;vê se a tecla apertada foi 's'
        je apertou_s                    ;se sim, vai pra apertou_s
        cmp al, 'a'                     ;vê se a tecla apertada foi 'a'
        je apertou_a                    ;se sim, vai pra apertou_a
        cmp al, 'd'                     ;vê se a tecla apertada foi 'd'
        je apertou_d                    ;se sim, vai pra apertou_d
        jmp verifica_eletron               ;caso a tecla apertada n for nenhuma dessas
                                        ;ent vai pra verifica_eletron
            apertou_w:                  ;cada label dessa move pra bl a direção respectiva da tecla
                mov bl, CIMA            ;e dps pula pra verifica_eletron
                jmp verifica_eletron
            apertou_s:
                mov bl, BAIXO
                jmp verifica_eletron
            apertou_a:
                mov bl, ESQUERDA
                jmp verifica_eletron
            apertou_d:
                mov bl, DIREITA                 ;nessa última n tem jmp verifica_eletron pra poupar espaço
            verifica_eletron:                   ;verifica se o atomo comeu o eletron
               mov byte[direcao], bl            ;atualiza a direção (isso aqui poderia ser feito em cada label acima)
                                                ;mas fazer isso uma só vez poupa espaço
                mov ax, [atomox]        
                cmp ax, [eletronx]              ;compara se chocou com o eletron na posição x
                jne delay_loop                  ;se não chocou, vai pra delay_loop
                mov ax, [atomoy]        
                cmp ax, [eletrony]              ;compara se chocou com o eletron na posição y
                jne delay_loop                  ;se não chocou, vai pra delay_loop
                ;se chegou aqui é pq "comeu" o eletron
                mov dl, byte[muda_cor]
                add dl, 00100000b               ;somando de dois a parte de background color: https://en.wikipedia.org/wiki/VGA_text_mode
                mov byte[muda_cor], dl          ;incrementa muda_cor
                inc byte[contador_eletron]      ;contador de eletrons é incrementado
                     ;aumenta o tamanho do atomo
                cmp byte[contador_eletron], WIN         ;vê se chegou na quantidade de eletrons WIN
                je ganhou                       ;se ganhou, vai pra ganhou

                gera_eletron:                   ;a partir daqui gera o próx eletron
                                                ;as posições aleatórias são geradas a partir do temporizador do sistema
                    xor ah, ah                  ;lê o temporizador do sistema
                    int 1ah                     ;temporizador do sistema e serviços de clock
                                                ;o temporizador do sistema é incrementado a aprox 18,206 vezes por segundo
                                                ;o valor de retorno dessa interrup é armazenado em cx:dx
                                                ;em cx os 16 bits mais significativos
                                                ;em dx os 16 bits menos significativos
                                                ;quando é meia noite cx:dx é 0000:0000
                                                ;as posições aleatórias surgem do resto da divisão entre os 16 bits
                                                ;menos significativos do temporizador e colunas (para o x)
                                                ;e linhas (para o y) 
                    mov ax, dx                  ;armazenando em ax os 16 bits menos significativos do temporizador
                    xor dx, dx                  ;limpando dx pq vamos usar divisão
                    mov cx, COLUNAS             ;cx  = 80
                    div cx                      ;dividindo ax por cx, o resto vai pra dx
                    mov word[eletronx], dx         ;nova posição x do eletron (como é o resto, é entre 0 e 79)
                    xor ah, ah
                    int 1ah
                    mov ax, dx                  ;armazenando em ax os 16 bits menos significativos do temporizador
                    xor dx, dx                  ;limpando dx pq vamos usar divisão
                    mov cx, LINHAS              ;cx  = 25
                    div cx                      ;dividindo ax por cx, o resto vai pra dx
                    mov word[eletrony], dx         ;nova posição y do eletron (como é o resto, é entre 0 e 24)
                    ;a partir daqui verifica se o eletron foi spawnada dentro do atomo
                    .verifica_eletron_atomo:
                    mov ax, [eletronx]
                    cmp ax, [XPOS]       ;comparando a posição x
                    jne delay_loop 
                    mov ax, [eletrony]
                    cmp ax, [YPOS]      ;comparando a posição y
                    je gera_eletron           ;se spawnou dentro da atomo, faz outro eletron

                   
    delay_loop:                     ;para as cores n ficarem piscando freneticamente
        mov bx, [CLOCK]
        inc bx
        inc bx
        .delay:                     
            cmp [CLOCK], bx         ;vê se bx já atingiu o valor de CLOCK
            jl .delay               ;volta pra .delay se bx < CLOCK
jmp game_loop




ganhou:
    mov ah, 00h 
    mov al, 00h 
    int 10h
    template 1                              ;printa uma msg se ganhou
    msg_print msg13
    call delay
    jmp return

perdeu:                             ;printa uma msg se perdeu
    mov ah, 00h 
    mov al, 00h 
    int 10h 
    template 4
    msg_print msg12  
    ;putchar contador_eletron
    ;call timer10
    return: 
        jmp 0ffffh:0000h ;reseta o bootloader
jmp $