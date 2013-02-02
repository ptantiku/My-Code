import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.Collections;
import java.util.TreeMap;



public class FindTheMin extends Thread{

	private int a,b,c,r,k,n;
	public int output;
	private int case_no;
	private int[] results;


	public FindTheMin(int case_no,int a,int b,int c,int r,int k,int n,int[] results){
		this.case_no = case_no;
		this.a = a;
		this.b = b;
		this.c = c;
		this.r = r;
		this.k = k;
		this.n = n;
		this.results = results;
	}

	public void run(){
		LinkedList<Integer> k_list = generate_k();
		
		output = solve(k_list,n-k);

		//output
		System.out.printf("Thread Done, for Case #%d: %d\n",case_no,output);
		results[case_no-1] = output;
	}

	public LinkedList<Integer> generate_k(){
		LinkedList<Integer> k_list = new LinkedList<Integer>();
		long m = a;
		k_list.add((int)m);
		for(int i=1;i<k;i++){
			m = ((b*m + c) % r);
			k_list.add((int)m);
		}
		return k_list;
	}

	public int solve(LinkedList<Integer> k_list,int rounds){
		Integer times;

		TreeMap<Integer,Integer> map = new TreeMap<Integer,Integer>();
		for(int val : k_list){
			times = map.get(val);
			if(times == null)
				map.put(val,1);
			else
				map.put(val,times + 1);
		}

		int output=-1;
		int removed=-1;
		int index=0;
		for(int round=0;round<rounds;round++){
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
					if(map.containsKey(removed))
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

			//enumerating			
			while(map.containsKey(index)){
				index++;
			}
			output = index;
			
			//remove first element
			removed = k_list.pop();
			times = map.get(removed);
			if(times.intValue()==1)
				map.remove(removed);
			else
				map.put(removed,times-1);
			
			//add the new one
			k_list.add(output);
			times = map.get(output);
			if(times == null)
				map.put(output,1);
			else
				map.put(output,times + 1);

		}
		return output;
	}

	public static void main(String[] args) throws FileNotFoundException{
		String inputFileName = "sample.txt";
		if(args.length>=1)
			inputFileName = args[0];

		PrintWriter writer = new PrintWriter(new File("out.txt"));
		Scanner scanner = new Scanner(new File(inputFileName));
		int lines = scanner.nextInt();
		int[] results = new int[lines];
		FindTheMin[] problems = new FindTheMin[lines];
		for(int case_no=1;case_no<=lines;case_no++){
			int n = scanner.nextInt();
			int k = scanner.nextInt();
			int a = scanner.nextInt();
			int b = scanner.nextInt();
			int c = scanner.nextInt();
			int r = scanner.nextInt();
			System.out.printf("Case %d: %d/%d: a=%d b=%d c=%d r=%d\n",case_no,k,n,a,b,c,r);

			problems[case_no-1] = new FindTheMin(case_no,a,b,c,r,k,n,results);
			problems[case_no-1].start();
		}

		//waiting for results
		for(int case_no=1;case_no<=lines;case_no++){
			try {
				problems[case_no-1].join(4*60*1000);	//4 min time-out
    		} catch (InterruptedException ignore) {}
    	}
		
		//print results
		System.out.println("------------------------------");
		for(int case_no=1;case_no<=lines;case_no++){
			int output = results[case_no-1];
			System.out.printf("Case %d: %d\n",case_no,output);
			writer.printf("Case #%d: %d\n",case_no,output);
			writer.flush();
		}
		scanner.close();
		writer.close();
	}
}