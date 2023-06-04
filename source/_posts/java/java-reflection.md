---
title: java反射
date: 2022/4/28 20:07
categories:
- [Java]
tags:
- 编程语言
---
# java反射

## 什么是反射

> java反射就是指程序在运行期就可以拿到一个对象的所以信息。反射机制能不通过创建对象实例就调用该对象的方法或者访问该对象的字段。 

## Class类

> 首先我们要明白`class`（包括`interface`）的本质是数据类型，没有继承关系的数据类型是没有办法赋值的。`double`的对象不能给`String`的对象赋值，而`double`的对象可以给`number`对象赋值。`number`是java中的一个抽象类。

> 其次就是class是由JVM在执行过程中动态加载的，就是第一次读取到这种`class`类型时，将它加载到内存中。每加载一种class，JVM就为它创建一个`Class`类型的实例，并且关联起来。

 这里所说的`Class`类是什么东西呢？

它与其他类不太一样：

```java
public final class Class{
    privateClass(){}
}
```

举个🌰: 当JVM加载`String`类的时候，它首先读取`String.class`文件到内存中，然后为`String`类建立一个`Class`对象关联起来

```java
Class cls = new Class(String);
```

`Class`获取方法后面会写到，有好几种。

`Class`实例是JVM内部创建，我们的Java程序是无法创建`Class`对象的。

所以，JVM持有的每个`Class`实例都指向一个数据类型（`class`或`interface`）:

**一个`Class`实例包含了该class的所有完整信息：**


> JVM为每个加载的`class`实例创建对应的`Class`实例，并在实例中保存了所以信息，包括类名、包名、父类、实现的接口、所以方法、字段等等，所以我们获取到一个`Class`实例就可以通过这个`Class`实例获取对应到的`class`的所以信息，这种通过`Class`实例获取`class`信息的方法就叫做**反射**。

## 如何获取一个class的Class实例

- 直接通过一个class的静态变量class获取：
  
  ```java
  Class cls = string.class;
  ```

- 如果已经有一个实例变量了，可以通过这个实例变量的`getClass()`方法获取`Class`实例：
  
  ```java
  String s = "xjm";
  Class cls = s.getClass();
  ```

- 如果知道一个`class`的完整类名，可以通过静态方法`Class.forName()`获取：
  
  ```java
  Class cls = Class.forName("java.lang.String");
  ```

**这里对`Class.forName()`说明一下，使用这个方法需要捕获异常**

> 前面说过每个数据类型（class 或 interface）对应唯一一个Class实例，所以上面三种方法获取的都是同一个实例。

## 如何从Class中获取我们想要的各种信息

前面提到过，对于任意的一个`Obeject`实例，我们有它的`Class`，就能获取它的一切信息。

#### 获取Class中的基本信息

> 我们可以使用很多种方法去获取：
> 
> - getName()：获取该Class对应的类名，全限定名。
> 
> - getSimpleName()：获取它的类型名，如果是`String`的话它的全限定名是`java.lang.String`，而使用这个方法返回的是`String`
> 
> - getPackage()：返回包名。我们可以在后面再加一个方法`getName()`这样就直接返回的是它的包名，不用跟用就是多一个package的单词。
> 
> - isInterface()：布尔值，判断是不是接口。
> 
> - isEnum()：布尔值，判断是不是枚举类型。
> 
> - isArray()：布尔值，判断是不是数组。
> 
> - isPrimitive()：布尔值，判读Class是不是原始类型（boolean、char、byte、short、int、long、float、double）

#### 获取字段信息

> field：成员变量，一个field只能存一个字段。
> 
> 使用这些方法都需要捕获异常。

 `Class`类提供了以下几种方法获取字段：

> - Field getField(name)：根据字段名获取某个public的field（包括父类）
> 
> - Field getDeclaredField(name)：根据字段名获取，某个当前类的某个field（不包括父类）
> 
> - Field[]
>   getFields()：获取所有public的field（包括父类）
> 
> - Field[] getDeclaredFields()：获取当前类的所有field（不包括父类）

