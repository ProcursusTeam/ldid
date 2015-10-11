#ifndef LDID_HPP
#define LDID_HPP

#include <cstdlib>
#include <map>
#include <sstream>
#include <streambuf>
#include <string>
#include <vector>

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

class Folder {
  public:
    virtual void Save(const std::string &path, const Functor<void (std::streambuf &)> &code) = 0;
    virtual bool Open(const std::string &path, const Functor<void (std::streambuf &)> &code) = 0;
    virtual void Find(const std::string &path, const Functor<void (const std::string &, const Functor<void (const Functor<void (std::streambuf &, std::streambuf &)> &)> &)> &code) = 0;
};

class DiskFolder :
    public Folder
{
  private:
    const std::string path_;
    std::map<std::string, std::string> commit_;

    std::string Path(const std::string &path);

    void Find(const std::string &root, const std::string &base, const Functor<void (const std::string &, const Functor<void (const Functor<void (std::streambuf &, std::streambuf &)> &)> &)>&code);

  public:
    DiskFolder(const std::string &path);
    ~DiskFolder();

    virtual void Save(const std::string &path, const Functor<void (std::streambuf &)> &code);
    virtual bool Open(const std::string &path, const Functor<void (std::streambuf &)> &code);
    virtual void Find(const std::string &path, const Functor<void (const std::string &, const Functor<void (const Functor<void (std::streambuf &, std::streambuf &)> &)> &)> &code);
};

class SubFolder :
    public Folder
{
  private:
    Folder &parent_;
    std::string path_;

  public:
    SubFolder(Folder &parent, const std::string &path);

    virtual void Save(const std::string &path, const Functor<void (std::streambuf &)> &code);
    virtual bool Open(const std::string &path, const Functor<void (std::streambuf &)> &code);
    virtual void Find(const std::string &path, const Functor<void (const std::string &, const Functor<void (const Functor<void (std::streambuf &, std::streambuf &)> &)> &)> &code);
};

class UnionFolder :
    public Folder
{
  private:
    class StringBuffer :
        public std::stringbuf
    {
      public:
        StringBuffer() {
        }

        StringBuffer(const StringBuffer &rhs) :
            std::stringbuf(rhs.str())
        {
        }
    };

    Folder &parent_;
    std::map<std::string, StringBuffer> files_;

  public:
    UnionFolder(Folder &parent);

    virtual void Save(const std::string &path, const Functor<void (std::streambuf &)> &code);
    virtual bool Open(const std::string &path, const Functor<void (std::streambuf &)> &code);
    virtual void Find(const std::string &path, const Functor<void (const std::string &, const Functor<void (const Functor<void (std::streambuf &, std::streambuf &)> &)> &)> &code);

    std::stringbuf &operator [](const std::string &path) {
        return files_[path];
    }
};

std::string Bundle(const std::string &root, Folder &folder, const std::string &key, std::map<std::string, std::vector<char>> &remote, const std::string &entitlements);

typedef std::map<uint32_t, std::vector<char>> Slots;

void Sign(const void *idata, size_t isize, std::streambuf &output, const std::string &identifier, const std::string &entitlements, const std::string &key, const Slots &slots);

}

#endif//LDID_HPP
