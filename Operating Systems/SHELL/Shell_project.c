// Alumno: Salvador Carrillo Fuentes (44653917-S)
// G.I. Informática. Grupo C

/**
UNIX Shell Project

Sistemas Operativos
Grados I. Informatica, Computadores & Software
Dept. Arquitectura de Computadores - UMA

Some code adapted from "Fundamentos de Sistemas Operativos", Silberschatz et al.

To compile and run the program:
   $ gcc Shell_project.c job_control.c -o Shell
   $ ./Shell          
	(then type ^D to exit program)

**/

#include "job_control.h"   // remember to compile with module job_control.c 

#define MAX_LINE 256 /* 256 chars per line, per command, should be enough. */

job *lista; // para procesos en background, puntero a job

/* Manejador SIGCHLD */
// wait a procesos en bg y suspendidos
void handler(int num){ 
	int i, status, info, pid_wait;
	enum status status_res;
	job *aux; // puntero a job

	block_SIGCHLD(); // libre de sigchld a partir de aquí
	for (i=1; i<=list_size(lista); i++){ // recorro la lista de trabajos
		aux = get_item_bypos(lista, i); // selecciona el job correspondiente
		pid_wait = waitpid(aux->pgid, &status, WUNTRACED|WNOHANG); // NOHANG: no quiero que se bloquee, sólo preguntar
		if (pid_wait == aux->pgid){ // coincide con el pgid del job?
			status_res = analyze_status(status, &info); // para imprimir la información del proceso acabado
			printf("\nBackground process change: pid: %d, %s, command: %s, info: %d\n",
					pid_wait, status_strings[status_res], aux->command, info);
			if ((status_res == EXITED) || (status_res == SIGNALED)){  
				delete_job(lista, aux); // borro el job de la lista (terminado naturalmente o víctima de una señal para morir)
				i--; // decremento el contador para volver a la posición anterior tras el incremento al final del for
			}
			if (status_res == SUSPENDED){ // ¿suspendido?
				aux->state = STOPPED; // actualizo estado
			}
		}
	}
	unblock_SIGCHLD(); // restaura sigchld
	fflush(stdout); // limpia salida estándar
	return;
}



// -----------------------------------------------------------------------
//                            MAIN          
// -----------------------------------------------------------------------

