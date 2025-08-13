#define AUTHORS_NAME "autores"
#define AUTHORS_DESCRIPTION "autores ->  Muestra una lista de autores y sus inicios de sesion\nautores [-l] -> Muestra solo los inicios de sesion de los autores\nautores [-n] -> Muestra solo los nombres de los autores"

#define PID_NAME "pid"
#define PID_DESCRIPTION "pid -> Imprime el pid de la consola\npid [-p] -> Muestra el pid del proceso padre de la consola"

#define FOLDER_NAME "carpeta"
#define FOLDER_DESCRIPTION "carpeta -> Muestra el directorio actual de trabajo \ncarpeta [direct] -> Cambia el directorio actual de trabajo a direct"

#define TIME_NAME "fecha"
#define TIME_DESCRIPTION "fecha -> Muestra tanto la fecha como la hora actual \nfecha [-d] -> Muestra la fecha actual \nfecha [-d] -> Muestra la hora actual"

#define HISTORY_NAME "hist"
#define HISTORY_DESCRIPTION "hist -> Muestra el historial de comandos ejecutados\nhist [-c] -> Borra el historial de comandos ejecutados\nhist [-N] -> Muestra un N especificado de comandos ejecutados en la shell"

#define COMMAND_NAME "comando"
#define COMMAND_DESCRIPTION "comando N -> Ejecuta el comando mediante un N (Numero) correspondiente en el historial de comandos "

#define INFOSYS_NAME "infosis"
#define INFOSYS_DESCRIPTION "infosis -> Muestra informacion sobre la maquina que ejecuta la consola"

#define HELP_NAME "ayuda"
#define HELP_DESCRIPTION "ayuda -> Muestra la lista de comandos disponibles\nayuda [cmd] -> Muestra una pequenha descripcion de el comando cmd"

#define END_NAME "fin"
#define END_DESCRIPTION "fin -> Finaliza el shell "

#define EXIT_NAME "salir"
#define EXIT_DESCRIPTION "salir -> Finaliza el shell "

#define BYE_NAME "bye"
#define BYE_DESCRIPTION "bye -> Finaliza el shell "

#define CREATE_NAME "create"
#define CREATE_DESCRIPTION "create [-f] -> crea un fichero\ncreate [directorio] -> crea un directorio "

#define STAT_NAME "stat"
#define STAT_DESCRIPTION "stat [fichero]-> Nos indica tamaño y el usuario propietario\nstat [-long] -> Devuelve mas informacion en formato largo\nstat [-acc] -> Devuelve el acesstime\nstat [-link] -> Nos dice si el enlace es simbolico y su ruta contenida"

#define LIST_NAME "list"
#define LIST_DESCRIPTION "list [directorio] -> lista el contenido de un directorio\nlist [-reca] -> lista un directorio de forma recursiva hacia atras\nlist [-recb] -> lista un directorio de forma recursiva hacia delante\nlist [-hid] -> incluye ficheros ocultos\nlist [-long] -> Devuelve mas informacion en formato largo\nlist [-acc] -> Devuelve el acesstime\nlist [-link] -> Nos dice si el enlace es simbolico y su ruta contenida   "

#define DELETE_NAME "delete"
#define DELETE_DESCRIPTION "delete [ficheros o directorios] -> Borra ficheros o  directorios vacios "

#define DELTREE_NAME "deltree"
#define DELTREE_DESCRIPTION "deltree [ficheros o directorios] -> Borra fichero o directorios vacios de forma recursiva "


//P2 HELP


#define ALLOCATE_NAME "allocate"
#define ALLOCATE_DESCRIPTION ""

#define DEALLOCATE_NAME "deallocate"
#define DEALLOCATE_DESCRIPTION ""


#define MEMDUMP_NAME "memdump"
#define MEMDUMP_DESCRIPTION ""

#define MEMFILL_NAME "memfill"
#define MEMFILL_DESCRIPTION ""

#define IO_NAME "i-o"
#define IO_DESCRIPTION ""


#define MEMORY_NAME "memory"
#define MEMORY_DESCRIPTION ""


#define RECURSE_NAME "recurse"
#define RECURSE_DESCRIPTION ""



/*
 * Priority ->
 * getpriority
 * setpriority
 *
 * ENV ->
 * 1)
 *  char* getenv(char * var)
 *  setEnv(char var, char value, int overr)
 *
 * 2)
 *  extern char ** environ;
 *  environ[0] -> primera
 *  environ[final] -> NULL
 * 3)
 *  int main(int argc, char * argv[], char ** env)
 *
 *  FORK ->
 *  el shell hace una llamada a fork y espera a que el hijo termine
 *
 *  PID fork();
 *  crea otro proceso exactamente igual al anterior
 *  pid < 0 -> error llamada
 *  pid = 0 -> tu eres el proceso nuevo
 *  pid > 0 -> eres el proceso original y pid es el del nuevo
 *
 *  EXECUTE ->
 *  añadir al principio -> define _GNU_SOURCE
 *  char *args[]={"LS","-L",NULL}
 *  execute(args[0], args, env)
 *  en args array de tokens, quitando el @
 *  mirar @ finales para prioridades
 *  Puede tener delante una lista de variables de entorno
 *
 *  perror después ya que si el shell se sigue ejecutando sinifica un error en execute
 *
 *  ***** -> fork y execute unidos
 *  proceso hijo (fork) ejecuta
 *  hijo -> despues de ejecutar exit(0)
 *  padre -> waitpid(PID, NULL, 0)
 *
 *  int status;
 *  waitpid(PID, &status, WNOHANG    No bloqueo
 *                        WUNTRACED  Informar stops
 *                        WCONTINUE) Cuando reanuda
 *mirar documentacion waitpid
 *  WIFEXITED(wstatus), terminado normal
 *  WEXITSTATUS(wstatus), exit status del hijo
 *  WIFSIGNALED(wstatus), si murio por una señal
 *  WTERMSIG()
 *  ....
 *  ....
 *
 *
 *  kill -term pid
 *  kill -kill pid matar
 *  kill -stop pid parar
 *  kill -cont pid reanudar
 *
 *
 *  & -> ejecutar en segundo plano
 */


#define PRIORITY_NAME "priority"
#define PRIORITY_DESCRIPTION "priority [pid] [valor]  Muestra o cambia la prioridad del proceso pid a valor"

#define SHOWVAR_NAME "showvar"
#define SHOWVAR_DESCRIPTION ""

#define CHANGEVAR_NAME "changevar"
#define CHANGEVAR_DESCRIPTION ""

#define SHOWENV_NAME "showenv"
#define SHOWENV_DESCRIPTION ""

#define FORK_NAME "fork"
#define FORK_DESCRIPTION ""

#define EXECUTE_NAME "execute"
#define EXECUTE_DESCRIPTION ""

#define LISTJOBS_NAME "listjobs"
#define LISTJOBS_DESCRIPTION ""

#define DELJOBS_NAME "deljobs"
#define DELJOBS_DESCRIPTION ""

#define JOB_NAME "job"
#define JOB_DESCRIPTION ""

















/*
priority    V
showvar     V
changevar   R
showenv     V
fork        V
execute     V
listjobs    X
deljobs     X
job         X
*/