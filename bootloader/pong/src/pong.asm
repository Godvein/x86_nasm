org 0x7c00
bits 16
start:
	call clear_screen
	call draw_ball
	call ball_move
	call check_ball_collision
	call check_input
	call player_move
	call draw_player
	call fps_delay
	jmp start

player_move:
	mov byte al, [input_buffer] ;get the player input
	cmp al, "w" ;check if w
	je move_up ;move up if w

	cmp al, "s" ;check if s
	je move_down ;move down if s

	ret

move_up:
	mov bx, [player_y] ;get player y position
	cmp bx, [player_height] ;check if player_y is above player_height
	jl return ;return if less than 0

	;execute if player_y is more than 0	
	mov cx, [player_velocity] ;get player velocity
	sub bx, cx ;subtract player y to move up
	mov [player_y], bx ;move the updated y position to memory
	xor cl, cl ;fill cl with 0
	mov [input_buffer], cl ;reset input_buffer to 0
	ret	
	
move_down:
	mov bx, [player_y] ;get player y position
	mov dx, [window_height] ;get window height
	sub dx, [player_height] ;subtract window height with player height
	cmp bx, dx ;check if player y is above the max
	jg return ;return if greater than max

	;execute if lower than max
	mov cx, [player_velocity] ;get player velocity
	add bx, cx ;add player y to move down
	mov [player_y], bx ;move the updated y position to memory
	xor cl, cl ;fill cl with 0
	mov [input_buffer], cl ;reset input_buffer to 0
	ret
	
return:
	ret
	
check_input:
	mov ah, 0x01 ;function to get input status
	int 0x16 ;interrupt to execute keyboard service

	jz no_input ;zero flag set if no input

	mov ah, 0x00 ;function to get the input key if input status is true
	int 0x16 ;interrupt to execute keyboard service
	mov [input_buffer], al ;store the key value in memory

no_input:
	ret
	
draw_player:
	
	mov di, 0 ;x offset
	mov si, 0 ;y offset
	
draw_player_x:
	
	mov ah, 0x0c ;draw pixel function
	mov al, 0x0f ;color white
	mov bh, 0 ;page number

	mov cx, [player_x] ; x position 
	mov dx, [player_y] ; y position	
	
	add cx, di ;add x offset
	add dx, si ;add y offset
	
	int 0x10 ;interrupt to draw pixel
	
	cmp di, [player_width] ;compare x to player size 
	inc di ;increase x offset
	jb draw_player_x ;jump if less than or equal to 0

draw_player_y:
	mov di, 0 ;reset x offset
	inc si ;increase y offset
	cmp si, [player_height] ;compare y to player size
	jb draw_player_x ;jump if less than or equal to 0
	ret 
	
check_ball_collision:
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
	mov al, 0x0f ;color white
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
	dw 0x0004 ;ball size
	
ball_velocity_x:
	dw 0x0003 ;ball velocity x

ball_velocity_y:
	dw 0x0002 ;ball velocity y	
	
window_width:
	dw 0x012c ;300 in decimal (idk why but setting it to 320 doesnt work for drawing the ball while moving)
	
window_height:
	dw 0x00c8 ;200 in deximal (300x200) window

player_x:
	dw 0x0000 ;player position x

player_y:
	dw 0x0000 ;player position y

player_width:
	dw 0x0005 ;player width

player_height:
	dw 0x000f ;player height

player_velocity:
	dw 0x000a ;player velocity

input_buffer:
	resb 1
times 510-($-$$) db 0
db 0x55,0xaa
