#ifndef COMMON_BASE64_H
#define COMMON_BASE64_H

#include <string.h>

#define POLARSSL_ERR_BASE64_BUFFER_TOO_SMALL               -0x002A  /**< Output buffer too small. */
#define POLARSSL_ERR_BASE64_INVALID_CHARACTER              -0x002C  /**< Invalid character in input. */

int base64_encode(unsigned  char *dst, size_t *dlen, const unsigned char *src, size_t slen );

int base64_decode( unsigned char *dst, size_t *dlen, const unsigned char *src, size_t slen );

#endif
