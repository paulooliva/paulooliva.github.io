import java.io.*;
import java.util.*;

/**
 * Simply Subsets
 * Solution by Paulo Oliva
 * Created on Dec 19, 2007
 */

public class Subsets {

static int[][] sets;
static int[] sizes;
	
public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	sets = new int[2][101];	
	sizes = new int[2];

	readSet(0, in); readSet(1, in);

	while(sizes[0]!=0 || sizes[1]!=0) {
		boolean v1 = subset(0,1);
		boolean v2 = subset(1,0);
		if (v1) {
			if (v2) System.out.println("A equals B");
			else System.out.println("A is a proper subset of B");
		}
		else {
			if (v2) System.out.println("B is a proper subset of A");
			else {
				if (!commonEl()) System.out.println("A and B are disjoint");
				else System.out.println("I'm confused");
			}
		}
		readSet(0, in); readSet(1, in);
	}
}

static void readSet(int i, StreamTokenizer in) throws IOException {
	in.nextToken();
	sizes[i]=0;
	while (((int) in.nval) != 0) {
		sets[i][sizes[i]++] = (int) in.nval;
		in.nextToken();
	}
}

static boolean subset(int i, int j) {
	for (int k=0; k<sizes[i]; k++) { if (!belongs(sets[i][k], j)) return false;}
	return true;
}

static boolean commonEl () {
	for (int k=0; k<sizes[0]; k++) { if (belongs(sets[0][k], 1)) return true;}
	return false;
}

static boolean belongs(int val, int i) {
	for (int k=0; k<sizes[i]; k++) { if (sets[i][k]==val) return true;}
	return false;
}

}