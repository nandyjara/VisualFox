

PUBLIC ff
ff = CreateObject('frm')
ff.visible = .T.
RETURN


#DEFINE tetris 4
#DEFINE c0 128 && color constant
#DEFINE c1 196 && color constant
#DEFINE sqee_width 20
#DEFINE sqee_height 20
#DEFINE bucketWidth 12
#DEFINE bucketHeight 24
#DEFINE dropInterval 200 && millisecond
#DEFINE keyLeft 19
#DEFINE keyRight 4
#DEFINE keyDrop 32
#DEFINE keyRotate 5

DEFINE CLASS sqee As Shape
	Owner = 0 && (0)empty, (1)debris, all others - Figure.Mode
	Width = sqee_width
	Height = sqee_height
	BorderColor = RGB (240,240,255)
	BackColor = RGB(255,255,255)
ENDDEFINE

DEFINE CLASS figure As Custom
	DIMEN arrX [tetris]
	DIMEN arrY [tetris]
	dY = 1
	dX = 1
	mode = 0
	main = .F.
	BackColor = 0
	turned_counter = 0
	turned_counter_dy = 0
	turned_counter_dx = 0
	turned_clockwise = 0
	turned_clockwise_dy = 0
	turned_clockwise_dx = 0
	
	PROCEDURE init
		THIS.BackColor = THIS.get_color()
		THIS.after_init
	ENDPROC
	
	PROCEDURE assign_neighbours (tl, tly, tlx, tr, try, trx)
		THIS.turned_counter = tl
		THIS.turned_counter_dy = tly
		THIS.turned_counter_dx = tlx
		THIS.turned_clockwise = tr
		THIS.turned_clockwise_dy = try
		THIS.turned_clockwise_dx = trx
	ENDPROC

	PROCEDURE init_arr (y1,x1, y2,x2, y3,x3, y4,x4)
		THIS.arrX [1] = x1
		THIS.arrX [2] = x2
		THIS.arrX [3] = x3
		THIS.arrX [4] = x4
		THIS.arrY [1] = y1
		THIS.arrY [2] = y2
		THIS.arrY [3] = y3
		THIS.arrY [4] = y4
	ENDPROC
	
	PROCEDURE reset_figure
		STORE 1 TO THIS.dY, THIS.dX
	ENDPROC
	
	FUNCTION get_color ()
		DO CASE
		CASE INLIST (THIS.mode, 1,11)
			RETURN RGB (c1,c0,c0)
		CASE THIS.mode = 2
			RETURN RGB (c1,c1,c0)
		CASE INLIST (THIS.mode, 3,31,32,33)
			RETURN RGB (c1,c0,c1)
		CASE INLIST (THIS.mode, 4,41)
			RETURN RGB (c0,c1,c1)
		CASE INLIST (THIS.mode, 5,51)
			RETURN RGB (c0,c1,c0)
		CASE INLIST (THIS.mode, 6,61,62,63)
			RETURN RGB (c0,c0,c1)
		CASE INLIST (THIS.mode, 7,71,72,73)
			RETURN RGB (c0,c0,c0)
		OTHER
			RETURN RGB (c1,c1,c1)
		ENDCASE
	ENDFUNC
	
	PROCEDURE set_state (numColor, numOwner)
		LOCAL ii
		FOR ii=1 TO tetris
			WITH ThisForm.d.arr [ THIS.dY+THIS.arrY[ii], THIS.dX+THIS.arrX[ii] ]
				.BackColor = numColor
				.Owner = numOwner
			ENDWITH
		ENDFOR
	ENDPROC
	
	PROCEDURE set_visible
		THIS.set_state (THIS.BackColor, THIS.mode)
	ENDPROC
	
	PROCEDURE set_free
		THIS.set_state (THIS.Parent.BackColor, 0)
	ENDPROC

	PROCEDURE set_debris
		THIS.set_state (THIS.BackColor, -1)
	ENDPROC

	PROCEDURE set_owner (numOwner)
		LOCAL ii
		FOR ii=1 TO tetris
			WITH ThisForm.d.arr [ THIS.dY+THIS.arrY[ii], THIS.dX+THIS.arrX[ii] ]
				.Owner = numOwner
			ENDWITH
		ENDFOR
	ENDPROC
	
	PROCEDURE conflict (dY,dX, allowedMode)
		LOCAL ii
		FOR ii=1 TO tetris
			IF Not (BETW(dY+THIS.dY+THIS.arrY[ii], 1, bucketHeight);
			   And BETW(dX+THIS.dX+THIS.arrX[ii], 1, bucketWidth))
				RETURN .T.
			ENDIF

			WITH ThisForm.d.arr [ dY+THIS.dY+THIS.arrY[ii], dX+THIS.dX+THIS.arrX[ii] ]
				IF Not (.Owner=0 Or .Owner=THIS.mode Or .Owner=allowedMode)
					RETURN .T.
				ENDIF
			ENDWITH
		ENDFOR
		RETURN .F.
	ENDPROC
	
	FUNCTION move_ (dY,dX)
		IF THIS.Conflict (dY,dX,0)
			RETURN .F.
		ELSE
			THIS.set_free
			THIS.dY = THIS.dY + dY
			THIS.dX = THIS.dX + dX
			THIS.set_visible
			RETURN .T.
		ENDIF
	ENDPROC
	
	PROCEDURE move_down
		RETURN THIS.move_ (1,0)
	ENDPROC

	PROCEDURE move_left
		RETURN THIS.move_ (0,-1)
	ENDPROC

	PROCEDURE move_right
		RETURN THIS.move_ (0,1)
	ENDPROC
