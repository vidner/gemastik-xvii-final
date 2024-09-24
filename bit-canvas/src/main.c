#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>


int main() {
    setbuf(stdout, NULL);
    
    int choice = 0;
    int debug = 0;
    int size = 16;
    int canvas[16] = {0};

    puts("bit-canvas @ gemastik-xvii");
    puts("1. draw");
    puts("2. clear");
    puts("3. resize");
    puts("4. admin");
    puts("5. exit");
    
    while (1) {
        printf("choice? ");
        scanf("%d", &choice);
        switch (choice) {
            case 1:
                int n = 0;
                int x = 0;
                int y = 0;
                
                printf("how many bits? ");
                scanf("%d", &n);
                
                if (n > (size * size * 2)) {
                    puts("too many bits");
                    return 1;
                }

                for (int i = 0; i < n; i++) {
                    printf("where x y? ");
                    scanf("%d %d", &x, &y);
                    bool prev = 0;
                    bool next = 0;
                    prev = canvas[x] >> y & 1;
                    next = prev ^ 1;
                    canvas[x] ^= 1 << y;
                    if (debug) printf("[DEBUG] x: %d, y: %d, prev: %d, next: %d\n", x, y, prev, next);
                }

                break;
            
            case 2:
                for (int i = 0; i < size; i++) {
                    for (int j = 0; j < size * 2; j++) {
                        canvas[i] = 0;
                    }
                }

                break;
            
            case 3:
                printf("size? ");
                scanf("%d", &size);

                break;
            
            case 4:
                
                FILE *f = fopen("/flag.txt", "r");

                if (f == NULL) {
                    puts("flag not found");
                    return 1;
                }
                
                char flag[43];
                char buffer[43];
                
                fgets(flag, sizeof(flag), f);
                fclose(f);

                printf("password? ");
                scanf("%s", buffer);
                
                if (!strcmp(buffer, flag)) {
                    debug = 1;
                    puts("debug mode enabled");
                } else {
                    puts("invalid password");
                }

                break;
            
            case 5:
                puts("bye");
                return 0;
                
            default:
                printf("invalid choice %d\n", choice);
                return 1;
        }
        
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size * 2; j++) {
                printf("%d", canvas[i] >> j & 1);
            }
            puts("");
        }
    }

    return 0;
}