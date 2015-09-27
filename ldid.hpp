#ifndef LDID_HPP
#define LDID_HPP

#include <cstdlib>
#include <map>
#include <streambuf>
#include <string>

namespace ldid {

typedef std::map<uint32_t, std::string> Slots;

void Sign(void *idata, size_t isize, std::streambuf &output, const std::string &name, const std::string &entitlements, const std::string &key, const Slots &slots);

}

#endif//LDID_HPP
