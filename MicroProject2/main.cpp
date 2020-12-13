#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <vector>
#include<ctime>
#include "string"
#include <Windows.h>

using namespace std;

const int REFERRAL_DOCTORS = 2; //количество врачей

int write = 0; //индекс для записи в буфер
pthread_cond_t isFull;
pthread_cond_t freePlace;
pthread_mutex_t docMutex;
pthread_mutex_t dentistMutex; //мутекс для дантиста
pthread_mutex_t surgeryMutex; //мутекс для хирурга
pthread_mutex_t therapistMutex; //мутекс для терапевт
vector<pthread_t> threadC; //потоки к врачам
vector<pthread_t> threadQ; //потоки к специалистам
int start_time;
//класс, описывающий посетителя больницы
class Customer
{
public:
    Customer(){};
    Customer(int _id, pthread_t _thread){
        id = _id;
        thread = _thread;
    }
    int getId(){
        return id;
    }
    pthread_t getThread(){
        return thread;
    }
private:
    int id;
    pthread_t thread;
};

//метод посещения стоматолога
void* at_dentist(void* param)
{
    pthread_mutex_lock(&dentistMutex);
    Customer* patient = (Customer*)param;
    int stop_time = clock();
    printf("Time: %d Patient %d: was at dentist\n", stop_time - start_time, patient->getId());
    pthread_mutex_unlock(&dentistMutex);
}
//метод посещения терапевта
void* at_therapist(void* param)
{
    pthread_mutex_lock(&therapistMutex);
    Customer* patient = (Customer*)param;
    int stop_time = clock();
    printf("Time: %d Patient %d: was at therapist\n", stop_time - start_time, patient->getId());
    pthread_mutex_unlock(&therapistMutex);
}
//метод посещения хирурга
void* at_surgery(void* param)
{
    pthread_mutex_lock(&surgeryMutex);
    Customer* patient = (Customer*)param;
    int stop_time = clock();
    printf("Time: %d Patient %d: was at surgery\n", stop_time - start_time, patient->getId());
    pthread_mutex_unlock(&surgeryMutex);
}
//метод получения направления
void* get_referral(void* param) {
    Customer* patient = (Customer*)param;
    pthread_cond_wait(&freePlace, &docMutex);
    srand(GetCurrentThreadId());
    int doc_index = rand() % 3;; //случайным образом выбираем доктора
    write = (write + 1) % REFERRAL_DOCTORS; //индекс принимающего врача
    int stop_time = clock();
    pthread_cond_signal(&isFull);
    if(doc_index == 0){
        printf("Time: %d Patient %d: was referred to dentist by doctor %d\n", stop_time - start_time, patient->getId(),write+1);
    }
    else if(doc_index == 1){
        printf("Time: %d Patient %d: was referred to therapist by doctor %d\n", stop_time - start_time, patient->getId(),write+1);
    }
    else{
        printf("Time: %d Patient %d: was referred to surgery by doctor %d\n", stop_time - start_time, patient->getId(),write+1);
    }
    //направляем пациентов к докторам
     if(doc_index == 0){
         pthread_create(&threadQ[patient->getId() - 1], nullptr, at_dentist, (void*)(patient));
     }
     else if(doc_index == 1){
         pthread_create(&threadQ[patient->getId() - 1], nullptr, at_therapist, (void*)(patient));
     }
     else{
         pthread_create(&threadQ[patient->getId() - 1], nullptr, at_surgery, (void*)(patient));
     }

    pthread_cond_wait(&isFull, &docMutex);
    pthread_cond_signal(&freePlace);
}


int main(int argc, char** argv)
{
    srand((unsigned)time(0));
    if(stoi(string(argv[1])) <= 0){
        cout <<"Incorrect number of customers";
        return 0;
    }
    int n = stoi(string(argv[1]));
    vector<Customer> patients(n);
    cout << "The hospital will have " << n << " customers\n";
    pthread_mutex_init(&dentistMutex, nullptr); //инициализация мьютекса дантиста
    pthread_mutex_init(&therapistMutex, nullptr);//инициализация мьютекса терапевта
    pthread_mutex_init(&surgeryMutex, nullptr);//инициализация мьютекса хирурга
    pthread_mutex_init(&docMutex, nullptr);//инициализация мьютекса направляющего врача
    threadC= vector<pthread_t>(n);
    threadQ = vector<pthread_t>(n);

    start_time = clock();
    for (int i = 0; i < n; i++)
    {
        patients[i] = Customer(i+1, threadC[i]);
        unsigned int stop_time = clock();
        printf("Time: %d Patient %d entered\n",stop_time-start_time, i+1);
        pthread_create(&threadC[i], nullptr, get_referral, (void*)(&patients[i]));
    }
    //ожидание завершения всех потоков
    for (int i = 0; i < n; i++)
    {
        pthread_join(threadC[i], NULL);
        pthread_join(threadQ[i], NULL);
    }
    return 0;
}