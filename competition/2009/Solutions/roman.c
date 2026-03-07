/**
 * Roman Digititis
 * Solution taken from http://contest.mff.cuni.cz/archive/ncam1995/index.html
 */

#include <stdio.h>

int ni, nv, nx, nl, nc;

void units(int n) {
    switch(n) {
		case 0: break;
		case 1: ni += 1; break;
		case 2: ni += 2; break;
		case 3: ni += 3; break;
		case 4: ni += 1; nv += 1; break;
		case 5: nv += 1; break;
		case 6: ni += 1; nv += 1; break;
		case 7: ni += 2; nv += 1; break;
		case 8: ni += 3; nv += 1; break;
		case 9: ni += 1; nx += 1; break;
		default: break;
	}
}

void tens(int n) {
    switch(n) {
		case 0: break;
		case 1: nx += 1; break;
		case 2: nx += 2; break;
		case 3: nx += 3; break;
		case 4: nx += 1; nl += 1; break;
		case 5: nl += 1; break;
		case 6: nx += 1; nl += 1; break;
		case 7: nx += 2; nl += 1; break;
		case 8: nx += 3; nl += 1; break;
		case 9: nx += 1; nc += 1; break;
		case 10: nc += 1; break;
		default: break;
    }
}

int main(void) {
    int i, n;

    while(1) {
		scanf("%d",&n);
		if (n == 0) return 1;
		ni = nv = nx = nl = nc = 0;
		for (i=1;i<=n;i++) {
			units(i % 10);
			tens(i / 10);
		}
		printf("%d: %d i, %d v, %d x, %d l, %d c\n", n, ni, nv, nx, nl, nc);
    }
	return 0;
}