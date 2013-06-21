#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

typedef struct node_struct{
	long value;
	struct node_struct* prev;
	//struct node_struct* next;	
} node;

void swap(long *a, long* b){
	long temp;	
	if(*b>*a){
		temp=*a;*a=*b;*b=temp;
	}
}

long gcd_calculate(long a, long b){
	swap(&a,&b);
	while(a>0 && b>0){
		a%=b;
		swap(&a,&b);
		//printf("%ld %ld \n",a,b);
	}
	return a;
}

int main(int argc, char** argv){
	long i,r,g,gcd,max,temp;
	node* root=NULL,*ptr=NULL,*temp_ptr;
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

			temp_ptr = (node*) malloc(sizeof(node));
			temp_ptr->value = i;
			temp_ptr->prev = ptr;
			//temp_ptr->next = NULL;

			if(root==NULL){
				root = temp_ptr;
				ptr = temp_ptr;
			}else{
			//ptr->next = temp_ptr;
				ptr = temp_ptr;
			}
		}
	}
	//printf("Break at %ld\n",i);
	
	//if last==max, skip
	if(ptr->value==max) {
		temp_ptr = ptr;	
		ptr = ptr->prev;
		free(temp_ptr);
	}
	
	//loop: second half
	while(ptr!=NULL){
		temp = gcd/ptr->value; 
		printf("%ld %ld %ld\n",temp,r/temp,g/temp);
		temp_ptr = ptr;
		ptr = ptr->prev;
		free(temp_ptr);
	}

	return 0;
}
