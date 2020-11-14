#include <iostream>
#include <ctime>
#include "thread"
#include "pthread.h"
#include "string"

using namespace std;
struct Package{
    double* array;
    int threadNum;
    double sum;
};
double *A;//массив чисел
const uint32_t arrSize = rand()+1000;//размер массива
int counter = 0;//счётчик индекса элемента в массиве
int I = -1;
int J = 0;
int threadNumber = 4;//число потоков(4 по умолчанию, указывается в параметрах)
void *func(void *param){
    Package* p =  (Package*)param;
    p->sum = 0.0;
    //сравниваются два соседних числа
    if(p->array[counter+p->threadNum -1] < p->array[counter+p->threadNum]){
        p->sum++;
    }
    else{
        p->sum = 0;
    }
    return nullptr;
}
int main(int argc, char** argv){
    threadNumber = stoi(string(argv[1]));//устанавливаем число потоков
    double rez = 0.0;
    A = new double[arrSize];
    if(A == nullptr){
        cout << "Incorrect size"<<"\n";
        return 1;
    }

    for(int i = 0; i < arrSize; i++){
        A[i] = rand();
        cout << A[i] <<" ";
    }
    cout <<"\n";
    //выполнение потоков и получение результата
    pthread_t thread[threadNumber];
    Package pack[threadNumber];
    int max = 0;
    clock_t start_time = clock();
    for(int i = 0; i < arrSize/threadNumber+1; i++) {
        for(int i = 0; i < threadNumber; i++){
            pack[i].array = A;
            pack[i].threadNum = i;
            pthread_create(&thread[i], nullptr, func, (void*)&pack[i]);
        }
        for (int i = 0; i < threadNumber; i++) {
            pthread_join(thread[i], nullptr);
            if(pack[i].sum != 0) {
                rez += pack[i].sum;
            }
            else{
                if(rez > max){
                    max = rez;
                    I = counter-threadNumber+1;
                }

                rez = 1;
            }
        }
        counter += threadNumber;
    }
    J = I+max-1;
    clock_t end_time = clock();
    cout <<"Result:"<< max<<endl;
    cout << "I:"<<I<<" "<<"J:"<<J<<endl;
    cout<<"Time:"<<end_time - start_time;
}
