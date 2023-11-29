#include <stdio.h>
#include <stdlib.h>
#define SIZE 60

int sum(int tab[], int size);

int main() {

	char array[SIZE];
	int numbers = 1;
	char number[SIZE];

	gets_s(array, SIZE);

	for (int i = 0; i < SIZE; i++) {
		if (array[i] == ' ') numbers++;
		if (array[i] == '\n') break;
	}

	int* int_array = calloc(numbers, sizeof(int));

	int index_array = 0;
	int index_number = 0;
	for (int i = 0; i < SIZE; i++) {
		if (array[i] == '\n') break;
		if (array[i] == ' ') {
			int_array[index_array++] = atoi(number);
			index_number = 0;
			continue;
		}
		number[i] = array[i];
	}

	int sum1 = sum(int_array, numbers);



	return 0;
}