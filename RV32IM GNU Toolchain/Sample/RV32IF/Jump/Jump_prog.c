int main(){
	float a = 5;
	float b=1;
	
	goto later;
	here:
	a = a + 100;

	later:
	b = b + 5;
	goto here;
	return 0;
}