/*
Source to CleanMem
by Anthony DeSouza
*/
#define gmexport extern "C" __declspec (dllexport)
#include <windows.h>
#include <psapi.h>

gmexport double mem_clean() {
	DWORD pid;
	pid = GetCurrentProcessId();
	HANDLE process = OpenProcess( 
								PROCESS_QUERY_INFORMATION | 
								PROCESS_VM_READ | 
								PROCESS_ALL_ACCESS, 
								FALSE, pid);
	int emp;
	emp = EmptyWorkingSet(process);
	CloseHandle(process);
	return (double)emp;
}