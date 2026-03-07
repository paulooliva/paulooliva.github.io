import java.io.*;
import java.util.*;

/**
 * Can You Count?
 * Solution by Paulo Oliva
 * Created on Jan 29, 2009
 */

public class Count {
	
public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));

	in.nextToken();
	int n = (int) in.nval;

	for (int i=0; i<n; i++) {
		in.nextToken();
		String p = (String) in.sval;
		in.nextToken();
		String s = (String) in.sval;

		int count = 0;
		for (int j=0; j<s.length(); j++) if (s.charAt(j)==p.charAt(0)) count++;
		
	    System.out.println(count);
	}
}

}