#include <stdint.h>

int counter = 25;

int main(void) {
  volatile uint32_t *ptr = (volatile uint32_t *)0xA000;

  for (int i = 0; i < 100; i++) {
    counter += i;
  }

  *ptr = counter;
  // return 0;
  while (1);
}

