#include <stdio.h>

float nowy_exp(float x);

int main() {
	float x = 2.0;
	float wynik = nowy_exp(x);
	printf("Suma szeregu to: %f", wynik);

	return 0;
}