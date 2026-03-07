import java.io.*;
import java.util.*;

/**
 * Take the Land
 * Solution by Paulo Oliva
 * Created on Dec 18, 2007
 */

public class Land {

static int[][] s;
static int n, m;

public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	s = new int[101][101];

	in.nextToken();
	n = (int) in.nval;

	in.nextToken();
	m = (int) in.nval;

	while (m!=0) {
		for (int j=0;j<m*n;j++) {
			in.nextToken();
			s[j/m][j%m] = (int) in.nval;
		}
		int msize = 0;
		for (int i=0;i<m*n;i++)
			for (int j=i;j<m*n;j++) {
				if (!lessThan(i, j)) continue;
				boolean flag = true;
				for (int k=i;k<=j;k++) {
					if (!between(i, j, k)) continue;
					if (s[k/m][k%m]==1) { flag = false; break; }
				}
				if (flag && (msize < (j/m - i/m + 1) * (j%m - i%m + 1)))
					msize = (j/m - i/m + 1) * (j%m - i%m + 1);
			}
		System.out.println(msize);
		in.nextToken();
		n = (int) in.nval;

		in.nextToken();
		m = (int) in.nval;
	}
}

static boolean between(int i, int j, int k) { return (lessThan(i, k) && lessThan(k, j)); }
static boolean lessThan(int i, int j) { return ((i/m <= j/m) && (i%m <= j%m)); }
}