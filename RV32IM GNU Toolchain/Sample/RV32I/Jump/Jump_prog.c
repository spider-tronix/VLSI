int main(){
	int a = 5;
	int b=1;
	
	goto later;
	here:
	a = a + 100;

	later:
	b = b + 5;
	goto here;
	return 0;
}