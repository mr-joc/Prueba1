using Newtonsoft.Json;
using appWebPrueba.Clases;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.ModelBinding;

namespace appWebPrueba.DataAccess
{
    public class Helper
    {
        //////public static readonly string plainText;
        //////public static readonly string passPhrase = @"Claspr@se";
        //////public static readonly string saltValue = "s@1tValue";
        //////public static readonly string hashAlgorithm = "MD5";
        //////public static readonly int passwordIterations = 4;
        //////public static readonly string initVector = "@1B2c3D4e5F6g7H8";
        //////public static readonly int keySize = 256;




        ////////public static string NoEspDecrypt(string cipherText)
        ////////{
        ////////    byte[] initVectorBytes = Encoding.ASCII.GetBytes(initVector);
        ////////    byte[] saltValueBytes = Encoding.ASCII.GetBytes(saltValue);
        ////////    byte[] cipherTextBytes = Convert.FromBase64String(cipherText);
        ////////    PasswordDeriveBytes password = new PasswordDeriveBytes(passPhrase, saltValueBytes, hashAlgorithm, passwordIterations);
        ////////    byte[] keyBytes = password.GetBytes(keySize / 8);
        ////////    RijndaelManaged symmetricKey = new RijndaelManaged();
        ////////    symmetricKey.Mode = CipherMode.CBC;
        ////////    ICryptoTransform decryptor = symmetricKey.CreateDecryptor(keyBytes, initVectorBytes);
        ////////    MemoryStream memoryStream = new MemoryStream(cipherTextBytes);
        ////////    CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read);
        ////////    byte[] plainTextBytes = new byte[cipherTextBytes.Length];
        ////////    int decryptedByteCount = cryptoStream.Read(plainTextBytes, 0, plainTextBytes.Length);
        ////////    memoryStream.Close();
        ////////    cryptoStream.Close();
        ////////    string plainText = Encoding.UTF8.GetString(plainTextBytes, 0, decryptedByteCount);
        ////////    return plainText;
        ////////}



        ////public static Dictionary<string, string> JsonToDictionary(string Cadena)
        ////{
        ////    return JsonConvert.DeserializeObject<Dictionary<string, string>>(Cadena);
        ////}





    }
}