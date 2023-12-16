#define XIP_CTRL_BASE   0x14000000
#define XIP_SSI_BASE    0x18000000

typedef char uint8_t;
typedef unsigned int uint32_t;

void put32(uint32_t addr, uint32_t val);
uint32_t read32(uint32_t addr);

#define CTRL0_XIP (31 << 16) | (3 << 8)
#define SPI_CTRL0_XIP (0x3 << 24) | (2 << 8) | (6 << 2)


void boot() {
    // Wait for IOBank0 to reset
    put32(0x4000c000 + 0x3000, 0x1 << 5);
    while ((read32(0x4000c000 + 0x8) & (0x1 << 5)) == 0){};

    put32(XIP_CTRL_BASE, 0x0); // Disable XIP Cache
    put32(XIP_SSI_BASE + 0x08, 0x0); // Disable SSI
    put32(XIP_SSI_BASE + 0x14, 0x4); // Set BAUDR
    put32(XIP_SSI_BASE + 0x00, CTRL0_XIP); // Set CTRL0
    put32(XIP_SSI_BASE + 0xF4, SPI_CTRL0_XIP); // Set SPI CTRL0
    put32(XIP_SSI_BASE + 0x08, 0x1); // Enable SSI

    // Copy program to sram
    uint8_t* src = (uint8_t*)0x10000100; // 256 Byte offset (that part is the bootloader)
    uint8_t* dst = (uint8_t*)0x20000000; // SRAM

    // Shadow copy into sram
    for (int i = 0; i < 0xFFF; i++) {
        *dst++ = *src++;
    }

    // Jump to the shadowlands
    void* notmain = (void*)0x20000000;
    goto *notmain;

}