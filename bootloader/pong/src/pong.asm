org 0x7c00
start:
	mov ah, 0x00 ;set videomode
	mov al, 0x13 ;set videomode 320x200 
	int 0x10 ;interrupt to set video mode
	
	mov ah, 0x0b ;set background function code
	mov bh, 0x00 ;function code
	mov bl, 0x00 ;background color black
	int 0x10 ;interupt to set background
	
	mov ah, 0x0c ;draw pixel function
	mov al, 0x0f ;color whilte
	mov bh, 0 ;page number
	mov cx, 0x0a ; x position 
	mov dx, 0x0a ; y position
	int 0x10 ;interrupt to draw pixel

times 510-($-$$) db 0
db 0x55,0xaa
