import java.io.*;
import java.util.*;

/**
 * Simply Subsets
 * Solution by Paulo Oliva
 * Created on Jan 28, 2008
 */

public class Sorting {

static boolean[] v;

public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	in.nextToken();
	int n = (int) in.nval;

	v = new boolean[5001];

	while (n!=0) {
		for (int i=0;i<5001;i++) v[i] = false;
		for (int i=0;i<n;i++) { in.nextToken(); v[(int) in.nval] = true; }
		String s = "";
		for (int i=0;i<5001;i++) if (v[i]) s = s + i + " ";
		System.out.println(s);
		in.nextToken();
		n = (int) in.nval;
	}
}

}