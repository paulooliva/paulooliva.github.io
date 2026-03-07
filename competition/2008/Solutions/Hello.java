import java.io.*;
import java.util.*;

/**
 * Simply Subsets
 * Solution by Paulo Oliva
 * Created on Jan 28, 2008
 */

public class Hello {

public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	in.nextToken();

	int n = (int) in.nval;

	for (int i=0;i<n;i++) {
		in.nextToken();
		System.out.println("Hello " + in.sval);
	}
}

}