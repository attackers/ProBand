#ifndef STRING_TRANS_H
#define STRING_TRANS_H

#include <stdio.h>
#include <string>
#include <memory.h>
//#include <sstream>
#include <stdarg.h>
#include <stdint.h>
#include "base64.h"
#include "aes.h"

using namespace std;

class encrypt 
{
public:

	static string ToHex(uint8_t* data,int len)
	{
		char Hex[len*2+1];
		for(int i=0;i<len;i++)
		{
			uint8_t c = data[i];
			uint8_t h = c>>4&0xF;
			Hex[i*2] = h > 9 ? h + 55 : h + 48;
			h = c&0xF;
			Hex[i*2+1] = h > 9 ? h + 55 : h + 48;
		}
		Hex[len*2] = 0;
		return string(Hex);
	};

	static int FromHex(string &data,uint8_t* outdata)
	{
		if((int)data.size()%2!=0) return 0;
		memset(outdata,0,data.size()/2);
		for(int i=0;i<(int)data.size();i+=2)
			outdata[i/2] = (((data[i] > '9' ? data[i] - 55 : data[i] - 48)&0xF)<<4)+((data[i+1] > '9' ? data[i+1] - 55 : data[i+1] - 48)&0xF);
		return data.size()/2;
	};

	static string ToBase64(uint8_t* data,int len)
	{
		size_t base64len = len*2+4;
		char base64[base64len];
		memset(base64,0,base64len);
		base64_encode((uint8_t*) base64, &base64len, data, len );
		return string(base64);
	};

	static int FromBase64(string &data,uint8_t* outdata,int buflen)
	{
		base64_decode(outdata, (size_t*)&buflen, (const uint8_t*)data.c_str(), data.size());
		return buflen;
	};

	//static int AESEncode(string in,string & out,string key,string iv);
	static string AESEncode(string source,string key,string iv)
	{
		if(key.size()!=32||iv.size()!=32)return"";
		uint8_t aeskey[16];
		uint8_t aesiv[16];
		FromHex(key,aeskey);
		FromHex(iv,aesiv);
		int sourcelen =source.size();
		if(sourcelen%16!=0)
			sourcelen = sourcelen/16*16+16;
		uint8_t target[sourcelen];
		memset (target,0,sourcelen);
		memcpy(target,source.c_str(),source.size());
		AES_Encode(target,sourcelen,target,aeskey,aesiv);
		return ToBase64(target,sourcelen);
	};

	static string AESDecode(string source,string key,string iv)	{
		if(key.size()!=32||iv.size()!=32)return"";
		uint8_t aeskey[16];
		uint8_t aesiv[16];
		FromHex(key,aeskey);
		FromHex(iv,aesiv);
		uint8_t target[source.size()+1];
		int sourcelen = FromBase64(source,target,source.size());
		if(sourcelen%16!=0) return "";
		AES_Decode(target,sourcelen,target,aeskey,aesiv);
		target[sourcelen] = 0;
		return string((char*)target);
	};
};

#endif
