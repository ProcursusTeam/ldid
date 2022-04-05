export LDID_VERSION=2.1.5
make -j$(sysctl -n hw.ncpu) \
    CFLAGS="-Os -I/Users/emilroselevy/Documents/tmp/ldid/libs/opt/procursus/include -flto=thin" \
    CXXFLAGS="${CFLAGS} -std=c++11" \
    VERSION="${LDID_VERSION}" \
    LIBS="/Users/emilroselevy/Documents/tmp/ldid/libs/opt/procursus/lib/libcrypto.a /Users/emilroselevy/Documents/tmp/ldid/libs/opt/procursus/lib/libplist-2.0.a"


export OPENSSL_MODULES=/opt/homebrew/Cellar/openssl@3/3.0.2/lib/ossl-modules
export OPENSSL_ENGINES=/opt/homebrew/Cellar/openssl@3/3.0.2/lib/engines-3
