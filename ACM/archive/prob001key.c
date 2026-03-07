/*
  The Proper Key
  CERC 1999, Petr Salinger
*/

#include <stdio.h>

#define MAX_RJ 128
#define MAX_CJ 128
#define MAX_RB 10000
#define MAX_CB 1024

#define FREE '.'

int rj,cj,rb,cb;

int depth;

struct{
int beg,len;
} key[MAX_RJ];

int allow;
int allow_m[MAX_CB];

typedef struct{int left,right;} LR;

LR work[MAX_RJ][MAX_CB]; 

int work_ptr;

LR * get_ptr(int i)
{
    return work[(work_ptr+i) % MAX_RJ];
}

void scankey()
{
   int i,j;
   char s[MAX_CJ];
   
   for ( i=0 ; i<rj ; i++)
   {
       gets(s);
       for(j = 0; s[j] == FREE; j++) {};
       key[i].beg=j;
       for(j = cj; s[--j] == FREE;) {};
       key[i].len=j+1-key[i].beg;
   }
}

void scanline_free()
{
   int i;
   LR *o;
   
   o=get_ptr(rj);
   work_ptr++;
   
   for(i=0;i<cb;i++,o++)
   {
       o->left  = i;
       o->right = cb-i;
   }
}


void scanline()
{
    char s[MAX_CB];
    int i,x,cnt;
    LR *o;
   
    gets(s);
    
    o=get_ptr(rj);
    work_ptr++;

    cnt=0;
   
    for( i = 0 ; i < cb;i++)
    {
       switch(s[i])
       {
           case FREE:    
               cnt++;
               break;
           default: 
               for(x=0;x<=cnt;x++)
               { 
                   o[i-cnt+x].left=x;
                   o[i-cnt+x].right=cnt-x;
               }
               cnt = 0;
       }
    }
    for(x=0;x<cnt;x++)
    { 
       o[i-cnt+x].left=x;
       o[i-cnt+x].right=cnt-x;
    }
}

void testline()
{
    int i,j,x;
    int rmin,lmin,ptr;
    LR *o;
    
    if(!allow) return;
    allow = 0;
    
    for(i=0;i<cb;i++)
    {
        if(!allow_m[i]) continue;
        
        rmin = lmin = MAX_CB; /* infinity */
        for(j=0;j<rj;j++)
        {
            o=get_ptr(j);
            ptr = i+key[j].beg;
            
            x=o[ptr].right-key[j].len; /* space at right */
            if (x < rmin) rmin = x; /* minimum*/
            
            x=o[ptr].left; /* space at left */
            if (x < lmin) lmin = x; /* minimum*/
        }
        if (rmin<0) 
        {
            allow_m[i]=0;
            continue;
        }
        for(j=i-lmin;j<i ;j++) allow_m[j]=1;
        /* !!! change of  i - control variable of upper for cycle !!! */
        while(rmin--) allow_m[++i]=1; 
        allow = 1;
    }    
    
    if (allow) depth++;
}
       

void init()
{
   int i;
   
   depth = 0;
   work_ptr = 0;

   for(i=0;i<rj;i++) scanline_free();
   
   for(i=0;i<=cb-cj;i++) allow_m[i]=1;
   for(   ;i<cb    ;i++) allow_m[i]=0;
   allow = 1; /* not necessary true (key might be wider then lock)  */
}


int fini()
{
    int i;
    
    for(i=0;i<rj;i++) 
    {
        scanline_free();
        testline();
        if (!allow) return depth;
    }
    return -1;
}

int main()
{
    int cnt,i;
    
    scanf("%d\n",&cnt);
    while(cnt--)
    {
        scanf("%d%d\n",&rj,&cj);
        scankey();
        scanf("%d%d\n",&rb,&cb);
        init();
        for( i=0; i< rb;i++)
        {
            scanline();
            testline();
        }
        i = fini();
        if (i < 0) 
             printf("The key can fall through.\n");
        else printf("The key falls to depth %d.\n",i);
    }
    return 0;
}

