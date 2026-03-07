import java.io.*;
import java.util.*;

/**
 * Self-describing Sequence
 * Solution by Paulo Oliva
 * Created on Dec 14, 2007
 */

public class Sequence {
	
public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	int[] f = new int[10000002];

	f[1]=1;
	for (int i=2;i<=10000001;i++) f[i] = 1 + f[i - f[f[i-1]]];

	in.nextToken();
	int n = (int) in.nval;

	while (n!=0) {
		System.out.println("" + f[n]);
		in.nextToken();
		n = (int) in.nval;
	}
}
}