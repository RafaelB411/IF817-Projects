#include <stdio.h>

extern float cone_volume(float raio, float altura);

int main() {
    float ret = cone_volume(2.0, 3.0);
    printf("O volume do cone eh %.2f\n", ret);
    return 0;
}