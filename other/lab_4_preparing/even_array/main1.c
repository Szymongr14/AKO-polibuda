#include <stdio.h>
#define SIZE 14

int* tablica_nieparzystych(int tab[], unsigned int* size);

int main() {
	int tablica[SIZE] = { 1,2,3,4,5,6,7,8,9,0,11,13,19,21 };
	int n = SIZE;

	printf("Tablica poczatkowa: ");
	for (int i = 0; i < n; i++) {
		printf("%d, ", tablica[i]);
	}

	int* tablica_np = tablica_nieparzystych(tablica, &n);


	printf("\nZnalezione liczby pierwsze: ");
	for (int i = 0; i < n; i++) {
		printf("%d, ", tablica_np[i]);
	}

	return 0;
}