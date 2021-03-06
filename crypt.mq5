//+------------------------------------------------------------------+
//|                                                        crypt.mq5 |
//|                                    André Augusto Giannotti Scotá |
//|                              https://sites.google.com/view/a2gs/ |
//+------------------------------------------------------------------+

/*
Steps:
1 - Creating the key:
   Hash the raw key with SHA256 to generate a 64bytes key
   Encode to BASE64 just for print to log
2 - Encryption
3 - Encoding encryption binary result to BASE64 for a safe trasnference and decoding back from BASE64 to binary
4 - Decryption
*/

int OnInit(void)
{
   string msgraw = "abcdefghijlmnopqrstuvxz";
   string keyraw = "default key";
   int res = 0;
   uchar msg[], dst[], key[], keyaux[], key64[], dummy[];

   ArrayInitialize(dummy, 0);

   /* === 1 === */
   /* Creating the key: BASE64(SHA256(keyraw)) */
   StringToCharArray(keyraw, keyaux);

   res = CryptEncode(CRYPT_HASH_SHA256, keyaux, dummy, key);
   if(res != 32){ /* SHA256 result size */
      printf("Key creation error at SHA256: [%d]", GetLastError());
      return(INIT_FAILED);
   }

   /* BASE64 IS JUST TO PRINT THE KEY! To encrypt I use the sha256 output */
   res = CryptEncode(CRYPT_BASE64, key, dummy, key64);
   if(res == 0){
      printf("Key creation error at BASE64: [%d]", GetLastError());
      return(INIT_FAILED);
   }
   printf("Key [%s] Size [%d] from Encoded BASE64(SHA256(\"%s\"))", CharArrayToString(key64), res, keyraw);

   /* === 2 === */
   /* Encrypting */
   StringToCharArray(msgraw, msg);

   res = CryptEncode(CRYPT_AES256, msg, key, dst);
   if(res == 0){
      printf("Encryption error: [%d]", GetLastError());
      return(INIT_FAILED);
   }

   printf("Crypted message size [%d], dump:", res);
   ArrayPrint(dst, 0, " ", 0, WHOLE_ARRAY, 0);

   /* === 3 === */
   /* Sending encrypted binary message to BASE64. We can transfer the message safely (to net or in a file). */
   res = CryptEncode(CRYPT_BASE64, dst, dummy, dummy);
   if(res == 0){
      printf("Dump encrpyted message as BASE64: [%d]", GetLastError());
      return(INIT_FAILED);
   }
   printf("Encrypted message encode BASE64: [%s][%d]", CharArrayToString(dummy), res);
   
   ArrayFill(msg, 0, ArraySize(msg), 0);
   ArrayFill(dst, 0, ArraySize(dst), 0);
   /* Now, the only saved message is stored ate dummy variable, encrypted with AES265 and encoded as BASE64 */

   /* Restoring message from BASE64 to binary */
   res = CryptDecode(CRYPT_BASE64, dummy, dst, dst);
   if(res == 0){
      printf("Restore message as BASE64: [%d]", GetLastError());
      return(INIT_FAILED);
   }
   printf("Restore message encode BASE64 to binary. Dump [%d]:", res);
   ArrayPrint(dst, 0, " ", 0, WHOLE_ARRAY, 0);
   
   /* === 4 === */
   ArrayFill(msg, 0, ArraySize(msg), 0); /* cleaning 'msg' to reuse below */

   /* Decrypting */
   res = CryptDecode(CRYPT_AES256, dst, key, msg);
   if(res == 0){
      printf("Decryption error: [%d]", GetLastError());
      return(INIT_FAILED);
   }

   PrintFormat("Decrypted size [%d]. Message: [%s]", res, CharArrayToString(msg));

   return(INIT_SUCCEEDED);
}