一个Field对象包含了一个字段的所有信息：

> - getName()：返回字段名称,即你要查找的字段。返回类型如`“name”`;
> 
> - getType()：返回字段类型，也是一个Class实例，如`String.class`；
> 
> - getModifiers()：返回字段的修饰符，它是一个int类型，不同的数字表示不同的含义；
>   
>   Modifier类 (修饰符工具类) 位于 java.lang.reflect 包中，用于判断和获取某个类、变量或方法的修饰符
>   
>   | 修饰符          | 对应的int类型 |
>   | ------------ | -------- |
>   | public       | 1        |
>   | private      | 2        |
>   | protected    | 4        |
>   | static       | 8        |
>   | final        | 16       |
>   | synchronized | 32       |
>   | volatile     | 64       |
>   | transient    | 128      |
>   | native       | 256      |
>   | interface    | 512      |
>   | abstract     | 1024     |
>   | strict       | 2048     |

举个🌰测试一下:

```java
import java.lang.reflect.Field;

public class text {
    public static void main(String[] args) {
        Student stu1 = new Student(100,"一年四班","王小明");
        //获取Student.class的Class实例
        Class Stu1 = Student.class;

        //获取方法二
        Class Stu2 = stu1.getClass();

        //获取方法三
        //用forName()跟下面的这些方法得要捕获异常
        try {
            Class Stu3 = Class.forName("Student");
        }catch (Exception e){
            System.out.println("error");
        }
        try{
            //获取包括父类的field
            Field f = Stu1.getField("name");
            System.out.println(f);
            //这里需要用Object
            //这几个方法来测试一下
            Object value1 = f.getName();
            Object value2 = f.getType();
            Object value3 = f.getModifiers();
            //用get()方法拿到对象的值
            Object value99 = f.get(stu1);

            System.out.println(value1);
            System.out.println(value2);
            System.out.println(value3);
            System.out.println(value99);

            //这个方法是不能获取到父类的,因为name是父类Person的字段
            // 执行的话会被捕获到异常
//            Field g = Stu1.getDeclaredField("name");
//            System.out.println(g);

            //再来测试一下其他的字段
            Field k = Stu1.getDeclaredField("clr");
            System.out.println(k);
            Object value4 = k.getName();
            System.out.println(value4);
            //这里要是不加下面这行代码会报错
            //因为clr是private的，不能随便访问
            k.setAccessible(true);
            Object value98 = k.get(stu1);
            System.out.println(value98);

            //获取所有public的field（包括父类）
            //测试结果中没有clr，因为它是private的
            Field[] h = Stu1.getFields();
            for (Field i : h){
                System.out.println(i);
            }

            //获取当前类的所有field（不包括父类）
            //由测试结果可以知道确实是不包括父类
            Field[] j = Stu1.getDeclaredFields();
            for (Field i : j){
                System.out.println(i);
            }
        }catch (Exception ee){
            System.out.println("error");
        }

    }
}

class Student extends Person{
    public int score;
    private String clr;

    public Student(int score,String clr,String name) {
        this.score = score;
        this.clr = clr;
        this.name = name;
    }
}

class Person{
    public String name;

    public Person(String name) {
        this.name = name;
    }

    public Person() {
    }
}
tring name) {
        this.name = name;
    }

    public Person() {
    }
}
```

有一行代码:

`k.setAccessible(true);`

要是不加这行的话会报这个错：

