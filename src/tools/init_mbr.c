// Tool to copy the 448 bytes of boot code, jump to main, and add the boot signature

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>

const char USAGE[] = "Usage: %s <destination> <boot-code>\n";
const uint16_t SIGNATURE = 0xAA55;


int main(int argc, char **argv)
{
    if (argc < 3) 
    {
        printf(USAGE, argv[0]);
        exit(-1);
    }

    FILE *dest, *code;

    if ((dest = fopen(argv[1], "rb+")) == NULL) 
    {
        printf("Unable to read destination file\n");
        exit(-2);
    }

    if ((code = fopen(argv[2], "r")) == NULL)
    {
        printf("Unable to read boot code file\n");
        exit(-3);
    }

    // read current bootsector to buffer
    uint8_t *bootsector = malloc(512);
    fread(bootsector, 512, 1, dest);

    // get code size
    fseek(code, 0, SEEK_END);
    int size = ftell(code);
    fseek(code, 0, SEEK_SET);

    // warn if code is larger than 448 + boot record (510)
    if (size > 510)
        printf("Warning: boot code is too large, excess code might be cut off");

    // read jump code to buffer
    fread(bootsector, 3, 1, code);

    // read bootcode to buffer
    fseek(code, 62, SEEK_SET);
    fread(bootsector + 62, size - 62, 1, code);

    // pad the rest with zeros
    if (size < 510) 
        memset(bootsector + size, 0, 510 - size);
    
    // add boot signature
    memcpy(bootsector + 510, &SIGNATURE, 2);

    // write changes to file
    fseek(dest, 0, SEEK_SET);
    fwrite(bootsector, 512, 1, dest);
    
    // free buffer and close files
    free(bootsector);
    fclose(dest);
    fclose(code);

    return 0;
}