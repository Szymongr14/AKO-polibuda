#include <stdio.h>

int find4_max(int a, int b, int c, int d);

int main() {
	int x, y, z, v, result;
	printf("Type four digits: ");
	scanf_s("%d %d %d %d", &x, &y, &z, &v, 32);
	result = find4_max(x, y, z, v);
	printf("Among values %d, %d, %d, %d max is: %d", x, y, z, v, result);

	return 0;
}