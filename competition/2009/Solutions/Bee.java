import java.io.*;
import java.util.*;

/**
 * Bee
 * Solution by Paulo Oliva
 * Created on Sept 3, 2008
 */

public class Bee {
	
public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	in.nextToken();
	int n = (int) in.nval;

	while (n!=-1) {
	    long m = 0;
	    long f = 0;
	    for (int i=0;i<n;i++) {
		long mn = f + m + 1;
		long fn = m;
		m = mn;
		f = fn;
	    }
	    System.out.println("" + m + " " + (m+f+1));
	    in.nextToken();
	    n = (int) in.nval;
	}
}

}