import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.Collections;
import java.util.TreeMap;
import java.util.Arrays;
import java.util.ArrayList;
import java.math.BigInteger;

public class Card_Game{

	public static int possibilities(int k,int n){
		double out = 1.0;
		k = Math.min(k,n-k);
		for(int i=0;i<k;i++){
			out *= 1.0 * (n-i) / (1+i);
		}
		return (int) out;
	}

	public static int[] max_k(int[] a,int k){
		int[] t = new int[k];
		int min = t[0];
		for(int i:a){
			if (i>min){
				boolean changed = false;
				for(int j=0;j<k-1;j++){
					if(i<t[j+1]){
						t[j] = i;
						changed = true;
						break;
					}else{
						t[j] = t[j+1];
					}
				}
				if(! changed){
					t[k-1]=i;
				}
				min = t[0];
			}
		}

		return t;
	}

	public static int solve(int k,int n,int[] a){
		int total = possibilities(k,n);
		//System.out.printf("Total possibilities = %d\n",total);
	
		// pre-calculate for the loops
		ArrayList<Integer> sub_poss_list = new ArrayList<Integer>();
		int max_sub_numbers = n-1;
		while (total>0) {
			int sub_poss = possibilities(k-1,max_sub_numbers);
			sub_poss = Math.min(sub_poss, total);
			sub_poss_list.add(sub_poss);
			total -= sub_poss;
			max_sub_numbers--;
		}
		//System.out.println("Sub_poss_list size = "+sub_poss_list.size());
		
		// find maximum of "count_loops" values
		int[] t = max_k(a,sub_poss_list.size());
		//System.out.println(t);
		
		// final calculate
		int output = 0;
		for(int i=t.length-1;i>=0;i--){
			output += (t[i] * sub_poss_list.get(t.length-i-1)) % 1000000007;
		}
		return output;
	}

	public static void main(String[] args)throws FileNotFoundException{
		String inputFileName = "input.txt";
		if(args.length>=1)
			inputFileName = args[0];

		PrintWriter writer = new PrintWriter(new File("out.txt"));
		Scanner scanner = new Scanner(new File(inputFileName));
		int cases = scanner.nextInt();
		int[] results = new int[cases];
		int output =0;
		for(int case_no=1;case_no<=cases;case_no++){
			int n = scanner.nextInt();
			int k = scanner.nextInt();
			int[] a = new int[n];
			for(int i=0;i<n;i++){
				a[i] = scanner.nextInt();
			}
			System.out.printf("Case %d: %d/%d: a.size=%d\n",case_no,k,n,a.length);
			output = solve(k,n,a);
			System.out.printf("Case %d: %d\n",case_no,output);
			writer.printf("Case %d: %d\n",case_no,output);

		}
		scanner.close();
		writer.close();
	}
}