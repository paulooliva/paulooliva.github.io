
 /**
 * Problem: Trees on the Level
 * http://acm.uva.es/p/v1/122.html
 * Solution by Paulo Oliva
 * 22 June 2005
 */

import java.io.*;
import java.util.*;

public class TreeOnLevel {
	static Vector tree;
    
    public static void main ( String args [] ) throws Exception {
        FileReader in = new FileReader ("TreeOnLevel.in");
        StreamTokenizer st = new StreamTokenizer (in);
        
        while ( true ){
        		tree = new Vector();;
        		if (!constructTree(st)) break;
        		printTree();
        }
    }
    
    private static boolean constructTree ( StreamTokenizer st ) throws Exception {
		int next = st.nextToken();	   // left bracket or end of file
		if (next != '(') return false; // end of file
		
		next = st.nextToken();		// right bracket or number
		
		while (next == StreamTokenizer.TT_NUMBER){
			int num = (int) st.nval;
			String str = "";

			next = st.nextToken();	// comma
			next = st.nextToken();	// TT_WORD or right bracket
			if (next == StreamTokenizer.TT_WORD) {
				str = st.sval;
				next = st.nextToken();	// right bracket
			}
			
			tree.add(new Node(num, str));
			next = st.nextToken();	// left bracket
			next = st.nextToken();  // right bracket or number
		}
		return true;
	}
	
	private static void printTree() {
		String buff = "";
		Object[] nodes = tree.toArray();
		java.util.Arrays.sort(nodes, new Node());
		if (complete(nodes) && nodes.length!=0) {
			for (int i=0;i<nodes.length;i++) buff = buff + ((Node) nodes[i]).val + " ";
			System.out.println(buff);
		}
		else
			System.out.println("not complete");
	}

	private static boolean complete(Object[] nodes) {
		for (int i=1;i<nodes.length;i++) {
			String s = ((Node) nodes[i]).position;
			int k = 0;
			for (int j=0;j<i;j++) {
				String ps = ((Node) nodes[j]).position;
				String ss = s.substring(0,k);
				if (ps.compareTo(ss) == 0) k++;
			}
			if (k!=s.length()) return false;
		}
		return true;
	}
	
    private static class Node implements Comparator { 
        public int val;
		public String position;
		
		Node () {}
		
		Node (int v, String p) {
			val = v;
			position = p;
		}
		
		public int compare(java.lang.Object a, java.lang.Object b) {
			Node na = (Node) a;
			Node nb = (Node) b;
			if (na.position.length() == nb.position.length())
				return na.position.compareTo(nb.position);
			else
				return (na.position.length() - nb.position.length());
		}
    }
}
