import java.io.*;
import java.util.*;

/**
 * Carmichael Numbers
 * Solution by Paulo Oliva
 * Created on Dec 5, 2007
 */

public class Carmichael {
		
	public static void main(String[] args) throws IOException {
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

		String line = br.readLine();
		while (!line.equals("0")) {
			long n = Long.parseLong(line);
			long a;
			boolean prime = true;
			for (a=2;a<n;a++) {
				if (n % a == 0) prime = false;
				long ret = a;
				for (long i=1; i<n; i++) {
					ret = (ret * a) % n;
				}
				if (ret != a) break;
			}
			if (!prime && (a == n)) System.out.println("The number " + n + " is a Charmichael number.");
			else System.out.println(n + " is normal.");
			line = br.readLine();
		}
	}
}
