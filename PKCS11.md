## Setup
1. Build with `make SMARTCARD=1`
2. Install the OpenSSL engine for PKCS#11 (`libengine-pkcs11-openssl` on Debian, part of `libp11`)

## Load Key Into Smartcard
It is recommend that you generate the key on the card itself, but you can import it if needed.

For yubikeys:
1. Extract Cert and Key from p12
```
openssl pkcs12 -in Certificates.p12 -out cert.crt.pem -clcerts -nokeys -legacy
openssl pkcs12 -in Certificates.p12 -out key.pem -nocerts -nodes -legacy
```
2. Import into Key
```
yubico-piv-tool -s 9c -a import-certificate -i cert.crt.pem
yubico-piv-tool -s 9c -a import-key -i key.pem
yubico-piv-tool -s 9c -a set-chuid
```
3. You can use `p11tool --list-privkeys --login` to identify the URI for the slot (make sure that `type` is not in the URI, as seperate URIs for the cert and private key are not currently supported from the command line)

## Sign
1. `ldid -K'pkcs11:model=YubiKey%20YK5;id=%02' -Sents.xml ls.bin`
2. If the correct PKCS#11 module is not being loaded, try setting `PKCS11_MODULE_PATH` in your environment (ex. `export PKCS11_MODULE_PATH="/usr/local/lib/p11-kit-proxy.so"` or `PKCS11_MODULE_PATH="/usr/local/lib/libykcs11.so"`)
