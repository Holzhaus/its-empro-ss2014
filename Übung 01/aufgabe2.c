int randomValue(int x)
{
	int a=57, b=113, m=256;
	x = (a * x + b) % m;
	return x;
}

int main()
{
	int x = 165;
	int i;
	for(i=0; i < 5; i++)
	{
		x = randomValue(x);
	}
}
