#include <functional>
#include <iostream>
#include "string"
#include <omp.h>
#include "fstream"
#include "vector"
#include <stdlib.h>
#include <stdio.h>

using namespace std;
int maxLen = 1;
int N = 1;
int J;
//метод сравнения двух соседних элементов
void compareNearElements(int a, int b, int j){
    if(a < b){
        N++;
    } else{
        if(N > maxLen){
            maxLen = N;
            J = j-1;
        }
        N = 1;
    }

}

int main(int argc, char** argv) {
    //ввод размерности массива
    int arrSize = stoi(string(argv[1]));
    if (arrSize <= 0) {
        cout << "Wrong array size: " << arrSize;
        return 0;
    }
    int threadQuantity = stoi(string(argv[2]));
    if (threadQuantity <= 0 || threadQuantity >= arrSize-2) {
        cout << "Wrong threead quantity: " << threadQuantity;
        return 0;
    }
    //элементы массива будут выводиться в файл
    ofstream out{string(argv[3])};
    vector<int> A;
    //Для простоты проверки элементы массива от 0 до 9
    for (int i = 0; i < arrSize; i++) {
        A.push_back(rand() % 10);
        out << i <<")"<< A[i] <<" \n";
    }
    int i;
#pragma omp shared(J, A, maxLen, N, arrSize) private(i)
    {
#pragma omp parallel for num_threads(threadQuantity) default(shared)
        //вывод в файл
        for (i = 1; i < arrSize; ++i) {
            out << "(" << A[i-1] << "," << A[i] <<") - thread(" << omp_get_thread_num() << ")\n";
            compareNearElements(A[i-1], A[i], i);
        }

#pragma omp barrier
        {
            //вывод итоговой информации в файл
            out << "Max Length: " << maxLen << "\n";
            out << "Start index: " << J - maxLen + 1 << ", end index: " << J<<"\n";

        }
    }
    return 0;
}