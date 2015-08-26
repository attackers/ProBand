#ifndef COMMON_AES_H
#define COMMON_AES_H

#include <string.h>
#include <stdint.h>

#define AES_ENCRYPT     1
#define AES_DECRYPT     0

#define POLARSSL_ERR_AES_INVALID_KEY_LENGTH                -0x0020  /**< Invalid key length. */
#define POLARSSL_ERR_AES_INVALID_INPUT_LENGTH              -0x0022  /**< Invalid data input length. */

typedef struct
{
    int nr;                     /*!<  number of rounds  */
    uint32_t *rk;               /*!<  AES round keys    */
    uint32_t buf[68];           /*!<  unaligned data    */
}
aes_context;

#define AES_KEY_SIZE  128
#define IV_SIZE 16

void AES_Encode(uint8_t* in,uint16_t len,uint8_t* out,uint8_t* key,uint8_t* iv);

void AES_Decode(uint8_t* in,uint16_t len,uint8_t* out,uint8_t* key,uint8_t* iv);

void aes_init( aes_context *ctx );

void aes_free( aes_context *ctx );

int aes_setkey_enc( aes_context *ctx, const unsigned char *key,
                    unsigned int keysize );

int aes_setkey_dec( aes_context *ctx, const unsigned char *key,
                    unsigned int keysize );

int aes_crypt_ecb( aes_context *ctx,
                    int mode,
                    const unsigned char input[16],
                    unsigned char output[16] );

int aes_crypt_cbc( aes_context *ctx,
                    int mode,
                    size_t length,
                    unsigned char iv[16],
                    const unsigned char *input,
                    unsigned char *output );
#endif
