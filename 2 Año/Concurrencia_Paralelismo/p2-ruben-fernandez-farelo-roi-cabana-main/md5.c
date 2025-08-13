#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <openssl/evp.h>
#include <pthread.h>

#include "options.h"
#include "queue.h"


#define MAX_PATH 1024
#define BLOCK_SIZE (10*1024*1024)
#define MAX_LINE_LENGTH (MAX_PATH * 2)

typedef struct process_files_data {
    queue in_q;
    queue out_q;
} process_files_data;

typedef struct get_entries_data {
    char *dir;
    queue q;
} get_entries_data;


struct file_md5 {
    char *file;
    char *dir;
    queue q;
    unsigned char *hash;
    unsigned int hash_size;
};

typedef struct wrt_md5_args{
    queue out_q;
    FILE *out;
    int dirname_len;
}wrt_md5_args;



void get_entries(void * data);

//.
void print_hash(struct file_md5 *md5) {
    for(int i = 0; i < md5->hash_size; i++) {
        printf("%02hhx", md5->hash[i]);
    }
}

//
typedef struct read_thread_args {
    queue q;
    char*dir;
    char*file;
} read_thread_args;

void *read_hash_file(void *args) {
    read_thread_args *thread_args = (read_thread_args *) args;
    char *file = thread_args->file;
    char *dir = thread_args->dir;
    queue q = thread_args->q;

    FILE *fp;
    char line[MAX_LINE_LENGTH];
    char *file_name, *hash;
    int hash_len;

    if((fp = fopen(file, "r")) == NULL) {
        printf("Could not open %s : %s\n", file, strerror(errno));
        exit(0);
    }

    while(fgets(line, MAX_LINE_LENGTH, fp) != NULL) {
        char *field_break;
        struct file_md5 *md5 = malloc(sizeof(struct file_md5));

        if((field_break = strstr(line, ": ")) == NULL) {
            printf("Malformed md5 file\n");
            exit(0);
        }
        *field_break = '\0';

        file_name = line;
        hash      = field_break + 2;
        hash_len  = strlen(hash);

        md5->file      = malloc(strlen(file_name) + strlen(dir) + 2);
        sprintf(md5->file, "%s/%s", dir, file_name);
        md5->hash      = malloc(hash_len / 2);
        md5->hash_size = hash_len / 2;


        for(int i = 0; i < hash_len; i+=2)
            sscanf(hash + i, "%02hhx", &md5->hash[i / 2]);

        q_insert(q, md5);
    }
    q_end(q);
    fclose(fp);

    return NULL;
}
void sum_file(struct file_md5 *md5) {

    EVP_MD_CTX *mdctx;
    int nbytes;
    FILE *fp;
    char *buf;

    if((fp = fopen(md5->file, "r")) == NULL) {
        printf("Could not open %s\n", md5->file);

    }

    buf = malloc(BLOCK_SIZE);
    const EVP_MD *md = EVP_get_digestbyname("md5");

    mdctx = EVP_MD_CTX_create();
    EVP_DigestInit_ex(mdctx, md, NULL);

    while((nbytes = fread(buf, 1, BLOCK_SIZE, fp)) >0)
        EVP_DigestUpdate(mdctx, buf, nbytes);

    md5->hash = malloc(EVP_MAX_MD_SIZE);
    EVP_DigestFinal_ex(mdctx, md5->hash, &md5->hash_size);

    EVP_MD_CTX_destroy(mdctx);
    free(buf);
    fclose(fp);
}




void add_files(char *entry, void *arg) {

    queue q = * (queue *) arg;
    struct stat st;

    stat(entry, &st);

    if(S_ISREG(st.st_mode))
        q_insert(q, strdup(entry));

}


