import std.stdio;
import deimos.openssl.aes;
import std.base64;
void main()
{
	writeln(aes256decrypt(aes256eecrypt()));
}

string aes256decrypt(string encode)
{
	//string encode = "VX10DUeAjBfO15TuEFl3GsZipI4/mO1c3pGSSrq/zT4jae0xyAIdLGKelniYd9nrSOnAUY37qaZ7O9yHgus9v2HLXb+G6BZOEBADNecHRKbt7n4uE7ow43UbFUluzo8wLqQmWoRcdvCD5sr9E+4gV5Xfywh60T33ylt32mk4fXYHWs3BOUOAbh1BsfNHrPavBkrl1fn3i65NorQZSghqP2Ywm/pDoOQB9jpOy7S6Am3G6ZCmB3TJi6moYVnAWHjLZIgBomU4PlmRISZpWYBUYCFrqfGJGsP18PoEqvBb2qTJQFhp/cKAIOSvWXHKGEZYi56O3anMnCOHZl6AABkGtLHmKbeDdtIUg5fUVBhS5030tLYLIPQQtkadbLurK9Hwe8nNxLx8wmO47puGMxHlTg==";
	//string encode = "VX10DUeAjBfO15TuEFl3GsZipI4/mO1c3pGSSrq/zT4jae0xyAIdLGKelniYd9nrSOnAUY37qaZ7O9yHgus9v2HLXb+G6BZOEBADNecHRKaNqUvg8xA2O2ckxkWmw71AXv7NrC4yf+6nxNP4VI7ht3VdGkYVrSgQWelvIejg46m6PyfsfbO03v0996G5aLLI+iYDOxqIw5/JuGXyz52fBfORD8AJTunufCgv/NXWyPcVkHlcNz1BiW3ptZ1Z+iKGhjKNo8Sc5NlWtMoGH2T2AQjYWbhyNgpgWoT8ve9XJ6B0KP2hVrr8t++dx1ie5PAq3BDf5kmibx7j1k8ku3stUx5OXEDrPdyZO2IiYti4tjfqNyMIVbFLAbyKWMOkzK0GAAA=";	

	//AES 解密获取data
	const ubyte[] ubSignedData = Base64.decode(encode);
	string userKey = "3234257aa9fe9a460ec5fde040abb53a";
	const ubyte[] ubUserKey = cast(const ubyte[])userKey;
	AES_KEY key;
	AES_set_decrypt_key( ubUserKey.ptr, 256, &key);
	ubyte[] out_ = new ubyte[ubSignedData.length];
	ubyte[32] iv;
	AES_cbc_encrypt(ubSignedData.ptr, out_.ptr,ubSignedData.length , &key,iv.ptr, AES_DECRYPT);
	
	return cast(string) out_;
}

string aes256eecrypt()
{
	string encode = `{"subject":"red apple","body":"red apple made in China","amount":100,"order_no":1490695877,"currency":"cny","extra":{"success_url":"http:\/\/ithox.com\/success\/","cancel_url":"http:\/\/ithox.com\/cancel\/"},"channel":"alipay_wap","client_ip":null,"app":"c1d4d06048ed7342726955367350baba"}`;

	//AES 解密获取data
	ubyte[] ubSignedData = cast(ubyte[])encode;
	if(ubSignedData.length % 16 > 0)
	{
		long ubTotal = (ubSignedData.length / 16 +1) * 16;
		ubyte[] pkcs7 = new ubyte[16 - ubSignedData.length % 16];
		pkcs7[] = cast(ubyte)(ubTotal - ubSignedData.length);
		
		ubSignedData ~=pkcs7;
	}
	string userKey = "3234257aa9fe9a460ec5fde040abb53a";
	const ubyte[] ubUserKey = cast(const ubyte[])userKey;
	AES_KEY key;
	AES_set_encrypt_key( ubUserKey.ptr, 256, &key);
	ubyte[] out_ = new ubyte[ubSignedData.length];
	ubyte[32] iv;
	AES_cbc_encrypt(ubSignedData.ptr, out_.ptr,ubSignedData.length, &key,iv.ptr, AES_ENCRYPT);
	return Base64.encode(out_);

	//return cast(string) out_;
}
