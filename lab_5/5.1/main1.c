#include <stdio.h>
#define SIZE 4

float srednia_harm(float tab[], unsigned int n);

int main() {
	float array[SIZE] = { 1.54, 434.43, 1.2, 5.6 };

	float wynik = srednia_harm(array, SIZE);

	printf("Srednia harmoniczna z ");
	for (int i = 0; i < SIZE; i++) {
		printf("%f, ", array[i]);
	}
	printf("to : %f", wynik);

	return 0;
}