IFDEF RAX
	END_IF_NOT_X64 EQU <>
ELSE
	END_IF_NOT_X64 EQU end
ENDIF

END_IF_NOT_X64

.data

.code

aw_99 PROC
	; Create a 64-bit version of the Str_trim procedure.
	ret
aw_99 ENDP

end