![]([IMG]https://raw.githubusercontent.com/Xunop/images/main/2022-04-16-16-58-55-image.png[/IMG])

对它的解释是：不管这个字段是不是public，一律允许访问。此外，`setAccessible(true)`可能会失败。如果JVM运行期存在`SecurityManager`，那么它会根据规则进行检查，有可能阻止`setAccessible(true)`。例如，某个`SecurityManager`可能不允许对`java`和`javax`开头的`package`的类调用`setAccessible(true)`，这样可以保证JVM核心库的安全。

#### 设置字段值

通过field可以获取指定实例的字段值，那必然也可以设置字段值。

设置字段值通过`Field.set(Object, Object)`实现，其中第一个`Object`参数是指定的实例，第二个`Object`参数是待修改的值。

可以这样改：

`f.set(stu1, "王大明");`

改之后stu1这个对象就叫王大明了。

如果修改非`public`字段，仍需要首先调用`setAccessible(true)`。

#### 调用方法

通过`Class`实例获取所有`Field`对象，同样的，可以通过`Class`实例获取所有`Method`信息。`Class`类提供了以下几个方法来获取`Method`：

- `Method getMethod(name, Class...)`：获取某个`public`的`Method`（包括父类）后面这个Class是类型，如果方法是int类型，就用int.class
- `Method getDeclaredMethod(name, Class...)`：获取当前类的某个`Method`（不包括父类）
- `Method[] getMethods()`：获取所有`public`的`Method`（包括父类）
- `Method[] getDeclaredMethods()`：获取当前类的所有`Method`（不包括父类）

其中，一个Method对象包含一个方法的所有信息：

- getName()：返回方法名称，例如："getScore"；
- getReturnType()：返回方法**返回值类型**，也是一个Class实例，例如：String.class；
- getParameterTypes()：返回方法的参数类型，是一个Class数组，例如：{String.class, int.class}；
- getModifiers()：返回方法的修饰符，它是一个int，不同的bit表示不同的含义。应该跟前面给出的那个表一样。

>  那么我们如何调用对象的方法呢？我们需要对Method实例调用`invoke()`这个方法，在这个方法中，需要用到两个参数，第一个参数是**对象实例**，即需要调用方法的对象，第二个是方法需要用到的参数。详细情况看代码：
> 
> ```java
> //待写
> ```

这里来理一下调用方法的步骤：

1. 得到类的Class，使用前面说的那三种方法。

2. 得到调用类中的Method对象。上面写的一堆方法中。

3. 对Method实例调用invoke()方法，注意传的什么参数。

##### 调用静态方法

> 只要把invoke()方法中的第一个参数改为null就好了。

##### 调用非public方法

> 和上面所说的Field类似，对于非public方法，我们没有访问权限，虽然可以通过`Class.getDeclaredMethod()`获取该方法实例，但直接对其调用将得到一个IllegalAccessException。为了调用非public方法，我们通过`Method.setAccessible(true)`允许其调用：
> 
> 此外，setAccessible(true)可能会失败。如果JVM运行期存在SecurityManager，那么它会根据规则进行检查，有可能阻止setAccessible(true)。例如，某个SecurityManager可能不允许对java和javax开头的package的类调用setAccessible(true)，这样可以保证JVM核心库的安全。

#### 调用构造方法

我们通常使用`new`操作符创建新的实例：

```
Person p = new Person();
```

如果通过反射来创建新的实例，可以调用Class提供的newInstance()方法：

```
Person p = Person.class.newInstance();
```

但是这样有个问题，它只能调用该类的public无参数构造方法。如果构造方法带有参数，或者不是public，就无法直接通过Class.newInstance()来调用。

下面将写如何调用任意的构造方法。

Java的反射API提供了Constructor对象，它**包含一个构造方法的所有信息**，可以创建一个实例。Constructor对象和Method非常类似，不同之处仅在于它是一个构造方法，并且，调用结果总是返回实例：

```java
//待写
```

通过Class实例获取Constructor的方法如下：

- `getConstructor(Class...)`：获取某个`public`的`Constructor`；
- `getDeclaredConstructor(Class...)`：获取某个`Constructor`；
- `getConstructors()`：获取所有`public`的`Constructor`；
- `getDeclaredConstructors()`：获取所有`Constructor`。

> 同样调用非public的构造方法时，需要`setAccessible(true)`设置允许访问。`setAccessible(true)`可能会失败。

#### 获取继承关系

##### 获取父类 的Class

对Class实例调用这个方法：

`getSuperclass();`

##### 获取实现interface

对Class实例调用这个方法：

`getInterfaces();`

要特别注意：`getInterfaces()`只返回当前类直接实现的接口类型，并不包括其父类实现的接口类型

如果一个类没有实现任何`interface`，那么`getInterfaces()`返回空数组。

##### 继承关系

当我们判断一个实例是否是某个类型时，正常情况下，使用`instanceof`操作符：

```
Object n = Integer.valueOf(123);
boolean isDouble = n instanceof Double; // false
boolean isInteger = n instanceof Integer; // true
boolean isNumber = n instanceof Number; // true
boolean isSerializable = n instanceof java.io.Serializable; // true
```

如果是两个`Class`实例，要判断一个向上转型是否成立，可以调用`isAssignableFrom()`：

```
// Integer i = ?
Integer.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Integer
// Number n = ?
Number.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Number
// Object o = ?
Object.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Object
// Integer i = ?
Integer.class.isAssignableFrom(Number.class); // false，因为Number不能赋值给Integer
```

因为最近在学C++，所以发现这个向上转型跟c++里的赋值兼容规则很像，不知道是不是一个意思。赋值兼容规则：

> - 派生类的对象可以赋值给基类对象。
> 
> - 派生类的对象可以初始化基类的引用。
> 
> - 派生类对象的地址可以赋给指向基类的指针。

通过`Class`对象可以获取继承关系：

- `Class getSuperclass()`：获取父类类型；
- `Class[] getInterfaces()`：获取当前类实现的所有接口。

#### 动态代理

这玩意我看了挺久的，有点难理解。

先上代码：

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class Main {
    public static void main(String[] args) {
        //创建InvocationHandler对象，重写里面的invoke()方法
        //作用是
        InvocationHandler handler = new InvocationHandler() {
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                //这里做一个对invoke()传参数的解释：
                //proxy，代理后的实例对象。 method，对象被调用方法。args，调用时的参数
                //然后这里args[]传数组,第一个元素是接口中中要实现方法的第一个参数，第二个元素是第二个参数
                //比如这里arg[0]就是第一个参数String name,第二个参数就是int m。
                //当代理对象的原本方法被调用的时候，会重定向到一个方法，
                //这个方法就是InvocationHandler实例里面invoke()定义的内容，同时会替代原本方法的结果返回。
                //相当于在这里面实现接口。
                System.out.println(method);
                if ("Time".equals(method.getName())) {
                    System.out.println(args[1] + " days of fall in love with " + args[0]);
                }
                return null;
            }
        };
        //同样需要三个参数
        //第一个参数就是选用的类加载器,在这里就是用接口类的加载器。
        //第二个参数是被代理的类所实现的接口，这个接口可以是多个，所有用数组。
        Hello hello = (Hello) Proxy.newProxyInstance(
                Hello.class.getClassLoader(),//传入ClassLoader
                new Class[]{Hello.class},// 传入要实现的接口
                handler);// 传入处理调用方法的InvocationHandler
        hello.Time("xjm", 100);
    }
}

interface Hello {
    public void Time(String name, int m);
}
```

我们平时调用一个接口的方法是先把这个接口类实现，然后再创建实例。

动态代理就是不编写实现类然后实现接口的实例。

直接通过JDK提供的一个`Proxy.newProxyInstance()`创建了一个接口对象。这种没有实现类但是在运行期动态创建了一个接口对象的方式，我们称为动态代码。JDK提供的动态创建接口对象的方式，就叫动态代理。

主要看代码里的注释吧。

能力有限，对java反射机制的理解只能这样。