int main(void)
{
	char inputBuffer[MAX_LINE]; /* buffer to hold the command entered */
	int background;             /* equals 1 if a command is followed by '&' */
	char *args[MAX_LINE/2];     /* command line (of 256) has max of 128 arguments */ //salvi: args es un array de 128 punteros a char
	// probably useful variables:
	int pid_fork, pid_wait; /* pid for created and waited process */
	int status;             /* status returned by wait */
	enum status status_res; /* status processed by analyze_status() */
	int info;				/* info processed by analyze_status() */

	char path[1024]; // para getcwd

	ignore_terminal_signals(); // ignoro las señales relacionadas con el terminal (ctrl+c, ctrl+z)

	job *nodo; // puntero a job
	lista = new_list("task list"); // lista vacía
	signal(SIGCHLD, handler); // armo la señal

	while (1)   /* Program terminates normally inside get_command() after ^D is typed*/
	{   		
		printf("%s$ ",getcwd(path, 1024)); // path de directorios. Imprime prompt
		fflush(stdout);	// limpia salida estándar	
		get_command(inputBuffer, MAX_LINE, args, &background);  /* get next command */ 
		
		if(args[0]==NULL) continue; // if empty command. continue vuelve al inicio del while

		/* Comando interno exit */
		if (strcmp(args[0],"exit") == 0){ // comparo con la función strcmp
			exit(EXIT_SUCCESS); // termina el programa con éxito
		}

		/* Comando interno cd */
		if (strcmp(args[0],"cd") == 0){ 
			if (args[1] != NULL){
				if (strcmp(args[1], "~") == 0){ // me voy al home si se introduce el caracter ~
					chdir(getenv("HOME")); // cambio el directorio al de la variable de entorno HOME
				} else if (chdir(args[1]) == -1){ // error
					fprintf(stderr, "cd: %s: No such file or directory\n", args[1]);
				} 
			} else if (args[1]==NULL){ // cd sin argumentos también voy al home
				chdir(getenv("HOME"));
			}
			continue;
		}

		/* Comando interno jobs */
		if (strcmp(args[0], "jobs") == 0){
			block_SIGCHLD();
			if(empty_list(lista)){ // lista vacía
				printf("La lista está vacía\n");
			}else{
				print_job_list(lista); // imprime el contenido de la lista
			} 
			unblock_SIGCHLD();
			continue;
		}

		/* Comando interno fg*/
		if(strcmp(args[0], "fg") == 0){
			block_SIGCHLD(); // siempre que vaya a trabajar con la lista, ya que la señal sigchld es asíncrona
			if(empty_list(lista)) {
				printf("La lista de trabajos está vacía\n");
			} else {
				job *aux;
				if(args[1] == NULL){
					aux = get_item_bypos(lista, 1); // sin argumentos, cojo el primero
				} else {
					int tam = list_size(lista);
					if (atoi(args[1])>tam || atoi(args[1])<=0){
						perror("Ha intentado acceder a un job que no está en la lista");
						continue;
					} else {
						aux = get_item_bypos(lista, atoi(args[1])); // con argumento, cojo el indicado por el número
					}
				}
				aux->state = FOREGROUND; // actualiza estado
				if (killpg(aux->pgid, SIGCONT)!=0){ // si el valor retornado no es el correcto, error
					perror("Error: La señal no se envió");
				}
				set_terminal(aux->pgid); // cede el terminal al proceso
				waitpid(aux->pgid, &status, WUNTRACED); // esperamos al proceso en fg
				set_terminal(getpid()); // terminal vuelve al Shell
				status_res = analyze_status(status, &info);
				printf("\nForeground pid: %d, command: %s, %s, info: %d\n", aux->pgid, aux->command, status_strings[status_res], info);
				if(status_res == SUSPENDED){ // ctrl+z: SIGSTOP
					aux->state = STOPPED; // actualizo estado
				} else { // if (status_res==SIGNALED || status_res==EXITED) -> si lo mato (ctrl+c; SIGINT) o si muere
					delete_job(lista, aux); // elimino job de la lista
				}
				unblock_SIGCHLD();
				continue;
			}
		}

		/* Comando interno bg*/
		if (strcmp(args[0], "bg") == 0){
			block_SIGCHLD();
			if(empty_list(lista)) {
				printf("La lista de trabajos está vacía\n");
			}
			else {
				job *aux;
				if (args[1] == NULL){
					aux = get_item_bypos(lista, 1); // sin argumentos, el primero
				} else {
					int tam = list_size(lista);
					if (atoi(args[1])>tam || atoi(args[1])<=0){
						perror("Ha intentado acceder a un job que no está en la lista");
						continue;
					} else {
						aux = get_item_bypos(lista, atoi(args[1])); // uso atoi() para convertir a int el segundo argumento
					}
				}
				aux->state = BACKGROUND; // actualizo el estdo 
				killpg(aux->pgid, SIGCONT);	// envío la señal de continuar al grupo de procesos completo
				printf("Background job running... pid: %d, command: %s\n", aux->pgid, aux->command);
			}
			unblock_SIGCHLD();
			continue;
		}

		/* the steps are:
			 (1) fork a child process using fork()
			 (2) the child process will invoke execvp()
			 (3) if background == 0, the parent will wait, otherwise continue 
			 (4) Shell shows a status message for processed command 
			 (5) loop returns to get_commnad() function
		*/

		// (1) fork a child process using fork(): creates a new process (child process)
		pid_fork = fork();

		/* Comandos externos */

		/* 
		Llamada a fork:
		Si todo sale bien, al padre le devuelve el pid del hijo y al hijo le devuelve un 0.
		Si hay algún error, devuelve un -1 al padre y no se crea el nuevo proceso. 
		*/

		if (pid_fork < 0){ // rama error fork
			perror("Error: fork failed");
			exit(EXIT_FAILURE); // no se creó el proceso
		} else if (pid_fork == 0){ // rama hijo
			restore_terminal_signals(); // restauro las señales relacionadas con el terminal
			new_process_group(getpid()); // creo un grupo cuyo líder es el proceso recién creado. Se emancipa del padre
			if (!background){ // lanzado en fg
				set_terminal(getpid()); // se le cede el terminal al proceso creado
			}
		// (2) the child process will invoke execvp()
			execvp(args[0], args); // carga la imagen del comando hijo
			fprintf(stderr, "Error, command not found: %s\n", args[0]); 
			exit(EXIT_FAILURE); // no se ejecutó el comando. El hijo falla, debe morir
		} else { // rama padre
			new_process_group(pid_fork); // crea un nuevo grupo cuyo líder es el hijo, se emancipa
		// (3) if background == 0, the parent will wait, otherwise continue 
			if (!background){ // fg
				set_terminal(pid_fork); // se cede el terminal al hijo
				pid_wait = waitpid(pid_fork, &status, WUNTRACED); // el padre espera a que muera o cambie de estado. Es bloqueante
				status_res = analyze_status(status, &info); // ¿cómo está el hijo?
		// (4) Shell shows a status message for processed command
				printf("\nForeground pid: %d, command: %s, %s, info: %d\n", pid_wait, args[0], status_strings[status_res], info);
				if (status_res == SUSPENDED && pid_wait == pid_fork){ // ¿suspendido?
					nodo = new_job(pid_fork, args[0], STOPPED);
					block_SIGCHLD();  // sección crítica libre de sigchld, voy a manipular la lista
					add_job(lista,nodo);
					unblock_SIGCHLD(); // restauro sigchld
				}
				set_terminal(getpid()); // el padre recupera el terminal
			} else { // bg
		// (4) Shell shows a status message for processed command
				printf("Background job running... pid: %d, command: %s\n", pid_fork, args[0]);
				nodo = new_job(pid_fork, args[0], BACKGROUND);
				block_SIGCHLD(); // sección crítica libre de sigchld
				add_job(lista,nodo); //añadir a lista
				unblock_SIGCHLD();
			}
		}
		// (5) loop returns to get_commnad() function
	} // end while
}
