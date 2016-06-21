

#include <stdio.h>

//#ifndef uint32_t
//typedef unsigned __int32 uint32_t;
//#endif
//
//#ifndef int32_t
//typedef __int32 int32_t;
//#endif
//
//#ifndef uint16_t
//typedef unsigned __int16 uint16_t;
//#endif
//
//#ifndef uint32_t
//typedef unsigned __int32 uint32_t;
//#endif
//
//__int

#define KYAP_CRYPT_DEFAULTK 0xE7A35409
#define KYAP_CRYPT_DEFAULTK_DOC_KY 0xE7A35409
static uint32_t _rand(uint32_t* holdrand) {
	uint32_t r = *holdrand;
	r = r * 214013 + 2531011;
	*holdrand = r;
	return (r >> 16) & 0x7fff;
}
static int kyap_crypt(const char* src, int32_t src_len, uint32_t key, char* out, int32_t* out_len) {
	int i = 0;
	if (src_len < 0) return src_len;
	for (; i < src_len; i++) *(char*)(out + i) = *(char*)(src + i) ^ (char)_rand(&key);
	if (out_len) *out_len = src_len;
	return 0;
}