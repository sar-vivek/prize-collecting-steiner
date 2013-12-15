/*
 * Author:          101C
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main(){
    float t, a, k;
    int i;
    t = 100;
    a = 0.8;
    for (i = 1; i < 50; i++){
	t = (a*(i*1.0)/50)*t;
	printf("%d %f\n", i, t);
    }
    return 0;
}
