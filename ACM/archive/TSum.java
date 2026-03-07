/* 
 * Problem: Tree Summing
 * http://acm.uva.es/p/v1/112.html
 * Solution by Keldon Alleyne
 * 11 June 2005
 */

import java.io.*;

public class TSum {
    public static void main ( String argv [] ) throws IOException {
        FileReader in = new FileReader ("TSum.in");
        StreamTokenizer st = new StreamTokenizer (in);
        
        int ttype = st.nextToken();
        while ( ttype != StreamTokenizer.TT_EOF ){
            int i = (int)st.nval;
            Tree t = constructTree (st);
            
            System.out.println (sums ( i, t));
            
            ttype = st.nextToken();
        }
    }
    
    public static String sums ( int sval, Tree t ){
        if ( t == null ) return "no";
        
        int total = t.val;
        int i = sums ( sval, t, t.val);
        
        if ( sval == i ) return "yes";
        else return "no";
    }
    
    public static int sums ( int sval, Tree t, int total ){
        if ( t.left != null ) {
            int i = sums ( sval, t.left, total+t.left.val);
            if ( i == sval ) return i;
        }
        
        if ( t.right != null ) {
            int i = sums ( sval, t.right, total+t.right.val);
            if ( i == sval ) return i;
        }
        
        if ( t.right == null & t.left == null ) return total;
        
        return -1;
    }
    
    public static Tree constructTree ( StreamTokenizer st ) throws IOException { 
        int ttype;
        Tree tree;
        ttype = st.nextToken(); // left bracket
        ttype = st.nextToken(); // number or left bracket
        if ( ttype == StreamTokenizer.TT_NUMBER ) {
            tree = new Tree ( (int)st.nval);
            tree.left = constructTree ( st );
            tree.right = constructTree ( st );
            ttype = st.nextToken (); // right bracket
        } else {
            tree = null;
        }
        
        return tree;
    }
    
    private static class Tree {
        public Tree left, right;
        public int val;
        
        public Tree (int i) {
            init ();
            val = i;
        }
        
        public Tree (){
            init();
        }
        
        private void init () {
            left = null;
            right = null;
            val = -1;
        }
        
    }
}
