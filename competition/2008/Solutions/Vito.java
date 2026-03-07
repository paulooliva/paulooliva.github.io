import java.io.*;
import java.util.*;

/**
 * Vito's family
 * Solution by Paulo Oliva
 * Created on Dec 10, 2007
 */

public class Vito {
		
public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	int[] family = new int[30001];	

	in.nextToken();
	int N = (int) in.nval;

	for (int i=0;i<N;i++) {
		in.nextToken();
		int n = (int) in.nval;
		long totDist = 0;
		for (int j=0;j<30000;j++) family[j]=0;
		// read family position
		for (int j=0;j<n;j++) {
			in.nextToken();
			int k = (int) in.nval;
			family[k]++;
			totDist += k;
		}
		int pass = 0;
		long min = totDist;
		int temp = 0;
		// calculate the dist for each position < 30000
		for (int j=1;j<30000;j++) {
			totDist += 2 * pass - n;
			pass += family[j];
			if (min > totDist) min = totDist;
		}
		System.out.println(min);
	}
}

}