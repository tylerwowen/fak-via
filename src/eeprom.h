/*
 created by Deqing Sun for use with CH55xduino
 */

#pragma once

void eeprom_write_byte(uint8_t addr, uint8_t val);

uint8_t eeprom_read_byte(uint8_t addr);