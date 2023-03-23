#include <iostream>
#include <pthread.h>
#include <vector>
#include<unistd.h>


struct daxpyArgs {
    int index;
    int N;
    int size;
    int* a;
    int* b;
    int* c;
};


void* daxpy(void* arguments)	{
    struct daxpyArgs* args = (struct daxpyArgs *) arguments;
    int size = args->size;
    int i= args->index;
    int N= args->N;
    int* av = args->a;
    int* bv = args->b;
    int* cv = args->c;

    for (int j=i; j<size; j=j+N ){
        cv[j] = av[j] + bv[j];
    }
    return NULL;
}


int main() {
	int N = 2; // number of threads
	int size = 10; // number of threads
	int a[size];
	int b[size];
	int c[size];

	for (int i = 0; i < size; i++){
		a[i] = i+2;
		b[i] = i*2;
		c[i] = 0;
	}

    struct daxpyArgs args;
    args.size = size;
    args.N = N;
    args.a = &a[0];
    args.b = &b[0];
    args.c = &c[0];

	pthread_t threads[N];
    for(int i=0; i<N; i++){
        args.index = i;
        if (pthread_create(&threads[i], NULL, &daxpy, (void *) &args) != 0){
            return 1;
        }
        sleep(0.5);
    }
    for(int k=0; k<N; k++){
        if(pthread_join(threads[k], NULL) != 0) {
            return 2;
        }
    }
	for (int i=0; i<size; ++i)
    		std::cout << a[i] << ' ';

	std::cout << "\n+:" << "\n";

	for (int i=0; i<size; ++i)
    		std::cout << b[i] << ' ';

	std::cout << "\n\n Resultado:" << "\n";
	for (int i=0; i<size; ++i)
    		std::cout << c[i] << ' ';


    return 0;
}
