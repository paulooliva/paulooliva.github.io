/**
* Problem: Minesweeper
* http://acm.uva.es/p/v101/10189.html
* Solution by Mohsen Azarbadegan
* 30 June 2005
*/ 

import java.io.*;
import java.util.*;

public class minesweeper
{
    static FileReader inFile;
    static BufferedReader in;
    static int fieldNumber=0,xDim,yDim;
    static int[][] array;
    
    public static void main(String[] param) throws IOException
    {
        inFile = new FileReader("minesweeper.in");
        in = new BufferedReader(inFile);
        while(makeArray())
        {
            proccess();
            System.out.println(printArray());
        }
            
    }   
    
    private static boolean makeArray() throws IOException
    {
        StringTokenizer st = new StringTokenizer(in.readLine());
        xDim= Integer.parseInt(st.nextToken());
        yDim =Integer.parseInt(st.nextToken());
        if(xDim == 0 || yDim == 0)
            return false;
        fieldNumber++;
        array = new int[xDim][yDim];
        return true;
    }
    
    private static void proccess() throws IOException
    {
        for(int i=0; i< xDim; i++)
        {
            String line = in.readLine();
            for(int j=0; j< yDim; j++)
            {
                if(line.charAt(j) == '*')
                    mine(i,j);
            }
        }
    }
    
    private static void mine(int x, int y)// add one to squares around the given mine
    {
        array[x][y] = -1;
        for(int i = -1; i < 2; i++)
        {
            for(int j = -1; j <2; j++)
            {
                if( x+i> -1 && x+i<xDim && y+j> -1 && y+j < yDim)
                {
                      if(array[x+i][y+j] != -1)
                      array[x+i][y+j]++;
                }
               
            }
        }
       
    }
    
    private static String printArray()
    {
        String returnVal="Field #" + fieldNumber + ":\n";
        for(int i=0; i <xDim; i++)
        {
            for(int j=0; j< yDim; j++)
            {
                if(array[i][j] == -1)
                    returnVal+= "*";
                else
                    returnVal+= array[i][j];
            }
            returnVal+= '\n';
        }
        return returnVal;
    }
}