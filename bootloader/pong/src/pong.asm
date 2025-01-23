org 0x7c00
bits 16
start:
	call clear_screen
	call ball_move
	call check_collision
	call draw_ball
	call fps_delay
	jmp start

check_collision:
	mov ax, [ball_x] ;contains ball position x
	mov bx, [ball_y] ;contains ball position y
	
	cmp ax, [ball_size] ;check if minimum ball x position
	jl operation_x ;make ball x positive

	cmp bx, [ball_size] ;check if mininum ball y position
	jl operation_y ;make ball y positive
	
	mov di, [window_width] ;move window width to di register
	sub di, [ball_size] ;(window width - ball size)
		
	cmp ax, di ;check if max ball x position
	jg operation_x ;make ball x negative

	mov si, [window_height] ;move window height to si register
	sub si, [ball_size] ;(window height - ball size)
	
	cmp bx, si ;check if max ball y position
	jg operation_y ;make ball y negative

	ret

operation_x:
	mov cx, [ball_velocity_x] ;get ball x velocity
	neg cx ;this will make x veloity negative or positive 
	mov [ball_velocity_x], cx ;update the velocity x
	ret

operation_y:
	mov cx, [ball_velocity_y] ;get ball y velocity
	neg cx ;this will make y velocity negative or positive	
	mov [ball_velocity_y], cx ;update the velocity y
	ret
	
ball_move:
	mov ax, [ball_velocity_x] ;contains ball velocity x
	mov bx, [ball_velocity_y] ;contains ball velocity y
	add [ball_x], ax ;add velocity to ball position x
	add [ball_y], bx ;add velocity to ball position y
	ret
	
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
	mov ah, 0x86 ;bios wait function
	mov cx, 0 ;high word
	mov dx, 33333 ;low word 33ms
	int 0x15 ;interrupt for bios delay
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
	
;VARIABLES	
ball_x:
	dw 0x000a ;ball position x
	
ball_y:
	dw 0x000a ;ball position y
	
ball_size:
	dw 0x0005 ;ball size
	
ball_velocity_x:
	dw 0x0003 ;ball velocity x

ball_velocity_y:
	dw 0x0002 ;ball velocity y	
	
window_width:
	dw 0x0140 ;320 in decimal
	
window_height:
	dw 0x00c8 ;200 in deximal (320x200) window

times 510-($-$$) db 0
db 0x55,0xaa
