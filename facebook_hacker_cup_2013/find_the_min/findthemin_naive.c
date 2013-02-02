//This program using pure array in C

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TRUE 1
#define FALSE 0

void print_arr(long* arr,long size){
	long i;
	printf("[");
	for(i=0;i<size;i++){
		if(i<size-1)
			printf(" %ld,",arr[i]);
		else
			printf(" %ld",arr[i]);
	}
	printf("]\n");
}

long* generate_k(long a,long b,long c,long r,long k){
	long i;
	long m;
	long * k_arr;
	m=a;
	k_arr = (long *) malloc(k*sizeof(long));
	k_arr[0] = m;
	for(i=1;i<k;i++){
		k_arr[i] = m = (b*m+c)%r;
	}
	return k_arr;
}

char contains(long val, long* arr, long size){
	long i;
	for(i=0;i<size;i++){
		if(arr[i]==val)
			return TRUE;
	}
	return FALSE;
}

long solve(long* k_arr, long a,long b,long c,long r,long k, long n){
	long output=-1;
	long removed=-1;
	long index=0;
	long rounds = n-k;
	long round_index;
	long i;
	for(round_index=0;round_index<rounds;round_index++){

		if(output==-1){	//if first round
			index=0;
		}else{
			//not the first round, 
			//the list has been appended by "output"
			//and it has removed the value "removed" from the list
			if(removed<output){	
				//if the removed value is lower than the new one
				//we can start enumerating from the removed value,
				//unless, there are many of "removed" value left in the list
				if(contains(removed,k_arr,k)==TRUE)
					//if the list still has a duplicated removed value,
					// starts from the last appended value (output)
					index=output+1;
				else
					//start from the lower one, which is the removed value
					index=removed;
			}else{
				//if removed value >= output, the removed value does not matter now.
				//start the enumeration from the last appended value(output)
				index=output+1;
			}
		}

		while(contains(index,k_arr,k)==TRUE){
			index++;
		}
		output = index;

		//shift one
		removed = k_arr[0];
		for(i=0;i<k-1;i++){
			k_arr[i]=k_arr[i+1];
		}
		k_arr[k-1] = output;
	}

	return output;
}

int main(int argc, char** argv){
	int cases, case_no;
	long a, b, c, r, k, n;
	long* k_arr;
	long output;
	float start_time, end_time;
	char* filename = "sample.txt";
	if(argc>=2){
		filename = argv[1];
	}

	FILE* infile = fopen(filename,"r");
	FILE* outfile = fopen("out.txt","w");
	fscanf(infile,"%d",&cases);
	for(case_no=1;case_no<=cases;case_no++){
		//input
		fscanf(infile,"%ld %ld",&n,&k);
		fscanf(infile,"%ld %ld %ld %ld",&a,&b,&c,&r);
		printf("Case #%d: %ld/%ld: %ld %ld %ld %ld\n",case_no,k,n,a,b,c,r);
		start_time = (float) clock()/CLOCKS_PER_SEC;

		//generate first k-values
		k_arr = generate_k(a,b,c,r,k);
		//print_arr(k_arr,k);

		//execution
		output = solve(k_arr, a, b, c, r, k, n);

		//post-execution
		free(k_arr);
		end_time = (float) clock()/CLOCKS_PER_SEC;
		printf("Case #%d: Output: %ld\n",case_no,output);
		fprintf(outfile,"Case #%d: %ld\n",case_no,output);
		printf("Time %f sec\n",end_time-start_time);
	}
	fclose(infile);
	fclose(outfile);

	return 0;
}