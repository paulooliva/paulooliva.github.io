import java.io.*;
import java.util.*;

/**
 * Reverse and Add
 * Solution by Paulo Oliva
 * Created on Dec 5, 2007
 */

public class Reverse {
		
	public static void main(String[] args) throws IOException {
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

		String line = br.readLine();
		int N = Integer.parseInt(line);
		for (int i=0;i<N;i++) {
			line = br.readLine();
			long n = Long.parseLong(line);
			int count=0;
			while (!palindrome(n)) { n = n + rev(n); count++; }
			System.out.println(count + " " + n);
		}
	}

	public static long rev(long n) {
		long ret = 0;
		while (n>0) {
			ret = (ret * 10) + (n % 10);
			n = n / 10;
		}
		return ret;
	}

	public static boolean palindrome (long n) {
		String ns = "" + n;
		int len = ns.length();
		for (int i=0;i<len/2;i++)
			if (ns.charAt(i)!=ns.charAt(len-1-i)) return false;
		return true;
	}
}
