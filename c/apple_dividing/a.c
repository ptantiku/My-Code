#include <stdio.h>
#include <ctype.h>
#include <math.h>

void swap(long *a, long* b){
	long temp;	
	if(*b>*a){
		temp=*a;*a=*b;*b=temp;
	}
}

long gcd_calculate(long a, long b){
	swap(&a,&b);
	while(a>0 && b>0){
		a-=b;
		swap(&a,&b);
		//printf("%ld %ld \n",a,b);
	}
	return a;
}

int main(int argc, char** argv){
	long i,r,g,gcd,max;
	char first;
	r = atol(argv[1]);
	g = atol(argv[2]);
	printf("r=%ld g=%ld\n",r,g);
	gcd = gcd_calculate(r,g);
	printf("gcd(r,g)=%ld\n",gcd);

	max = gcd/2; //use default divisor=2
	first = 0;
	for(i=1;i<=max;i++){
		if(gcd%i==0) {
			printf("%ld %ld %ld\n",i,r/i,g/i);
			if(i>1 && !first){ //change default divisor 
				max=gcd/i;
				first=i;
			}
		}
	}
	i=gcd;
	printf("%ld %ld %ld\n",i,r/i,g/i);

	return 0;
}