ENDDEFINE

DEFINE CLASS f1 As figure && vertical stick
	mode = 1
	main = .T.
	PROCEDURE after_init
		THIS.init_arr (0,0, 1,0, 2,0, 3,0)
		THIS.assign_neighbours (11,2,-1, 11,2,-2)
	ENDPROC
ENDDEFINE

DEFINE CLASS f11 As figure && horizontal stick
	mode = 11
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (0,0, 0,1, 0,2, 0,3)
		THIS.assign_neighbours (1,-2,1, 1,-2,2)
	ENDPROC
ENDDEFINE

DEFINE CLASS f2 As figure && square
	mode = 2
	main = .T.
	PROCEDURE after_init
		THIS.init_arr (0,0, 0,1, 1,0, 1,1)
		THIS.assign_neighbours (2,0,0, 2,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f3 As figure && t-bone
	mode = 3
	main = .T.
	PROCEDURE after_init
		THIS.init_arr (0,0, 0,1, 0,2, 1,1)
		THIS.assign_neighbours (32,0,0, 31,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f31 As figure && t-bone rotated
	mode = 31
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (0,0, 1,0, 2,0, 1,1)
		THIS.assign_neighbours (3,0,0, 33,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f32 As figure && t-bone rotated
	mode = 32
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (0,1, 1,1, 2,1, 1,0)
		THIS.assign_neighbours (33,0,0, 3,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f33 As figure && t-bone rotated
	mode = 33
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (1,0, 1,1, 1,2, 0,1)
		THIS.assign_neighbours (31,0,0, 32,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f4 As figure && zed1
	mode = 4
	main = .T.
	PROCEDURE after_init
		THIS.init_arr (0,0, 0,1, 1,1, 1,2)
		THIS.assign_neighbours (41,0,0, 41,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f41 As figure && zed1 rotated
	mode = 41
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (2,0, 1,0, 1,1, 0,1)
		THIS.assign_neighbours (4,0,0, 4,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f5 As figure && zed2
	mode = 5
	main = .T.
	PROCEDURE after_init
		THIS.init_arr (1,0, 1,1, 0,1, 0,2)
		THIS.assign_neighbours (51,0,0, 51,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f51 As figure && zed2 rotated
	mode = 51
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (0,0, 1,0, 1,1, 2,1)
		THIS.assign_neighbours (5,0,0, 5,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f6 As figure && scrap1
	mode = 6
	main = .T.
	PROCEDURE after_init
		THIS.init_arr (0,0, 1,0, 2,0, 0,1)
		THIS.assign_neighbours (62,0,0, 61,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f61 As figure && scrap1 rotated
	mode = 61
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (1,0, 1,1, 1,2, 0,0)
		THIS.assign_neighbours (6,0,0, 63,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f62 As figure && scrap1 rotated
	mode = 62
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (0,0, 0,1, 0,2, 1,2)
		THIS.assign_neighbours (63,0,0, 6,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f63 As figure && scrap1 rotated
	mode = 63
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (0,1, 1,1, 2,1, 2,0)
		THIS.assign_neighbours (61,0,0, 62,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f7 As figure && scrap2
	mode = 7
	main = .T.
	PROCEDURE after_init
		THIS.init_arr (0,0, 0,1, 1,1, 2,1)
		THIS.assign_neighbours (72,0,0, 71,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f71 As figure && scrap2 rotated
	mode = 71
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (0,0, 0,1, 0,2, 1,0)
		THIS.assign_neighbours (7,0,0, 73,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f72 As figure && scrap2 rotated
	mode = 72
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (1,0, 1,1, 1,2, 0,2)
		THIS.assign_neighbours (73,0,0, 7,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS f73 As figure && scrap2 rotated
	mode = 73
	main = .F.
	PROCEDURE after_init
		THIS.init_arr (0,0, 1,0, 2,0, 2,1)
		THIS.assign_neighbours (71,0,0, 72,0,0)
	ENDPROC
ENDDEFINE

DEFINE CLASS bucket As Container
	max_mode = 7
	current_mode = 0
	BackColor = RGB(255,255,255)

	DIMEN ff [100]
	ADD OBJECT ff[ 1] As f1
	ADD OBJECT ff[11] As f11
	ADD OBJECT ff[ 2] As f2
	ADD OBJECT ff[ 3] As f3
	ADD OBJECT ff[31] As f31
	ADD OBJECT ff[32] As f32
	ADD OBJECT ff[33] As f33
	ADD OBJECT ff[ 4] As f4
	ADD OBJECT ff[41] As f41
	ADD OBJECT ff[ 5] As f5
	ADD OBJECT ff[51] As f51
	ADD OBJECT ff[ 6] As f6
	ADD OBJECT ff[61] As f61
	ADD OBJECT ff[62] As f62
	ADD OBJECT ff[63] As f63
	ADD OBJECT ff[ 7] As f7
	ADD OBJECT ff[71] As f71
	ADD OBJECT ff[72] As f72
	ADD OBJECT ff[73] As f73
	
	arr_size = bucketWidth * bucketHeight
	DIMEN arr [bucketHeight, bucketWidth]

	PROCEDURE Init
		THIS.AddSquees
		THIS.Width = sqee_width * bucketWidth
		THIS.Height = sqee_height * bucketHeight
	ENDPROC
	
	PROCEDURE AddSquees
		LOCAL lnY, lnX, lcName
		FOR lnY=1 TO bucketHeight
			FOR lnX=1 TO bucketWidth
				lcName = STRTRAN('arr'+STR(lnY,2) + '_' + STR(lnX,2), ' ','0')
				THIS.AddObject (lcName, 'sqee')
				THIS.arr [lnY,lnX] = EVAL('THIS.'+lcName)
				WITH THIS.arr [lnY,lnX]
					.left = (lnX-1) * sqee_width
					.top = (lnY-1) * sqee_height
					.Owner = 0
					.visible = .T.
				ENDWITH
			ENDFOR
		ENDFOR
	ENDPROC

	PROCEDURE RemoveSquees
		LOCAL lnY, lnX, lcName
		FOR lnY=1 TO bucketHeight
			FOR lnX=1 TO bucketWidth
				lcName = STRTRAN('arr'+STR(lnY,2) + '_' + STR(lnX,2), ' ','0')
				THIS.RemoveObject (lcName)
			ENDFOR
		ENDFOR
	ENDPROC
	
	FUNCTION init_figure
		THIS.current_mode = INT (RAND() * THIS.max_mode) + 1
		IF NOT BETW(THIS.current_mode, 1,THIS.max_mode)
			THIS.current_mode = 1
		ENDIF
		WITH THIS.ff [THIS.current_mode]
			.reset_figure
			IF .conflict (0,0,0)
				RETURN .F.
			ENDIF
			.set_visible
		ENDWITH
		RETURN .T.
	ENDFUNC
	
	FUNCTION debris_line (num) && if there is at least one line of debris
		LOCAL ii
		FOR ii=1 TO bucketWidth
			IF THIS.arr [num, ii].Owner <> -1
				RETURN .F.
			ENDIF
		ENDFOR
		RETURN .T.
	ENDFUNC
	
	FUNCTION find_debris_line
		LOCAL jj
		FOR jj=bucketHeight TO 1 STEP -1
			IF THIS.debris_line (jj)
				RETURN jj
			ENDIF
		ENDFOR
		RETURN 0
	ENDFUNC
	
	PROCEDURE shake_debris
		LOCAL num, jj, ii, savedColor
		num = THIS.find_debris_line()
		IF num = 0
			RETURN
		ENDIF
		
		* release line
		FOR ii=1 TO bucketWidth
			THIS.arr[num, ii].Owner = 0
			THIS.arr[num, ii].BackColor = THIS.BackColor
		ENDFOR
		
		* drop all other lines
		FOR jj=num-1 TO 1 STEP -1
			FOR ii=1 TO bucketWidth
				IF THIS.arr[jj,ii].Owner = -1
					savedColor = THIS.arr [jj, ii].BackColor
					THIS.arr [jj, ii].BackColor = THIS.BackColor
					THIS.arr [jj, ii].Owner = 0
					THIS.arr [jj+1, ii].BackColor = savedColor
					THIS.arr [jj+1, ii].Owner = -1
				ENDIF
			ENDFOR
		ENDFOR
	ENDPROC
	
	PROCEDURE rotate_figure (newMode, dY,dX)
		LOCAL obj
		WITH THIS.ff [THIS.current_mode]
			obj = THIS.ff [.turned_clockwise]
			obj.dY = .dY + .turned_clockwise_dY
			obj.dX = .dX + .turned_clockwise_dX
		ENDWITH
		
		IF Not obj.Conflict (0,0,THIS.current_mode)
			THIS.ff [THIS.current_mode].set_free
			THIS.current_mode = obj.mode
			THIS.ff [THIS.current_mode].set_visible
			RETURN .T.
		ELSE
			RETURN .F.
		ENDIF
	ENDPROC

	PROCEDURE rotate
		WITH THIS.ff [THIS.current_mode]
			DO WHILE .T.
				IF THIS.rotate_figure (.turned_clockwise, .turned_clockwise_dY, .turned_clockwise_dX)
					EXIT
				ELSE
					IF Not .move_right()
						EXIT
					ENDIF
				ENDIF
			ENDDO
		ENDWITH
	ENDPROC

	PROCEDURE rotate_counter_clockwise
		WITH THIS.ff [THIS.current_mode]
			THIS.rotate (.turned_counter, .turned_counter_dY, .turned_counter_dX)
		ENDWITH
	ENDPROC
ENDDEFINE

DEFINE CLASS frm As Form
	Caption = 'Tetris'
	MaxButton = .F.
	BorderStyle = 2
	KeyPreview = .T.
	ADD OBJECT d As bucket
	ADD OBJECT t As Timer
	
	PROCEDURE Init
		WITH THIS.d
			STORE 0 TO .top, .left
			THIS.Width = .Width
			THIS.Height = .Height
		ENDWITH
		THIS.d.init_figure
		THIS.t.Interval = dropInterval && setting speed
	ENDPROC
	
	PROCEDURE Destroy
		THIS.d.RemoveSquees
	ENDPROC
	
	PROCEDURE KeyPress
	LPARAMETERS nKeyCode, nShiftAltCtrl
		DO CASE
		CASE nKeyCode=27
			THIS.release
		CASE nKeyCode=keyLeft
			THIS.d.ff [THIS.d.current_mode].move_left
		CASE nKeyCode=keyRight
			THIS.d.ff [THIS.d.current_mode].move_right
		CASE nKeyCode=keyDrop
			DO WHILE THIS.d.ff [THIS.d.current_mode].move_down()
			ENDDO
		CASE nKeyCode=keyRotate
			THIS.d.rotate
		ENDCASE
	ENDPROC
	
	PROCEDURE t.Timer
		LOCAL obj
		WITH ThisForm.d
			obj = .ff [.current_mode]
			IF Not obj.move_down()
				obj.set_debris
				IF .init_figure()
					obj = .ff [.current_mode]
				ELSE
					ThisForm.release && here you lost
				ENDIF
			ENDIF
			.shake_debris
		ENDWITH
	ENDPROC
ENDDEFINE
