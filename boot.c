#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>


typedef void (*routine)();

int main(int argc, char** argv) {
	struct stat S;
	void* A = (void*)0x800000000;
	if (argc != 2) {
		fprintf(stderr,"Usage: boot image\n");
		exit(0);
	}
	int F = open(argv[1],O_RDWR);
	fstat(F,&S);
	routine R = (routine)mmap(A,S.st_size,PROT_READ|PROT_WRITE|PROT_EXEC,MAP_FILE|MAP_SHARED|MAP_FIXED,F,0);
	if (!R || R ==  MAP_FAILED ) {
		fprintf(stderr,"Failed to map file %s\n",argv[1]);
		exit(0);	
	}
	fprintf(stderr,"Mapped to %p\n", R);
	R();
	fprintf(stderr,"Done\n");
	return 0;	
}
