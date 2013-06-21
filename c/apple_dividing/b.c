#include <stdio.h>
#include <ctype.h>

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
	long i,r,g,gcd,max,temp;
	char first;
	r = atol(argv[1]);
	g = atol(argv[2]);
	printf("r=%ld g=%ld\n",r,g);
	gcd = gcd_calculate(r,g);
	printf("gcd(r,g)=%ld\n",gcd);

	//loop: first half
	max = gcd; 
	for(i=1;i<max;i++){
		if(gcd%i==0) {
			printf("%ld %ld %ld\n",i,r/i,g/i);
			max = gcd/i;
			//if(i>max) break;
		}
	}
	//printf("Break at %ld\n",max);
	
	//loop: second half
	for(i=max-1;i>=1;i--){
		if(gcd%i==0) {
			temp = gcd/i;
			printf("%ld %ld %ld\n",temp,r/temp,g/temp);
		}
	}

	return 0;
}
