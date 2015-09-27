#ifndef LDID_HPP
#define LDID_HPP

#include <cstdlib>
#include <map>
#include <streambuf>
#include <string>

namespace ldid {

// I wish Apple cared about providing quality toolchains :/

template <typename Function_>
class Functor;

template <typename Type_, typename... Args_>
class Functor<Type_ (Args_...)> {
  public:
    virtual Type_ operator ()(Args_... args) const = 0;
};

template <typename Function_>
class FunctorImpl;

template <typename Value_, typename Type_, typename... Args_>
class FunctorImpl<Type_ (Value_::*)(Args_...) const> :
    public Functor<Type_ (Args_...)>
{
  private:
    const Value_ *value_;

  public:
    FunctorImpl(const Value_ &value) :
        value_(&value)
    {
    }

    virtual Type_ operator ()(Args_... args) const {
        return (*value_)(args...);
    }
};

template <typename Function_>
FunctorImpl<decltype(&Function_::operator())> fun(const Function_ &value) {
    return value;
}

typedef std::map<uint32_t, std::string> Slots;

void Sign(void *idata, size_t isize, std::streambuf &output, const std::string &name, const std::string &entitlements, const std::string &key, const Slots &slots);

}

#endif//LDID_HPP