void walk_dir(char *dir, void (*action)(char *entry, void *arg), void *arg) {
    DIR *d;
    struct dirent *ent;
    char full_path[MAX_PATH];

    if((d = opendir(dir)) == NULL) {
        printf("Could not open dir %s\n", dir);
        return;
    }

    while((ent = readdir(d)) != NULL) {
        if(strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") ==0)
            continue;

        snprintf(full_path, MAX_PATH, "%s/%s", dir, ent->d_name);

        action(full_path, arg);
    }

    closedir(d);
}


void recurse(char *entry, void *arg) {
    queue q = * (queue *) arg;
    struct stat st;

    stat(entry, &st);

    if(S_ISDIR(st.st_mode)){
        get_entries_data data;
        data.dir=entry;
        data.q=q;
        get_entries(&data);
    }
}

void check_md5_files(void * args){

    queue *in_q=(queue*)args;
    struct file_md5 *md5_in, md5_file;
    while((md5_in = q_remove(*in_q))) {
        md5_file.file = md5_in->file;

        sum_file(&md5_file);

        if(memcmp(md5_file.hash, md5_in->hash, md5_file.hash_size)!=0) {
            printf("File %s doesn't match.\nFound:    ", md5_file.file);
            print_hash(&md5_file);
            printf("\nExpected: ");
            print_hash(md5_in);
            printf("\n");
        }

        free(md5_in->file);
        free(md5_in->hash);
        free(md5_in);
        free(md5_file.hash);
    }
}

void check(struct options opt) {
    queue in_q;
    pthread_t read_thread;

    in_q  = q_create(opt.queue_size);
    read_thread_args *thread_args = malloc(sizeof (read_thread_args));
    thread_args->file=opt.file;
    thread_args->dir=opt.dir;
    thread_args->q=in_q;




    pthread_create(&read_thread, NULL,  read_hash_file, thread_args);
    pthread_t *threads = malloc((opt.num_threads) * sizeof(pthread_t));

    for(int i = 0; i< opt.num_threads;i++){
        pthread_create(&threads[i], NULL, (void *(*)(void *)) check_md5_files, &in_q);
    }

    pthread_join(read_thread, NULL);
    for (int i = 0; i < opt.num_threads; i++) {
        pthread_join(threads[i], NULL);
    }
    free(threads);
    free(thread_args);
    q_destroy(in_q);
}


void get_entries(void * data) {
    get_entries_data*ent_data=(get_entries_data*)data;
    walk_dir(ent_data->dir, add_files, &(ent_data->q));
    walk_dir(ent_data->dir, recurse, &(ent_data->q));
    q_end(ent_data->q);
}


void* process_files(void *arg) {
    process_files_data *data = (process_files_data*) arg;
    queue in_q =  data->in_q;
    queue out_q =  data->out_q;

    char *ent;
    struct file_md5 *md5;

    while ((ent = q_remove(in_q)) != NULL) {
        md5 = malloc(sizeof(struct file_md5));
        md5->file = ent;
        sum_file(md5);
        q_insert(out_q, md5);
    }

    pthread_exit(NULL);
}

void write_md5(void * v_args){
    wrt_md5_args *args=(wrt_md5_args*)v_args;
    queue out_q=args->out_q;
    FILE *out=args->out;
    int dirname_len=args->dirname_len;
    struct file_md5 *md5;

    while ((md5 = q_remove(out_q)) != NULL) {
        fprintf(out, "%s: ", md5->file + dirname_len);

        for (int i = 0; i < md5->hash_size; i++) {
            fprintf(out, "%02hhx", md5->hash[i]);
        }

        fprintf(out, "\n");

        free(md5->file);
        free(md5->hash);
        free(md5);
    }
}

// La funcion sum utiliza múltiples threads para procesar los archivos.
// La idea es que cada thread tome un archivo de la cola in_q,
// calcule su hash md5 y agregue la estructura file_md5 resultante a la cola out_q.
void sum(struct options opt) {
    queue in_q, out_q;


    in_q = q_create(opt.queue_size);
    out_q = q_create(opt.queue_size);

    get_entries_data *entries_data = malloc(sizeof(get_entries_data));
    entries_data->dir = opt.dir;
    entries_data->q = in_q;
    process_files_data *pfiles = malloc(sizeof(process_files_data));
    pfiles->in_q=in_q;
    pfiles->out_q=out_q;

    pthread_t *threads = malloc((2+opt.num_threads) * sizeof(pthread_t));

    pthread_create(&threads[0], NULL, (void*)get_entries, entries_data);
    for (int i = 0; i < opt.num_threads; i++) {
        pthread_create(&threads[i+2], NULL, process_files, pfiles);
    }


    FILE *out;
    int dirname_len;
    if ((out = fopen(opt.file, "w")) == NULL) {
        printf("Could not open output file\n");
        exit(0);
    }

    dirname_len = strlen(opt.dir) + 1; // length of dir + /



    wrt_md5_args *write_data = malloc(sizeof(wrt_md5_args));
    write_data->out=out;
    write_data->dirname_len=dirname_len;
    write_data->out_q=out_q;
    pthread_create(&threads[1], NULL, (void*)write_md5, write_data);

    // Espera a que los threads de lectura terminen de procesar los archivos
    for (int i = 0; i < opt.num_threads; i++) {
        pthread_join(threads[i+2], NULL);
    }

    q_end(out_q);

    // Espera a que todos los threads terminen de procesar los archivos
    for (int i = 0; i < 2; i++) {
        pthread_join(threads[i], NULL);
    }
    fclose(out);
    q_destroy(in_q);
    q_destroy(out_q);
    free(pfiles);
    free(write_data);
    free(entries_data);
    free(threads);
}


int main(int argc, char *argv[]) {

    struct options opt;

    opt.num_threads = 5;
    opt.queue_size  = 1000;
    opt.check       = true;
    opt.file        = NULL;
    opt.dir         = NULL;

    read_options (argc, argv, &opt);

    if(opt.check)
        check(opt);
    else
        sum(opt);

}
