#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
	struct stat S;
	fprintf(stderr,"%ld\n%p\n%p\n",sizeof(struct stat),&S.st_size,&S);
	return 0;
}
