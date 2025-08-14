%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void yyerror (char const *);
void yyerror_param (char const *, char *);
extern int yylex();
extern char *yytext;

extern int yylineno;
extern void yyclearin;
void process_body(const char *body);  // Declaración de la función processBody
// Pila para rastrear tags abiertos
typedef struct StackNode {
    char *tag;
    struct StackNode *next;
} StackNode;
%}

%union {
    char *sval;
}

%define parse.error verbose

%token <sval> REQUEST_LINE_HP REQUEST_LINE_RUTE REQUEST_LINE_HTTP REQUEST_LINE_HPR REQUEST_LINE_DOMAIN
%token <sval> RESPONSE_LINE
%token <sval> NL NEW_LINE_2 BODY_LINE PHRASE
%token <sval> METHOD VERSION OTHER BODY
%token <sval> BAD_RESPONSE_LINE
%token <sval> HOST CACHE_CONTROL ACCEPT ACCEPT_ENCODING ACCEPT_LENGUAGE ACCEPT_CONTENT_LENGHT ACCEPT_CONTENT_TYPE ACCEPT_USER_AGENT ACCEPT_SERVER DATE
%token ENDFILE

%type <sval> body_lines body_line

%%

s: check headers body ENDFILE { printf("Estructura Completa[VALID]\n"); return 0;}
    ;

check:
    started_request_line { printf("Request [VALID]\n"); yyclearin;}
    | response_line { printf("Response [VALID]\n"); yyclearin;}
    | headers{}
    | bad_format {}
    | { yyerror("Fichero vacio"); yyclearin;}
    ;

started_request_line:
    REQUEST_LINE_HP   { printf("HOST:PORT [VALID]\n"); yyclearin;}
    | REQUEST_LINE_RUTE { printf("Rute [VALID]\n"); yyclearin;}
    | REQUEST_LINE_HTTP  { printf("HTTP [VALID]\n"); yyclearin;}
    | REQUEST_LINE_HPR  { printf("HOST:PORT:RUTE [VALID]\n"); yyclearin;}
    | REQUEST_LINE_DOMAIN { printf("Domain [VALID]\n"); yyclearin;}
    | bad_request_line {}

    ;

bad_request_line:
    REQUEST_LINE_HP OTHER { yyerror("Request HOST:PORT [INVALID]"); yyclearin;}
    | REQUEST_LINE_RUTE OTHER { yyerror("Request Rute [INVALID]"); yyclearin;}
    | REQUEST_LINE_HTTP OTHER { yyerror("Request HTTP [INVALID]"); yyclearin;}
    | REQUEST_LINE_HPR OTHER { yyerror("Request HOST:PORT:RUTE [INVALID]"); yyclearin;}
    | REQUEST_LINE_DOMAIN OTHER { yyerror("Request Domain [INVALID]"); yyclearin;}
    ;

response_line:
     RESPONSE_LINE { printf("Response header [VALID]\n"); yyclearin;}
    | bad_response_line {}
     ;

bad_response_line:
    RESPONSE_LINE OTHER { yyerror("Response header[INVALID]"); yyclearin;}
    ;

headers:
    headers NL headers
    | header
    ;

header:
    HOST {printf("Host VALID]\n");}
    | CACHE_CONTROL { printf("Cache Control [VALID]\n"); }
    | ACCEPT { printf("Accept [VALID]\n"); }
    | ACCEPT_ENCODING { printf("Encoding [VALID]\n"); }
    | ACCEPT_LENGUAGE { printf("Lenguage [VALID]\n"); }
    | ACCEPT_CONTENT_TYPE { printf("Content-Type [VALID]\n"); }
    | ACCEPT_CONTENT_LENGHT { printf("Content-Lenght [VALID]\n"); } 
    | ACCEPT_USER_AGENT { printf("User-Agent [VALID]\n"); } 
    | ACCEPT_SERVER { printf("Server [VALID]\n"); }
    | DATE { printf("Date [VALID]\n"); } 
    | /* Caso de que no haya */
    ;

bad_format:
    METHOD OTHER { yyerror("Request [INVALID]"); yyclearin;}
    | VERSION OTHER { yyerror("Response [INVALID]"); yyclearin;}
    | OTHER { yyerror("Format [INVALID]"); yyclearin;}
    ;

new_line:
   | NL new_line
   | NEW_LINE_2 new_line

body:
    NEW_LINE_2 body_lines { 
        printf("Analizando body...\n"); 
        process_body($2); 
    }
    | /* Caso de que no haya */
    ;

body_lines:
    body_line new_line body_lines { 
        $$ = malloc(strlen($1) + strlen($3) + 2);
        strcpy($$, $1);
        strcat($$, "\n");
        strcat($$, $3);
    }
    | body_line {
        $$ = strdup($1);
    }
    ;

body_line:
    BODY { $$ = strdup(yytext);}
    ;

%%

int main(int argc, char *argv[]) {
    extern FILE *yyin;
    yyin = stdin;
    yyparse();
    return 0;
}

void yyerror (char const *message) {
    fprintf (stderr, "Sintaxis incorrecta. Error cerca de la linea %i.\n\t\"%s\"\n", yylineno, message);
    exit(EXIT_FAILURE);
}

