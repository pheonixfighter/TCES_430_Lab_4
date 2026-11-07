// Robert Cromer
// TCES 430
// This file contails the ARM assembly equivalent of teh following C code:

/*
i = 1;
j = 0;
k = 1;
while (i > j) {
	i = 1 + a - 2 * j;
	if (j >= k) {
		i = i + 2;
		k = k - b + 2 * j;
	}
	j++;
}
*/

