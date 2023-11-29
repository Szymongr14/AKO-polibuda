#include <stdio.h>

void minus_one(int** a);

int main() {
	int x;
	int* ptr_on_value = &x;
	int* ptr_on_address = &ptr_on_value;

	printf("Type value you want to substract one:");
	scanf_s("%d", ptr_on_value, 12);
	printf("\n");
	minus_one(&ptr_on_value);
	printf("Value after calling function: %d", x);
	return 0;
}