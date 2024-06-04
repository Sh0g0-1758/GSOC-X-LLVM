# LEARN

Some cpp internals that I learn along the way

1. virtual keyword allows the derived class to show run time polymorphism on the functions that are declared with that keyword in the base class. 
2. explicit keyword before a constructor means that a constructor is called only when an object of that class is explicitly made. 
3. There are three types of inheritance in cpp : Public , Private and Protected. In Public, each ie. public,private and protected of base class remains as it is in the derived class. In Protected, public and protected becomes protected and in private, all becomes private. While the private variable in the first base class is still not accessible in any of the derived classes. It is just a matter of questionability of how these variables would be treated if we make further derived classes from these derived classes. Example : 

```cpp
class A 
{
    public:
       int x;
    protected:
       int y;
    private:
       int z;
};

class B : public A
{
    // x is public
    // y is protected
    // z is not accessible from B
};

class C : protected A
{
    // x is protected
    // y is protected
    // z is not accessible from C
};

class D : private A    // 'private' is default for classes
{
    // x is private
    // y is private
    // z is not accessible from D
};
```