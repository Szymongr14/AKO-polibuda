#include <stdio.h>
#include <stdlib.h>
#define SIZE 60

int sum_function(int tab[], int size);

int main() {

	char array[SIZE];
	int numbers = 1;
	char number[SIZE];

	gets_s(array, SIZE);

	for (int i = 0; i < SIZE; i++) {
		if (array[i] == ' ') numbers++;
		if (array[i] == '\0') break;
	}

	int* int_array = calloc(numbers, sizeof(int));

	int index_array = 0;
	int index_number = 0;
	for (int i = 0; i < SIZE; i++) {
		if (array[i] == '\0') {
			int_array[index_array++] = atoi(number);
			index_number = 0;
			memset(number, 0, sizeof number);
			break;
		}
		if (array[i] == ' ') {
			int_array[index_array++] = atoi(number);
			index_number = 0;
			memset(number, 0, sizeof number);
			continue;
		}
		number[index_number++] = array[i];
	}

	int sum1 = sum_function(int_array, numbers);

	printf("Sum of ");
	for (int i = 0; i < numbers; i++) {
		printf("%d, ", int_array[i]);
	}
	printf("is: %d", sum1);

	return 0;
}