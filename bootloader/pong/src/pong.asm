org 0x7c00
start:
	call clear_screen
	call draw_ball
	add byte [ball_x], 1
	call fps_delay
	jmp start
	
clear_screen:
	mov ah, 0x00 ;set videomode
	mov al, 0x13 ;set videomode 320x200 
	int 0x10 ;interrupt to set video mode
	
	mov ah, 0x0b ;set background function code
	mov bh, 0x00 ;function code
	mov bl, 0x00 ;background color black
	int 0x10 ;interupt to set background
	ret

fps_delay:
	mov ah, 0x86
	mov cx, 0
	mov dx, 33333
	int 0x15
	ret	
draw_ball:
	mov di, 0 ;x offset
	mov si, 0 ;y offset
	
draw_ball_x:
	
	mov ah, 0x0c ;draw pixel function
	mov al, 0x0f ;color whilte
	mov bh, 0 ;page number

	mov cx, [ball_x] ; x position 
	mov dx, [ball_y] ; y position	
	
	add cx, di ;add x offset
	add dx, si ;add y offset
	
	int 0x10 ;interrupt to draw pixel
	
	cmp di, [ball_size] ;compare x to ball size 
	inc di ;increase x offset
	jb draw_ball_x ;jump if less than or equal to 0

draw_ball_y:
	mov di, 0 ;reset x offset
	inc si ;increase y offset
	cmp si, [ball_size] ;compare y to ball size
	jb draw_ball_x ;jump if less than or equal to 0
	ret 
	
	
ball_x:
	db 0x0a
ball_y:
	db 0x0a
ball_size:
	db 0x05

times 510-($-$$) db 0
db 0x55,0xaa
