typedef unsigned int uint32_t;

void put32(uint32_t address, uint32_t value);
void delay(uint32_t cycles);

void main() {
    // Blinky!
    while(1) {
        // Turn on the GPIO
        put32(0xd0000000 + 0x014, (1 << 25));
        delay(1000000);
        // Turn off the GPIO
        put32(0xd0000000 + 0x018, (1 << 25));
        delay(1000000);
    }
}