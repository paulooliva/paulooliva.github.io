import java.io.*;
import java.util.*;

/**
 * Matrix Matcher
 * Solution by Paulo Oliva
 * Created on Jan 29, 2009
 */

public class Matrix {
	
public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	in.nextToken();
	int n = (int) in.nval;

	for (int c=0; c<n; c++) {
		// read matrix
		in.nextToken();
		int x = (int) in.nval;
		in.nextToken();
		int y = (int) in.nval;
		
		String[] s = new String[1000];
		
		for (int i=0; i<x; i++) {
			in.nextToken();
			s[i] = (String) in.sval;
		}

		// read pattern
		in.nextToken();
		int a = (int) in.nval;
		in.nextToken();
		int b = (int) in.nval;
		
		String[] p = new String[1000];
		
		for (int i=0; i<a; i++) {
			in.nextToken();
			p[i] = (String) in.sval;
		}
		
		// find occurrences of pattern on matrix
		int count = 0;
		for (int i=0; i<=x-a; i++)
			for (int j=0; j<=y-b; j++) {
				boolean match = true;
				for (int u=0; u<a; u++) {
					for (int v=0; v<b; v++)
						if (s[i+u].charAt(j+v)!=p[u].charAt(v)) { match = false; break; }
					if (!match) break;
				}
				if (match) count++;
			}
		
	    System.out.println(count);
	}
}

}