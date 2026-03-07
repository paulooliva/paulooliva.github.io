/**
 * RareOrder 
 * http://acm.uva.es/p/v2/200.html
 * @author Paulo Oliva
 * Created on Jul 8, 2005
 */

import java.io.*;

public class RareOrder {
	static private int[][] graph;
	static private int[] nodes;

    public static void main ( String [] argv ) throws IOException {        
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new FileReader("RareOrder.in")));        
        in.wordChars('#', '#');        

        // initialize graph
        graph = new int[30][30];
        nodes = new int[30];
        
        // read input
        in.nextToken();
        String str1 = in.sval;
        in.nextToken();
        String str2 = in.sval;
        while (!str2.equals("#")) {
        		process(str1, str2);
        		str1 = str2;
        		in.nextToken();
        		str2 = in.sval;
        }
        System.out.println(sorting());
    }
    
    private static String sorting () {
    		String str = "";
    		int found = 1;
    		while (found == 1) {
    			int i=0;
    			found = 0;
    			for(;i<30;i++) {
    				if (nodes[i]==1 && outDegree(i)==0) {
    					str = Character.toString((char)('A' + i)) + str;
    					nodes[i] = 0;
    					found = 1;
    				}
    			}
    		}
    		
    		return str;
    }
    
    private static int outDegree (int i) {
    		int count = 0;
    		for (int j=0;j<30;j++) if (nodes[j]==1 && graph[i][j]==1) count++;
    		return count;
    }
        
    private static void process(String str1, String str2) {
    		int i;
    		for (i=0;i<str1.length();i++) {
    			if (i==str2.length()) break;
    			if (str1.charAt(i)!=str2.charAt(i)) break;
    		}
    		// if two diff chars found, add an edge to the DAG
    		if (i!=str2.length() && i<str1.length()) 
    			addEdge(str1.charAt(i) - 'A', str2.charAt(i) - 'A');
    }
    
    private static void addEdge(int f, int t) {
    		graph[f][t] = 1;
    		nodes[f] = 1;
    		nodes[t] = 1;
    	}
    
}
