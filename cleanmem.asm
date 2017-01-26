;
; CleanMem.DLL, ported to FASM and optimized
; Assemble in FASM (http://flatassembler.net/)
; Thanks, score_under

format PE GUI 4.0 DLL

include 'win32a.inc'

section '.shg' data code readable writeable executable

halo_shg_clean:
  call [GetCurrentProcessId]
  push eax
  push 0
  push 0x1F0FFF
  call [OpenProcess]
  push eax
  push eax
  call [EmptyWorkingSet]
  push eax
  fild dword[esp]
  pop eax
  call [CloseHandle]
  ret

align 0x10

halo_shg_get_mem:
  call [GetCurrentProcessId]
  push eax
  push 0
  push 0x1F0FFF
  call [OpenProcess]
  push eax
  sub esp,0x28
  push 0x28
  lea ecx,[esp+4]
  push ecx
  push eax
  call [GetProcessMemoryInfo]
  test eax,eax
  jnz .ok
  fldz
  add esp,0x28
  jmp .ret
.ok:
  push dword[esp+0xC]
  fild dword[esp]
  add esp,0x2C
.ret:
  call [CloseHandle]
  ret
align 4
data import
library kernel32,'KERNEL32.DLL',psapi,'PSAPI.DLL'
import kernel32,GetCurrentProcessId,'GetCurrentProcessId',\
		OpenProcess,'OpenProcess',CloseHandle,'CloseHandle'
import psapi,EmptyWorkingSet,'EmptyWorkingSet',\
	     GetProcessMemoryInfo,'GetProcessMemoryInfo'
end data
align 4
data fixups
end data
align 4
data export
export 'CleanMem.dll',mem_clean,'mem_clean',\
		      mem_get_mem,'mem_get_mem'
end data


