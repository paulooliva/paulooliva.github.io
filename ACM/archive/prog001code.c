/*
  Secret Code
  CERC 1999, Martin Ryzl
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define DEBUG 1
#define MAX_N 1000
#define MAX_DIGITS 100


#define FMT_IMPOSSIBLE "The code cannot be decrypted."
#define FMT_NUM "%d"
#define FMT_ZERO "0\n"

int sqrti(int n) {            /* vrati k, k^2 < n, (k+1)^2 > n */
  int i,k;

  for(k = 0, i = 1; n > i;) {
    k++;
    n -= i;
    i += 2;
  }
  return k;
}

int getMAXC(int br, int bi) {
  int B2 = br*br + bi*bi, MAX_C = sqrti(B2);
  
  if (MAX_C * MAX_C == B2) MAX_C--;
  return MAX_C;
}

int compute(int xr, int xi, int br, int bi, int digits[]) {

  int xrb = xr, xib = xi;  /* for check. */

  int MAX_C = 0, B2;  
  int i, xxr, xxi, n = 0, j;

  MAX_C = getMAXC(br, bi);
  B2 = br * br + bi * bi;

  for(j = 0;((xr != 0) || (xi != 0)) && (j < MAX_DIGITS); j++) {
    for(i = 0; i <= MAX_C; i++) {
      xxr = (xr - i) * br + xi * bi;
      xxi = (xi * br - (xr - i) * bi);
      /*
      printf("i=%d,b2=%d,xr=%d,xi=%d,xxr=%d, xxi=%d\n", i, B2, xr, xi, xxr, xxi); 
      printf("xxr mod b2 = %d, xxi mod b2 = %d\n", xxr % B2, xxi %B2);
      */
      
      if (!(xxr % B2) && !(xxi % B2)) {
	digits[n++] = i;
	xr = xxr / B2; xi = xxi /B2;
	break;
      }
    }
    if (i > MAX_C) return 0; /* such a c not found */
  }
  

  if ((xr != 0) || (xi != 0)) return 0;

  /** check it */
#ifdef DEBUG
  {
    int bxr = 1, bxi = 0, b2r, b2i;
    xi = 0; xr = 0;
    for(i = 0; i < n; i++) {
      xr += digits[i] * bxr;
      xi += digits[i] * bxi;
      b2r = br * bxr - bi * bxi;
      b2i = br * bxi + bi * bxr;
      bxr = b2r;
      bxi = b2i;
    }
    if ((xr != xrb) || (xi != xib)) {
      printf("ERRORR: %d %d %d %d\n", xrb, xib, br, bi);
      exit(1);
    }
  }
#endif DEBUG  
  return n;
}

void processProblem() {
  int xr, xi, br, bi;
  int digits[MAX_N];
  int n;

  scanf("%d %d %d %d", &xr, &xi, &br, &bi);
  if ((xr == 0) && (xi == 0)) {
    printf(FMT_ZERO);
    return;
  }
  n = compute(xr, xi, br, bi, digits);
  if (n == 0) {
    printf(FMT_IMPOSSIBLE);
  } else {
    while (n) {
      printf(FMT_NUM, digits[--n]);
      if (n) printf(",");
    }
  }
  printf("\n");
}

int main(int argv, char **argc) {

  int N;

  scanf("%i", &N);
  while (N--) processProblem();
  return 0;
}

