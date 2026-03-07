import java.io.*;
import java.util.*;

/**
 * Where is Waldorf?
 * Solution by Paulo Oliva
 * Created on Dec 6, 2007
 */

public class Waldorf {
		
	static char[][] puzzle = new char[50][50];
	static int l, c;
	
	public static void main(String[] args) throws IOException {
		StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

		in.nextToken();
		int n = (int) in.nval;

		for (int i=0;i<n;i++) {
			// read puzzle
			in.nextToken();
			l = (int) in.nval;
			in.nextToken();
			c = (int) in.nval;
			for (int j=0;j<l;j++) {
				in.nextToken();
				copy(puzzle[j], in.sval.toLowerCase());
			}
			// read words
			in.nextToken();
			int nw = (int) in.nval;
			for (int v=0;v<nw;v++) {
				in.nextToken();
				String words = (String) in.sval;
				int len = words.length();
				char[] word = new char[20];
				copy(word, words.toLowerCase());
				for (int j=0;j<l;j++)
					for (int k=0;k<c;k++)
						for (int d=0;d<8;d++)
							if (found(word, 0, len, j, k, d))
								System.out.println((j+1) + " " + (k+1));
			}
		}
	}

	static void copy(char[] a, String s) {
		for (int i=0;i<s.length();i++) a[i] = s.charAt(i);
	}

	static boolean found(char[] word, int cur, int len, int j, int k, int dir) {
		int jn = j;
		int kn = k;
		if (cur == len) return true;
		if (j<0 || j>l) return false;
		if (k<0 || k>c) return false;
		if (word[cur] != puzzle[j][k]) return false;
		switch (dir) {
			case 0 : jn = j-1; break;
			case 1 : jn = j-1; kn = k+1; break;
			case 2 : kn = k+1; break;
			case 3 : kn = k+1; jn = j+1; break;
			case 4 : jn = j+1; break;
			case 5 : jn = j+1; kn = k-1; break;
			case 6 : kn = k-1; break;
			default : jn = j-1; kn = k-1; break;
		}
		return found(word, cur+1, len, jn, kn, dir);
	}
}
