# LEARN CPP internals

Some cpp internals that I learn along the way : 

1. **virtual Keyword** : In general, an object of derived class with a pointer of base class will run functions of the base class. But if you add a virtual keyword in front of any function then no matter what the pointer, the function corresponding to the object will be called. Further a class is called abstract if it has at least one pure virtual function. The syntax for it is : `virtual void foo() = 0;`, the main point to note here is the assignment to 0 in the declaration. Virtual functions are implemented using V-Table which is basically just a map for all functions marked as virtual so that we can point to the correct function to call at runtime. So there is a little overhead involved in memory to store the pointers in the V table and in time since you will have to traverse through them to actually find the function to which it is pointing to. Also Starting from C++14, there is a keyword `override` which you can append after the function declaration to kind of indicate that it is going to override some virtual function that is present in the base class. 

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

3. **static Keyword** : Declaring a variable static essentially makes its scope local to that particular cpp file. Ie. The space for it gets allocated for the lifetime of the program. Also if you were to declare a static variable in a class, each object can not have a separate copy of it. This logically makes sense as we previously saw that static variables gets space allocated only once. Further static functions can be called directly using the class. Also you cannot call class variables inside a static function because now since the scope of the static function is outside the class, it really does not get an instance of that class anymore.

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

8. **Header Files** : Why do we need header files ? Suppose there is a function declared in one cpp file which you wish to use in another cpp file. So you use it and write a declaration for that function on the top of the second file. Finally you write something like `g++ one.cpp two.cpp` and the declaration of the function is able to find a definition and everything works smoothly. But what if there were 1000 files which had to use that function. Writing a declaration again and again would be very untidy. Enter Header files which essentially is a collection of several declarations used by various cpp files. Further adding `#pragma once` acts as a header guard. It ensures that a header file is included only once in a cpp file. It basically is just a lot cleaner way to write the `#ifndef`, `#define`, `#endif` chain statements. 

8. **Pointers and References** : Pointer is just an integer that stores the value of the address. Type does not matter in pointer. a `null*` pointer would behave the same as an `int*` pointer. The problem only comes when we have to de reference that pointer. That's when types become necessary because then we will have to tell the compiler how many bytes are supposed to be written at that memory address. References are basically just aliases to existing variables. So something like `int& ref = a`. Here ref is a reference and it exists only in our source code. It is not visible in the compiled binary. The main use of references are when you are passing a parameter to a function. So something like : 

```cpp
void fun(int *a) {
    (*a)++;
    // Note the order here. *a++ means that we add 1 to a first and then dereference it which is wrong. 
    // The correct order should be that we first dereference it and then we increase its value. 
}
```

is same as 

```cpp
void fun(int& a) {
    a++;
}
```

And references can not be re assigned. Because later it will read it like if it is assigning a new value to the first variable. 
So something like : 

```cpp
int a = 5;
int b = 8;
int& ref = a;
ref = b;
// This means that a = 8 and b = 8
```

9. **Struct and Class** : There is no difference between them. Just that members in struct are private by default and members in class are public by default. The reason to keep struct in C++ is to have backwards compatibility with C. A class in C++ basically works on the principle that each method of that class gets a instance of that class as an added parameter. So in reality, a class is just a namespace in which we have defined some data values. 

10. **Enums** : They are just fancy way to store integers. Just give a name to a certain value so that you don't have to deal with integers all the time. 

11. **Arrays** : It is always better to create an array on the stack because if you create an array on the heap using the new keyword like : `int *shogo = new int[5]` then it leads to memory indirection since shogo is now pointing to the memory space, it is not the address of the memory space. Also since C++11 there is an inbuilt class of Arrays in C++. Now when you allocate an array on stack, its size needs to be a compile time known constant. 

12. **Strings** : Firstly, strings do not exist in `C`. In C we have `char*` pointers. Further, you dont delete these pointers. The rule of thumb here is that you only delete those things which you have called with new. Also in C++, String is actually a templated version of another class in the STL which is `basic_string`. Also string is present in the `iostream` header file but we still include `string` header file because the overload for the cout operator is present in `string` header file. We can also assign strings as a char array or a char pointer. Since C++14, we have 2 byte and 4 byte strings as well. They are basically written as `char16_t` and `char32_t` pointers. Further there are wide strings which can be 2 byte or 4 byte depending on the compiler. It is written as `wstring`. This was basically done to conform with UTF-16 and UTF-32 unicode transformation format. Also to write multi line sentences in C++, you can append your string with an R.

*Example* : 

```cpp
const char16_t* name = u"shogo";
const char32_t* name2 = U"shogo";
const wchar_t* name3 = L"shogo";
const char* roll = R"shogo
learning
CPP
internals"
```

13. **const Keyword** : Well the const keyword does not actually do much changes in the code, its mostly just there for convenience of the programmer. Also we can use the const keyword for a method in a class, this signifies that you cannot change a class variable inside the method. 

*Example* : 

```cpp
class shogo {
    public:
    int x = 45;
    mutable int y = 34;

    int getX const() {
        x = 67; // This is not allowed since the function is declared as constant now
        y = 42; // This is allowed since y is declared as mutable here
        return x;
    }
};

const int* a = new int(32); // Means that the pointer can not be assigned a different value
int const* a = new int(32); // Same functionality as above
int* const a = new int(32); // Means that the pointer can not be reassigned to point to a different address

```
