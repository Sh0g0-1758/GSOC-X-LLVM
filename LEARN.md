# LEARN CPP internals

Some cpp internals that I learn along the way : 

1. **virtual keyword** : In general, an object of derived class with a pointer of base class will run functions of the base class. But if you add a virtual keyword in front of any function then no matter what the pointer, the function corresponding to the object will be called. 

*Example* : 

```cpp
class Base {
public:
	virtual void show() { cout << "In Base \n"; }
};

class Derived : public Base {
public:
	void show() { cout << "In Derived \n"; }
};

int main(void)
{
	Base* bp = new Derived();
    // prints In Derived
	bp->show();

    bp = new Base();
    // prints In Base
    bp->show();

	return 0;
}
```

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