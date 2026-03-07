import java.io.*;
import java.util.*;

/**
 * Honeycomb
 * Solution taken from http://contest.mff.cuni.cz/archive/finl1999/index.html
 */

public class Honeycomb {

static int min(int a, int b) { return (((a)>(b))?(b):(a)); }

static int abs(int a) { return (((a)>(-(a)))?(a):(-(a))); }

static void convert(int bod, int[] v) {
	int a, b, c;
	int str, zb;
	
	if(bod==1) { v[0]=0; v[1]=0; v[2]=0; return; }
	
	a=(bod-2)/6;
	double sq = Math.sqrt(1.0+8.0*(double)a);
	b= (int) ((-1.0+sq)/2.0);
	c=bod-1-3*b*(b+1);
	++b;
	str=(c-1)/b;
	zb=c-str*b; 
	switch (str) {
		case 0: v[0]=-zb;  v[1]=-b; break;
		case 1: v[0]=-b;   v[1]=zb-b; break;
		case 2: v[0]=zb-b; v[1]=zb; break;
		case 3: v[0]=zb;   v[1]=b; break;
		case 4: v[0]=b;    v[1]=b-zb; break;
		case 5: v[0]=b-zb; v[1]=-zb; break;
	}
	v[2] = v[0]-v[1];
	return;  
}

public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	int a, b, x, y, z, pom;
	int[] va = {0,0,0};
	int[] vb = {0,0,0};

	in.nextToken();
	a = (int) in.nval;

	while (a!=0) {
	    in.nextToken();
	    b = (int) in.nval;
	
		convert(a, va);
		convert(b, vb);
		x = abs(va[0]-vb[0]);
		y = abs(va[1]-vb[1]);
		z = abs(va[2]-vb[2]);
		pom=min(x+y,x+z);

		System.out.println( "The distance between cells " + a + " and " + b + " is " + min(pom,y+z) + ".");

	    in.nextToken();
	    a = (int) in.nval;
	}
}

}