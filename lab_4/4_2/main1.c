#include <stdio.h>

void additive_inverse(int* a);

int main() {
	int x = -100;
	printf("Initial value of x: %d\n", x);
	additive_inverse(&x);
	printf("Value of x after calling function: %d", x);

	return 0;
}