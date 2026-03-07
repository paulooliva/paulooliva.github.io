#include <stdio.h>
#include <stdlib.h>

#define MAX_SQUARES 1000

int number_of_squares;
int number_of_visible;

struct t_square {
                  int x,y,length;
                } squares[MAX_SQUARES];

FILE *fp;

void read_input(void)
{
  int i;

  // reading from "SQUARES.IN"

  fp = fopen("SQUARES.IN","rt");

  fscanf(fp,"%d",&number_of_squares);

  for (i = 0;i < number_of_squares;++i)
  {
    fscanf(fp,"%d %d %d",&(squares[i].x),&(squares[i].y),&(squares[i].length));
    squares[i].y += squares[i].length; // lower left corner becomes upper left
  }

  fclose(fp);
}

// compare function for "qsort", sorting by angle, from left to right

int sort_func(const void *a,const void *b)
{
  if (((long) ((struct t_square *) a)->y) * ((struct t_square *) b)->x <
      ((long) ((struct t_square *) b)->y) * ((struct t_square *) a)->x)
    return 1;

  return -1;
}

// this function tells whether triangle made of three points is positive or
// negative oriented

int orientation(int x1,int y1,int x2,int y2,int x3,int y3)
{
  long result;

  result = ((long) x1) * (y2 - y3) + ((long) x2) * (y3 - y1) +
           ((long) x3) * (y1 - y2);

  if (result > 0)
    return 1;

  if (result < 0)
    return -1;

  return 0;
}

void solve(void)
{
  int i,j;
  int current_x,current_y;

  qsort(squares,number_of_squares,sizeof(squares[0]),sort_func);

  number_of_visible = 0;

  for (i = 0;i < number_of_squares;++i)
  {
    current_x = squares[i].x;
    current_y = squares[i].y;

    for (j = 0;j < number_of_squares;++j)
    {
      if (squares[j].x + squares[j].y >= squares[i].x + squares[i].y)
        continue;

      if (orientation(0,0,squares[j].x + squares[j].length,
                      squares[j].y - squares[j].length,current_x,current_y) !=
          orientation(0,0,squares[j].x,squares[j].y,current_x,current_y))
      {
        current_x = squares[j].x + squares[j].length;
        current_y = squares[j].y - squares[j].length;
      }
    }

    if (orientation(0,0,squares[i].x + squares[i].length,
                    squares[i].y - squares[i].length,current_x,current_y) > 0)
      ++number_of_visible;
  }

}

void write_output(void)
{
  // writing to "SQUARES.OUT"

  fp = fopen("SQUARES.OUT","wt");

  fprintf(fp,"%d\n",number_of_visible);

  fclose(fp);
}

int main(void)
{
  read_input();

  solve();

  write_output();

  return 0;
}
