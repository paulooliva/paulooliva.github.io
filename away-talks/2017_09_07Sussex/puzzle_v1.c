#include<stdio.h>

int n = 10;

int distinct(int *xs) {
	int found=0;
	for (int i=1;i<=n;i++)
		for (int j=0;j<n;j++)
			if (xs[j] == i) {
				found++;
				break;
			}
	return found == n;
}

//  0
//  1 2 3 4
//  5 6 7 8
//  9

void print (int* xs) {
	printf("%d\n", xs[0]);
	for (int i=0;i<4;i++)
		printf("%d ", xs[1+i]);
	printf("\n");
	for (int i=0;i<4;i++)
		printf("%d ", xs[5+i]);
	printf("\n");
	printf("%d\n", xs[9]);
}

int good(int *xs) {
	int test1 = distinct(xs);
	int sum1 = xs[0] + xs[1] + xs[5] + xs[9];
	int sum2 = xs[1] + xs[2] + xs[3] + xs[4];
	int sum3 = xs[5] + xs[6] + xs[7] + xs[8];
	int test2 = (sum1 == sum2) && (sum2 == sum3);
	return test1 && test2;
}

int main () {
int xs[n];

for (xs[0]=1; xs[0]<=n; xs[0]++)
	for (xs[1]=1; xs[1]<=n; xs[1]++)
		for (xs[2]=1; xs[2]<=n; xs[2]++)
			for (xs[3]=1; xs[3]<=n; xs[3]++) 
				for (xs[4]=1; xs[4]<=n; xs[4]++)
					for (xs[5]=1; xs[5]<=n; xs[5]++)
						for (xs[6]=1; xs[6]<=n; xs[6]++)
							for (xs[7]=1; xs[7]<=n; xs[7]++)
								for (xs[8]=1; xs[8]<=n; xs[8]++)
									for (xs[9]=1; xs[9]<=n; xs[9]++) { 
										if (good(xs)) {
											print(xs);
											return 0;
										}
									}
}

