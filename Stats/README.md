# Stats

There are just a lot of stats in LLVM and there is no proper documentation for beginners to get to know what each stat means. This is meant to be a comprehensive list explaining each stat emitted so that new developers can better understand what they mean. 

| Stats |  Meaning | Unit | Which is Better |
|:-----:|:---------:|:---:|:---------------:|
| **Number of MayAlias results** | A may-alias analysis result report that two variable pointers p and q might refer to the same memory location.  | aa | _Less is Better_ |
| **Number of MustAlias results**   |  A must-alias analysis result report that two variable pointers p and q must refer to the same memory location. | aa | _More is Better_ |
| **Number of NoAlias results** | A no-alias analysis results report that two variable pointers p and q must not refer to the same memory location. | aa | _More is Better_ |
| **Number of times a GEP is decomposed** |  | basicaa | |


# Resources

A compilation of resources that I read to make this table. 

1. https://mukulrathi.com/create-your-own-programming-language/llvm-ir-cpp-api-tutorial/
2. https://www.cs.cornell.edu/courses/cs6120/2020fa/lesson/9/
3. https://blog.yossarian.net/2020/09/19/LLVMs-getelementptr-by-example
4. 
