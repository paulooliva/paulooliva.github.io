import java.io.*;
import java.util.*;

/**
 * Perfect
 * Solution taken from http://contest.mff.cuni.cz/archive/nzl1990b/index.html
 */

public class Perfect {

public static void main(String[] args) throws IOException {
	StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
	int[] delit = new int[100];
	int[] delmax = new int[100];
	int[] delpoc = new int[100];
	int delitelu,cislo,i,j,cislo2;
	long suma,l;
	int primes[]={2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,
		59,61,67,71,73,79,83,87,89,91,97,101,103,107,109,113,127,131,137,
		139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,
		229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,
		317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,
		421,431,433,439,443,449,457,461,463,467,479,487,491,
		499,503,509,521,523,541,547,557,563,569,571,577,587,
		593,599,601,607,613,617,619,631,641,643,647,653,659,
		661,673,677,683,691,701,709,719,727,733,739,743,751,
		757,761,769,773,783,787,797,809,811,821,823,827,829,
		839,853,857,859,863,877,881,883,887,907,911,919,929,
		937,941,947,953,967,971,977,983,991,997,1009};
	
	in.nextToken();
	cislo = (int) in.nval;

	while (cislo>0) { 
		cislo2=cislo;
		for (delitelu=0, i=2, j=1; cislo!=1; )
			if (cislo%i>0) i=primes[j++]; else {
				if ((delitelu==0)||(delit[delitelu-1]!=i)) {
					delit[delitelu]=i;
					delmax[delitelu]=i;
					delpoc[delitelu++]=1;
					cislo/=i;
				}
				else {
					delpoc[delitelu-1]++;
					delmax[delitelu-1]*=i;
					cislo/=i;
				}
			}
		suma=1;
		for (i=0; i<delitelu; i++) {
			l=delit[i];
			while ((delpoc[i]--)>0) l*=delit[i];
			l-=1;
			l/=(delit[i]-1);
			suma*=l;
		}
		suma-=cislo2;
		if (cislo2==suma) System.out.println(cislo2 + " " + suma + " perfect");
		if (cislo2<suma) System.out.println(cislo2 + " " + suma + " abundant");
		if (cislo2>suma) System.out.println(cislo2 + " " + suma + " deficient");

		in.nextToken();
		cislo = (int) in.nval;
	}
}
}
