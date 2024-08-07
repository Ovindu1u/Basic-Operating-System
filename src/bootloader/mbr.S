; Loaded onto the first sector of the boot disk (MBR)
; Purpose is to load the second stage of the bootloader
; Minimal functionality, load files from a FAT filesystem and print basic strings

%include "boot_record.s"

bits 16                         ; the CPU starts in 16 bit mode
org 0x7C00                      ; the address that the BIOS loads the MBR

; BIOS PARAMETER BLOCK      
jmp short main                  ; jump to execution
nop                             ; nop

boot_parameter_block: resb bpb_size


; EXTENDED BOOT RECORD
extended_boot_record: resb ebr_size


; BOOT CODE
string: db "Hello World!", 0x0D, 0x0A, 0      ; string, followed by CRLF and null terminator
bootloader: db "/boot/bootloader", 0          ; null terminated second stage file path


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
    ; some bioses load the MBR to CS:IP 0x7C00:0x0000
    ; while this resolves to the same physical address the assembler is using
    ; 0x7C00 as the org, it will break things, so enfore CS:IP as 0x0000:0x7C00 
    ; during the begining of execution by far jumping
    jmp 0x0000:.set_cs
.set_cs:

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

