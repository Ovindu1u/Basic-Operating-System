; Loaded onto the first sector of the boot disk (MBR)
; Purpose is to load the second stage of the bootloader
; Minimal functionality, load files from a FAT filesystem and print basic strings

bits 16             ; the CPU starts in 16 bit mode
org 0x7C00          ; the address that the BIOS loads the MBR

jmp short main      ; jump to execution

string: db "Hello World!", 0x0D, 0x0A, 0      ; string, followed by CRLF and null terminator

; prints string to tty
; ds:si   -   pointer to null terminated string
puts:
    ; save modified registers
    push si
    push bx
    mov ah, 0x0E            ; write text video option
    mov bh, 0               ; bh -  page number 0, bl - color black

.loop:


    lodsb                   ; load one byte to al
    cmp al, 0               ; check if the character is 0 (null term)
    jz .end                 ; finish printing in that case

    int 0x10                ; bios video interupt

    jmp .loop               ; next character

.end:
    ; restore modifed registers
    pop bx
    pop si

    ret


main:
    ; set up segment registers
    mov ax, 0           ; segment registers cannot load immediate values
    mov ds, ax          ; set data and extra segments to 0
    mov es, ax

    ; set up stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards, so initialize it to the start of the bootcode for now

    ; print stirng
    mov si, string
    call puts

    ; disable interupts and halt
    cli
    hlt




times 510- ($ - $$) db 0        ; pad with zeros 
dw 0xAA55                       ; boot signature
