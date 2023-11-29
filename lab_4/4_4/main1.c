#include <stdio.h>

void set_max_to_the_end(int* tab, int size);

//void swap(int* a, int* b) {
//	int temp = *a;
//	*a = *b;
//	*b = temp;
//}


//void bubble_sort(int tab[], int n) {
//	for (int i = 0; i < n - 1; i++) {
//		for (int j = 0; j < n - i - 1; j++) {
//			if (tab[j] > tab[j + 1]) swap(&tab[j], &tab[j + 1]);
//		}
//	}
//}

int main() {
	int array[8] = { 300,500,7,1,0, 23,100,21 };


	for (int i = 8; i > 0; i--) {
		set_max_to_the_end(array, i);

	}

	for (int i = 0; i < 8; i++) {
		printf("%d\n", array[i]);
	}


	return 0;
}