import std.stdio;
import deimos.openssl.aes;
import deimos.openssl.rsa;
import deimos.openssl.sha;
import deimos.openssl.obj_mac;
import deimos.openssl.bio;
import deimos.openssl.pem;
import deimos.openssl.evp;
import std.base64;
import std.digest.sha;
import std.array;

void main()
{
	writeln(aes256Decrypt(aes256Encrypt()));
	rsa256Encrypt();
}

string aes256Decrypt(string encode)
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

string aes256Encrypt()
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

void rsa256Encrypt()
{
	string msg = `app_id=2016080300154304&biz_content={"body":"red apple made in China","out_trade_no":"1490953569","passback_params":"[]","product_code":"QUICK_MSECURITY_PAY","subject":"red apple","total_amount":"1"}&charset=utf-8&format=JSON&method=alipay.trade.app.pay&notify_url=https://spay,putao.com/api/pay/callbak/alipay/c1d4d06048ed7342726955367350baba&sign_type=RSA2&timestamp=2017-03-31 17:46:09&version=1.0`;
	string privateKey = "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA0+1jZB4ed581nQoNkwp0mPQvKYfJbBGNAEbdGIAL1+ZD2Ouk
iUdWiHc8wWXDiPyif+yOCAY6b65aB4que/xAeTbkbu0igI7QTS77UoEiocLtCjnI
voRTu4yBBA/bsiaMs8ksjYKP3UQxcz7xa4WvuP8919x8vKsq8nndHCqwN8ic293B
rtzgV/wJhAdERLaz3p1pj2n7GpsMTvlRugVyGQcW7rytR5w61Lvt+vcOjbf559He
rQ7a/XObGBZ0v6zSJCr5Vw8dbcCGWDWZjKmKWZ27A6LEIkoq9dLbDEcG0BPTtsYa
84PtC/O6a3xWgkjKgRuicZUNSxHdUUy+K/Qh8wIDAQABAoIBAEkxEUSAinEx0Shd
UnbYA5DXtHoZZV0napUP5EgT4QM9iW0fZQHsW1xiId+BL9jdt5mKrzriO8haZMl6
AezcH8A9TwNobqQLrrEZar8Bzl4jng4MCuKRfQGm8t/eQjfyzGFDN1ngH6OBa7qr
oGFMGHZB4K/ufD4Et55qrAyQSa/ZviBFTpGNWN2QYSAMf6wgU+DO1OPdfjqNl5qy
QjFJZLxsRXMqhB7Z1I2YaBfU+pV/kK4eFpE4H3UvIGIj7n4XJYwl7sA3gsj7lC4F
6VeszcuhLm7xRQfYL2uYxA3Oqw2fy+34eSPLWb/8LkTKFO2zJAXH2otj30dRFr4Z
hwp4c/ECgYEA8iY61EbcbJ77TZf+6/DqRryLskNDzBp5ST7mpkJHHwTXjoQpM7M7
rxxVe9uKcw0o44oojYJnE9y4134Jq0E7aeBXgx8xxoyQaC2J+jfczjZwyWIXPwsm
Lw3R/paMs+fVBLcHlrLz10LSlRNxQuB+igfxItjp/Qw1qQF6yPbNsvcCgYEA4Aye
tdzFf1bno8fduwPVeX5sC18IgQXswnLh3dl4W6d7Lar6XNAkVfrN2WJY4Jp7EN9i
GVLYRO4ewMhOVcnAeKC2is0uiW5/B16PwrzPBo4X3ExV7nIVzx6V2JAHFth4ESUb
+S0gQLo+6XpsSBeZPFLB2ctPwhmIGXKKQm9njeUCgYEAlXXZS9rtBLJgRHVzqCfM
Qprv0rjH6PvSLs5/SNGR2mh/r/yM/dc8GIpxjQBmBTtzKHbHLwj1HIJZKNEnoKej
x2bsPQeNDpMGMvcgueuvAy0BEpvT41q7V8G9AtnjwMtwZPef3HlaHlylY9RbTT8J
e6MJSEwAqOrXWBiMs+v57OMCgYEAou1KdOHI1SMza8yqF5dgI+ulUleXbYwLchPs
4FGGzs/qKXmOevP5mHS8QPrduudb2xc21UeDcgzfXD3NiWEfkBj+5czzrIkn4woG
7Qw0WIX4IAF6890OswGA4m1KWnisR3t+7iK8s5U8rriSCZLvoghkY6cPpwy+BhNf
K5Sr72kCgYEAr1njZlNy9rvU+2sZ9kWalA+/cuoaOY173pecrP5Ll/0B9SilEBJ8
slhr330xdTE95NlOCujrcSySG8WAH4LpvOJIt6U4P3F7j7Qk2t83F2AIVkP4k56F
Bo8zL3dIN4Vmfw3zkEHW8RN7NmG78E0rCmfE4k83AwS+qYENp9uIAu4=
-----END RSA PRIVATE KEY-----";
	ubyte[] uPrivateKey = cast(ubyte[])privateKey;
	const ubyte[SHA256_DIGEST_LENGTH/*32*/] hash256 = sha256Of(msg);
	BIO* bio = BIO_new_mem_buf(uPrivateKey.ptr, cast(int)uPrivateKey.length);
	assert(bio !is null, "new buff error");
	RSA* rsa = null;
	rsa = PEM_read_bio_RSAPrivateKey(bio, &rsa,null,null);
	assert(rsa !is null, "rsa is error");
	uint siglen = RSA_size(rsa);
	ubyte[] sigret = new ubyte[siglen];
	// 标准PKCS#1 v1.5 RSA RSA_PKCS1_PADDING
	RSA_sign(NID_sha256, hash256.ptr,cast(uint)SHA256_DIGEST_LENGTH, sigret.ptr, &siglen, rsa);
	writeln("string:", Base64.encode(sigret));
	RSA_free(rsa);
	BIO_free(bio);
}
