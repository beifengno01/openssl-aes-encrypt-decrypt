import std.stdio;
import deimos.openssl.aes;
import std.base64;
void main()
{
	writeln(aes256decrypt(aes256eecrypt()));
	//writeln(aes256decrypt());
}

string aes256decrypt(string encode)
{
	//string encode = "VX10DUeAjBfO15TuEFl3GsZipI4/mO1c3pGSSrq/zT4jae0xyAIdLGKelniYd9nrSOnAUY37qaZ7O9yHgus9v2HLXb+G6BZOEBADNecHRKYqEq/LKlMsIJ+cKhKGZMA1sXkISku9UPHCjS5kXvv7ruM1O2fwmRP6hyGNJCKYLt1rJbDglzml9iWZbtraEmVB1/WM1dz3w+EwDGE3mEvI65fKGeMs95gm6nGT04Bx2OPk2H+ZmMk7XYw0Bta6p4j9Gkva0xXKmCeD00LG3CZUf37vm1mlB5d6/6+Fkk1DjhO4UbJ0bv3uvKyUtX0gAwfH";
	//AES 解密获取data
	const ubyte[] ubSignedData = Base64.decode(encode);
	string userKey = "3234257aa9fe9a460ec5fde040abb53a";
	const ubyte[] ubUserKey = cast(const ubyte[])userKey;
	AES_KEY key;
	AES_set_decrypt_key( ubUserKey.ptr, 256, &key);
	ubyte[] out_ = new ubyte[ubSignedData.length];
	ubyte[32] iv;
	AES_cbc_encrypt(ubSignedData.ptr, out_.ptr,ubSignedData.length , &key,iv.ptr, AES_DECRYPT);
	int paddingLength = out_[$ - 1];//去除补全的
	return cast(string) out_[0 .. $ - paddingLength];
}

string aes256eecrypt()
{
	string encode = `{"subject":"red apple","body":"red apple made in China","amount":100,"order_no":"1490695877","currency":"cny","extra":{"success_url":"http:\/\/ithox.com\/success\/","cancel_url":"http:\/\/ithox.com\/cancel\/"},"channel":"alipay_wap","client_ip":null,"app":"c1d4d06048ed7342726955367350baba"}`;

	//AES 解密获取data
	ubyte[] ubSignedData = cast(ubyte[])encode;
	
	long ubTotal = (ubSignedData.length / 16 +1) * 16;
	ubyte[] pkcs7 = new ubyte[16 - ubSignedData.length % 16];
	pkcs7[] = cast(ubyte)(ubTotal - ubSignedData.length);
	
	ubSignedData ~=pkcs7;

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
