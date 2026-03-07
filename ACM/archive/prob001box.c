/* Tomas Kopal <T.Kopal@sh.cvut.cz> */
/* CERC 1999, CTU Prague, Czech Republic */

#define TEXT_YES "Escape is possible.\n"
#define TEXT_NO "Box cannot be dropped.\n"

#include <stdio.h>
#include <math.h>

int main()
{
  /* number of tasks */
  unsigned int N;
  /* sides of rectangles */
  unsigned int A, B, C, D;
  /* diagonals */
  double X, Y;
  /* distances of intersection */
  double K, L;
  /* the longest possible shorter side of the inner rectangle */
  double DMax;

  scanf("%d", &N);
  for (; N > 0; N--)
  {
    /*
     * Read in the data
     */

    /* the first (outer) and the second (inner) rectangle */
    scanf("%d %d %d %d", &A, &B, &C, &D);
    /* first, normalize rectangles to one single case (A >= B, C >= D) */
    if (A < B)
    {
      unsigned int tmp = A;
      A = B;
      B = tmp;
    }
    if (C < D)
    {
      unsigned int tmp = C;
      C = D;
      D = tmp;
    }

    /*
     * Next, compute whether the rectangles can be put together
     */

    /* trivial case */
    if (A > C && B > D)
      printf(TEXT_YES);
    else
      if (D >= B)
        printf(TEXT_NO);
      else
      {
        /* outer rectangle's diagonal */
        X = sqrt((double)A * (double)A + (double)B * (double)B);
        /* inner rectangle's diagonal */
        Y = sqrt((double)C * (double)C + (double)D * (double)D);
        /* check for marginal conditions */
        if (Y < B)
          printf(TEXT_YES); /* the inner rectangle can freely rotate inside */
        else
          if (Y > X)
            /* there is no way how to put inner rectangle inside of the outer
               one with the diagonal of the inner longer than the diagonal of
               the outer */
            printf(TEXT_NO);
          else
          {
            /*
             * now, we compute intersection of inner rectangle's diagonal and
             * sides of the outer one
             */
            /* distance between the closest corner and the intersection */
            L = (B - sqrt(Y * Y - (double)A * (double)A)) / 2;
            /* distance of the same corner and the second intersection */
            K = (A - sqrt(Y * Y - (double)B * (double)B)) / 2;
            /* maximal possible shorter side of the inner rectangle with give
               diagonal */
            DMax = sqrt(L * L + K * K);
            /* if the actual side is longer, rectangles do not pass, but
               they pass otherwise */
            if (D >= DMax)
              printf(TEXT_NO);
            else
              printf(TEXT_YES);
          }
      }
  }
  return 0;
}