void yyerror_param (char const *message, char *error_val) {
    fprintf (stderr, "Sintaxis incorrecta. Error de parametros cerca de la linea %i.\n\t\"%s: %s\"\n", yylineno, message, error_val);
    exit(EXIT_FAILURE);
}

void push(StackNode **stack, const char *tag) {
    StackNode *new_node = (StackNode *)malloc(sizeof(StackNode));
    new_node->tag = strdup(tag);
    new_node->next = *stack;
    *stack = new_node;
}

char *pop(StackNode **stack) {
    if (!*stack) return NULL;
    StackNode *temp = *stack;
    char *tag = temp->tag;
    *stack = (*stack)->next;
    free(temp);
    return tag;
}

void validate_html_tags(const char *body, StackNode **stack) {
    const char *ptr = body;

    while (*ptr) {
        if (*ptr == '<') {
            const char *start = ptr;
            ptr++;

            // Saltar espacios
            while (*ptr && isspace(*ptr)) ptr++;

            // Identificar cierre de tag
            int is_closing = (*ptr == '/');
            if (is_closing) ptr++;

            // Capturar el nombre del tag
            const char *tag_start = ptr;
            while (*ptr && *ptr != '>' && !isspace(*ptr)) ptr++;
            size_t tag_len = ptr - tag_start;

            if (tag_len > 0) {
                char *tag = (char *)malloc(tag_len + 1);
                strncpy(tag, tag_start, tag_len);
                tag[tag_len] = '\0';

                // Saltar al final del tag
                while (*ptr && *ptr != '>') ptr++;
                if (*ptr != '>') {
                    fprintf(stderr, "Error: Tag sin cerrar encontrado: <%s\n", tag);
                    free(tag);
                    exit(EXIT_FAILURE);
                }

                if (is_closing) {
                    // Verificar que el cierre coincide con el tag más reciente
                    char *last_tag = pop(stack);
                    if (!last_tag || strcmp(last_tag, tag) != 0) {
                        fprintf(stderr, "Error: Tag de cierre incorrecto </%s> (esperado </%s>).\n", tag, last_tag ? last_tag : "ninguno");
                        free(tag);
                        free(last_tag);
                        exit(EXIT_FAILURE);
                    }
                    free(last_tag);
                } else {
                    // Agregar tag de apertura a la pila
                    push(stack, tag);
                }
                free(tag);
            }
        }
        ptr++;
    }
}


void validate_json(const char *body, StackNode **stack) {
    const char *ptr = body;
    int in_string = 0;
    int escape = 0;

    while (*ptr) {
        if (in_string) {
            if (escape) {
                escape = 0;
            } else if (*ptr == '\\') {
                escape = 1;
            } else if (*ptr == '"') {
                in_string = 0;
            }
        } else {
            if (*ptr == '"') {
                in_string = 1;
            } else if (*ptr == '{' || *ptr == '[') {
                push(stack, (*ptr == '{') ? "{" : "[");
            } else if (*ptr == '}' || *ptr == ']') {
                char *last_tag = pop(stack);
                if (!last_tag || (*ptr == '}' && strcmp(last_tag, "{") != 0) || (*ptr == ']' && strcmp(last_tag, "[") != 0)) {
                    fprintf(stderr, "Error: JSON de cierre incorrecto %c (esperado %s).\n", *ptr, last_tag ? last_tag : "ninguno");
                    free(last_tag);
                    exit(EXIT_FAILURE);
                }
                free(last_tag);
            }
        }
        ptr++;
    }

    if (*stack) {
        fprintf(stderr, "Error: JSON sin cerrar encontrado.\n");
        while (*stack) {
            char *unclosed_tag = pop(stack);
            fprintf(stderr, "  %s\n", unclosed_tag);
            free(unclosed_tag);
        }
        exit(EXIT_FAILURE);
    }
}

void process_body(const char *body) {
    if (body == NULL) {
        fprintf(stderr, "Error: el cuerpo de la petición es NULL.\n");
        return;
    }

    printf("Body [VALID]: Analizando el cuerpo de la petición...\n");

    StackNode *tag_stack = NULL;

    // Intentar detectar si es JSON
    if (body[0] == '{' || body[0] == '[') {
        // Intentar validar como JSON
        validate_json(body, &tag_stack);
        if (tag_stack) {
            fprintf(stderr, "Error: JSON sin cerrar encontrado:\n");
            while (tag_stack) {
                char *unclosed_tag = pop(&tag_stack);
                fprintf(stderr, "  %s\n", unclosed_tag);
                free(unclosed_tag);
            }
            exit(EXIT_FAILURE);
        }
        printf("El cuerpo JSON está correctamente balanceado.\n");
    } else {
        // Intentar validar como HTML
        validate_html_tags(body, &tag_stack);

        // Verificar si quedan tags sin cerrar
        if (tag_stack) {
            fprintf(stderr, "Error: Tags HTML sin cerrar encontrados:\n");
            while (tag_stack) {
                char *unclosed_tag = pop(&tag_stack);
                fprintf(stderr, "  <%s>\n", unclosed_tag);
                free(unclosed_tag);
            }
            exit(EXIT_FAILURE);
        }
        printf("El cuerpo HTML está correctamente balanceado.\n");
    }
}