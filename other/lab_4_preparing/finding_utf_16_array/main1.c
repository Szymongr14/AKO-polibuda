#include <stdio.h>

int find_element(unsigned short tab[], unsigned short wanted_character, int size);

int main() {
	unsigned short utf_16_characters[3] = { 0x0043, 0x0042, 0x0041 };
	unsigned short wanted_character = 0x0041;

	printf("Wanted charcter occurs:  %d\n", find_element(utf_16_characters, wanted_character, 3));

	return 0;
}