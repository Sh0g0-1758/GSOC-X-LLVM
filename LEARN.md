# LEARN CPP internals

Some cpp internals that I learn along the way : 

1. **virtual Keyword** : In general, an object of derived class with a pointer of base class will run functions of the base class. But if you add a virtual keyword in front of any function then no matter what the pointer, the function corresponding to the object will be called. Further a class is called abstract if it has at least one pure virtual function. The syntax for it is : `virtual void foo() = 0;`, the main point to note here is the assignment to 0 in the declaration. 

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

2. **Interfaces** : There is **no** builtin concept of interfaces in C++. We just call an abstract class with only pure virtual functions an interface. Further a derived class that inherits an interface/abstract class must implement all its pure virtual methods, else it becomes an abstract class And we can not make an object of an abstract class. The main benefit here is the fact that we can use the pointer of the interface/abstract class to access methods of all the derived classes. And since the methods are virtual, the definition in those specific classes will be used. 

*Example* : 

```cpp
// An example of an interface (all methods are pure virtual)
class shogo {
    public:
    virtual void guess() = 0;
    virtual void really() = 0;
};

class ora : public shogo {
    public:
    void guess() {
        cout << "really" << endl;
    }
    void really() {
        cout << "no!" << endl;
    }
}

// Similar class names orewa here
// class orewa {
//      ...
// };

int main() {
    shogo* ptr;
    ora obj1;
    ptr = &obj1;
    // guess for ora
    ptr->guess();
    orewa obj2;
    ptr = &obj2;
    // really for orewa
    ptr->really();
}
```

3. **static Keyword** : Declaring a variable static essentially makes its scope global. Ie. The space for it gets allocated for the lifetime of the program. Also if you were to declare a static variable in a class, each object can not have a separate copy of it. This logically makes sense as we previously saw that static variables gets space allocated only once. Further static functions can be called directly using the class. 

*Example* : 

```cpp

class chan{
    public:
    static int i;
    chan() {
        cout << "Constructor" << endl;
    }

    ~chan() {
        cout << "Destructor" << endl;
    }
};

void shogo() {
    static int cnt = 0;
    cout << cnt << endl;
    cnt++;
}

// Note that to initialize a static variable, we do it outside the class with scope taken from the class
int chan::i = 42;

int main() {
    // Prints 0 1 2 3
    for(int i = 0; i < 4;i++) shogo();

    // Sequence --> 
    // 1. Constructor
    // 2. Destructor (Because scope ends)
    // 3. End
    if (2 > 1) {
        chan ore;
    }

    cout << "End" << endl;

    // Sequence -->
    // 1. Constructor
    // 2. End
    // 3. Destructor (static means kinda making it global, so its scope remains till the end of the program)
    if(3 > 2) {
        static chan orewa;
    }

    cout << "End" << endl;

}
```

4. **final Keyword** : Final basically says that a certain thing when defined is locked and will not be changed again. It can be used to prevent method over-riding and can also prevent inheritance. (Note the position of the keyword, this is to make sure that something like `int final = 10` does not break in existing codebases due to new release)

*Example* : 

```cpp
class Base {
    virtual void call() final {
        cout << "foo" << endl;
    }
}

class der : public Base {
    // Leads to compilation error as call() method was declared final
    void call() {
        cout << "bar" << endl;
    }
}

// Final makes the class inheritable
class dont_inherit final {

};
```

5. **Virtual Inheritance and diamond problem** : The diamond problem occurs when two superclasses of a class have a common base class. As such that common base class's constructor is called twice and in this case the compiler just does not know which instance of the base class was called. Virtual Inheritance basically ensures that only one instance of the base class is ever called. Another way to solve this is using Scope resolution operator `::`. To inherity Virtually, simply add `virtual` keyword before the class to inherit. 

*Example* : 

```cpp
class A { 
public: 
    void show() 
    { 
        cout << "Hello from A \n"; 
    } 
}; 

class B : public A { 
}; 

class C : public A { 
}; 

class D : public B, public C { 
}; 

/*
diamond inheritance =>

        A
        |
    _________
    |       | 
    B       C
    _________
        |
        D
*/

int main() 
{ 
    D object; 
    // Gives Compilation Error
    object.show(); 
    // Works but not really a solution as still 2 instances of A are formed
    object.B::show();
    // Solution is to add virtual like so : 
    // class B : public virtual A  ...
    // class C : public virtual A  ...
} 
```

6. **explicit Keyword** : It ensures that a constructor is called only when an object of that class is explicitly made. It basically restricts conversion of data to objects of the class through a single parameter. 

*Example* : 

```cpp
class Complex {
private:
	double real;
	double imag;

public:
    // Here as we have given initial values, so giving any one value suffices to create an object. 
    // However adding explicit restricts that. Adding Explicit ensures that such conversion only takes
    // place when it is explicitly typecasted.

    // explicit Complex(...) 
	Complex(double r = 0.0, 
			double i = 0.0) : real(r), 
							imag(i)
	{}

	bool operator == (Complex rhs)
	{
		return (real == rhs.real && 
				imag == rhs.imag);
	}
};

int main()
{
	Complex com1(3.0, 0.0);
    // This works and created a Complex object with r = 3.0 and i = 1.0
    // However if the constructor was explicit then we would have to do : 
    // if (com1 == (Complex)3.0)
	if (com1 == 3.0)
		cout << "Same";
	else
		cout << "Not Same";
	return 0;
}
```

7. There are three types of inheritance in cpp : Public , Private and Protected. In Public, each ie. public,private and protected of base class remains as it is in the derived class. In Protected, public and protected becomes protected and in private, all becomes private. While the private variable in the first base class is still not accessible in any of the derived classes. It is just a matter of questionability of how these variables would be treated if we make further derived classes from these derived classes. 

*Example* : 

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
