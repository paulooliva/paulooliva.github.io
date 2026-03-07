/*
  Labyrinth
  CERC 1999, Tomas Brejcha
*/

#include <stdio.h>

char lab[1010][1010];			//lab[row][column]
int BestX, BestY;	 			//set by search when it exits

int search (int r, int s)
{
	int best, last;
	int bestX, bestY;			
	if (lab[r][s] == '.')
	{
		lab[r][s] = 'x';
		bestX = s; bestY = r; best =0;

		last = search (r-1, s);
		if (last>best)	{bestX = BestX; bestY = BestY; best = last;}

		last = search (r+1, s);
		if (last>best)	{bestX = BestX; bestY = BestY; best = last;}

		last = search (r, s-1);
		if (last>best)	{bestX = BestX; bestY = BestY; best = last;}

		last = search (r, s+1);
		if (last>best)	{bestX = BestX; bestY = BestY; best = last;}
	
		BestX = bestX; BestY = bestY;
		return best+1;
	}
	return 0;
}

int main()
{
	int n, x, y, i, j, k, l;
	scanf("%i", &n);
	for (i=0; i<n; i++)		
	{
		// reads input
		scanf ("%i %i", &x, &y);	// x number of columns, y rows
		for (j=0; j<y; j++)	scanf("%s", lab[j]);

		//finds first nonwall square
		k = l = 1;
		while (lab[k][l]=='#')
		{
			if (k<y-1) k++;
			else {k = 1; l++;}
		}

		search (k, l);
		for (k=0; k<y; k++) for (l=0; l<x; l++) if (lab[k][l]=='x') lab[k][l] = '.';
							else if (lab[k][l]=='.') printf("Podelanej generator!!!!!!!!!");
		printf("Maximum rope length is %i.\n", search(BestY, BestX)-1);
	}
	return 0;
}
