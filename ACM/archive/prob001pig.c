/*
  Piggy-Bank
  CERC 1999, Martin Kacer
*/

#include <stdio.h>

#define MAXWEIGHT  (10240)
#define MAXCOINS  (512)
#define INFINITY  (0x3FFFFFFF)


int best [MAXWEIGHT];
int coinw [MAXCOINS];   /* weights */
int coinp [MAXCOINS];   /* values */

int main (void)
{
   int tasks;
   scanf ("%d\n", &tasks);
   while ( tasks-- )
   {
      int e,f;
      int i, j, n;
      
      scanf ("%d %d\n", &e, &f);
      f -= e;

      scanf ("%d\n", &n);
      for ( i = 0;  i < n;  ++i )
         scanf ("%d %d\n", coinp + i, coinw + i);

      best[0] = 0;
      for ( j = 1;  j <= f;  ++j )
      {
         best[j] = INFINITY;
         for ( i = 0;  i < n;  ++i )
            if ( coinw[i] <= j )
               if ( best[j - coinw[i]] + coinp[i] < best[j] )
                  best[j] = best[j - coinw[i]] + coinp[i];
      }
      printf ((best[f] < INFINITY)
            ? "The minimum amount of money in the piggy-bank is %d.\n"
            : "This is impossible.\n",
            best[f]);
   }
   return 0;
}

