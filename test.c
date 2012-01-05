

int main(int argc, char** argv) {
	
//	asm {
//		movq rax, 0xdeadbeef ;
//		movq rdx, 0xcafebabe ;
//		xorq rax, rdx ;
//		movq r15, rax ;
//	};
	asm("movq $1234, %rax\n\t" \
		"movq $4321, %rdx\n\t" \
		"xorq %rdx, %rax\n\t" \
		"movq %rax, %r15\n");
	return 1;

}
