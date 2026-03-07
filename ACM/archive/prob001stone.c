/*
  Lifting the Stone
  CERC 1999, Martin Kacer
*/

#include <stdio.h>
#include <math.h>

#define SX  21000   /* shift to get to positive numbers */
#define SY  21000   /* must be greater than the maximum negative value */
      /* this is not needed, just for being more sure! */


/***** edges going to the right *****/
double xtr, ytr;   /* temporary position of the centre */
double wtr;   /* weight of already counted region */

/***** edges going to the left *****/
double xtl, ytl;   /* temporary position of the centre */
double wtl;   /* weight of already counted region */


int iszero (double w)
{
   return ( w < 1E-10 && w > -1E-10 );
}


/*
the function adds the region to the center and its weight
*/
void AddPosPart (double x, double y, double w)
{
   if ( iszero (wtr + w) )  exit (1);   /* detect zero regions */
   
   xtr = ( wtr*xtr + w*x ) / ( wtr + w );
   ytr = ( wtr*ytr + w*y ) / ( wtr + w );
   wtr = w + wtr;
}
void AddNegPart (double x, double y, double w)
{
   if ( iszero (wtl + w) )  exit (1);   /* detect zero regions */

   xtl = ( wtl*xtl + w*x ) / ( wtl + w );
   ytl = ( wtl*ytl + w*y ) / ( wtl + w );
   wtl = w + wtl;
}

/*
adds the region under the given line (between it and x-axis)
*/
void AddRegion (double x1, double y1, double x2, double y2)
{
   if ( iszero (x1 - x2) )  return;

   if ( x2 > x1 )
   {
      /***** rectangle *****/
      AddPosPart ((x2+x1)/2, y1/2, (x2-x1) * y1);
      /***** triangle *****/
      AddPosPart ((x1+x2+x2)/3, (y1+y1+y2)/3, (x2-x1)*(y2-y1)/2);
   }
   else
   {
      /***** rectangle *****/
      AddNegPart ((x2+x1)/2, y1/2, (x2-x1) * y1);
      /***** triangle *****/
      AddNegPart ((x1+x2+x2)/3, (y1+y1+y2)/3, (x2-x1)*(y2-y1)/2);
   }
}


int main (void)
{
   int tasks;
   double xt, yt;
   scanf ("%d\n", &tasks);
   
   while ( tasks-- )
   {
      int edges;
      int x1, y1, x2, y2, x0, y0;
      xtr = ytr = wtr = 0.0;
      xtl = ytl = wtl = 0.0;
      scanf ("%d\n", &edges);
      scanf ("%d %d\n", &x0, &y0);
      x0 += SX; y0 += SY;
      x1 = x0; y1 = y0;
      
      while ( --edges )
      {
         scanf ("%d %d\n", &x2, &y2);
         x2 += SX; y2 += SY;
         AddRegion ((double)x1, (double)y1, (double)x2, (double)y2);
         x1 = x2; y1 = y2;
      }

      /***** the last edge *****/
      AddRegion ((double)x1, (double)y1, (double)x0, (double)y0);

      /***** subtract the left-going edges *****/
      if ( iszero (wtr + wtl) )  exit (2);   /* detect zero areas */
      xt = (wtr*xtr + wtl*xtl) / (wtr + wtl);
      yt = (wtr*ytr + wtl*ytl) / (wtr + wtl);

      xt += 1E-8; yt += 1E-8;   /* to prevent "negative zeros" */
      xt -= SX; yt -= SY;
      printf ("%.2f %.2f\n", xt, yt);
   }
   return 0;
}
