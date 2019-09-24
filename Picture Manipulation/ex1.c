#include<stdio.h>

char magic[5];     // more than enough space to read in "P3\n" plus null

int blur(int i, int j, int pixels[64][64]);
void rotate(int pixels[64][64]);

int main() {
    int rows=64, cols=64;
    int ppm_max;
    int i, j;
    int pixels[64][64], blurred,rotated[64][64];
    
    fgets(magic, 5, stdin);
    puts("P2");
    
    scanf("%d%d", &cols, &rows);
    printf("%d\n%d\n", cols, rows);
    
    scanf("%d", &ppm_max);
    printf("%d\n", 255);
    
    for(i=0; i<rows; i++) {
        for(j=0; j<cols; j++) {
            scanf("%d", &pixels[i][j]);
            rotated[j][63-i] = pixels[i][j];
        }
    }
    for(i=0;i<rows;i++){
        for(j=0;j<cols;j++){
            if (i == 0 || i == 63 || j == 0 || j == 63){
                printf("%d\n", rotated[i][j]);
            }
            else{
                blurred = blur(i, j, rotated);
                printf("%d\n",blurred);
            }
        }
    }
    
}

int blur(int i, int j, int pixels[64][64]){
    
    return (pixels[i][j] + pixels[i-1][j-1] + pixels[i-1][j] + pixels[i-1][j+1] + pixels[i][j-1]
            + pixels[i][j+1] + pixels[i+1][j-1] + pixels[i+1][j] + pixels[i+1][j+1])/9;
    
}
