---
title: java泛型
date: 2022/4/29 13:53
categories:
- [Java]
tags:
- 编程语言
---
# 泛型

## 什么是泛型

> 泛型我觉得跟C++里的模板差不多，都是一种“代码模板”，可以用一套代码套用各种类型。举个栗子：
> 
> ```java
> public class ArrayList<T> {
>     private T[] array;
>     private int size;
>     public void add(T e) {...}
>     public void remove(int index) {...}
>     public T get(int index) {...}
> }
> ```
> 
> `T`可以是任何class，包括系统的和自己写的，但是不能是基本类型如`int`。
> 
> **java 中泛型标记符：**
> 
> - **E** - Element (在集合中使用，因为集合中存放的是元素)
> - **T** - Type（Java 类）
> - **K** - Key（键）
> - **V** - Value（值）
> - **N** - Number（数值类型）
> - **？** - 表示不确定的 java 类型

> 泛型的向上转型需要注意一下：**可以把`ArrayList<Integer>`向上转型为`List<Integer>`（T不能变！），但不能把`ArrayList<Integer>`向上转型为`ArrayList<Number>`（T不能变成父类）**。廖雪峰老师博客对泛型向上转型的解释是这样的：我们把一个`ArrayList<Integer>`转型为`ArrayList<Number>`类型后，这个`ArrayList<Number>`就可以接受`Float`类型，因为`Float`是`Number`的子类。但是，`ArrayList<Number>`实际上和`ArrayList<Integer>`是同一个对象，也就是`ArrayList<Integer>`类型，它不可能接受`Float`类型， 所以在获取`Integer`的时候将产生`ClassCastException`。

## 泛型的使用

> 使用泛型时需要定义泛型类型是s什么，不然编译器会警告。
> 
> ```java
> // 无编译器警告:
> List<String> list = new ArrayList<String>();
> list.add("Hello");
> list.add("World");
> // 无强制转型:
> String first = list.get(0);
> String second = list.get(1);
> ```
> 
> 定义成什么类型就往<>里加什么类型。

## 泛型接口

> 我们可以在接口中使用泛型。例如，例如，`Arrays.sort(Object[])`可以对任意数组进行排序，但待排序的元素必须实现`Comparable<T>`这个泛型接口：
> 
> ```
> public interface Comparable<T> {
>     /**     * 返回负数: 当前实例比参数o小     * 返回0: 当前实例与参数o相等     * 返回正数: 当前实例比参数o大     */
>     int compareTo(T o);
> }
> ```

> 可以直接对`String`数组进行排序:
> 
> ```java
> public class Main {
>     public static void main(String[] args) {
>          String[] ss = new String[] { "Orange", "Apple", "Pear" };
>         Arrays.sort(ss);
>         System.out.println(Arrays.toString(ss));
>     }
> }
> ```

> 这里能编译成功是因为`String`本身已经实现了`Comparable<String>`接口。如果换成我们自定义的`Person`类型试试：
> 
> ```java
> public class Main {
>     public static void main(String[] args) {
>         Person[] ps = new Person[] {
>             new Person("Bob", 61),
>             new Person("Alice", 88),
>             new Person("Lily", 75),
>         };
>         Arrays.sort(ps);
>         System.out.println(Arrays.toString(ps));
> 
>     }
> }//Person是自定义的类，没有实现Comparable<String>接口
> ```

> 这里没有实现`Comparable<T>`所有会报错，如果实现的话就不会报错了。
> 
> **可以在接口中定义泛型类型，实现此接口的类必须实现正确的泛型类型。**

## 编写泛型

> 跟编写平时的类一样，只是把数据类型换成Java泛型标记符。
> 
> ```
> public class Pair<T> {
>     private T first;
>     private T last;
>     public Pair(T first, T last) {
>         this.first = first;
>         this.last = last;
>     }
>     public T getFirst() {
>         return first;
>     }
>     public T getLast() {
>         return last;
>     }
> }
> ```

> 需注意的是，比啊那些泛型类时，泛型类型<T>不能用于静态方法，使用会后报错，但是可以在`static`修饰符后面加一个`<T>`，编译就能通过，不过这里的<T>跟我们需要的<T>已经没关系了。

> 对于静态方法，我们可以单独改写泛型方法，不使用<T>这个标记符就好了
> 
> ```
> public static <K> Pair<K> create(K first, K last) {
>         return new Pair<K>(first, last);
>     }
> ```

## 擦拭法

> 擦拭法是指，虚拟机对泛型其实一无所知，所有的工作都是编译器做的。

例如，我们编写了一个[泛型类](https://so.csdn.net/so/search?q=%E6%B3%9B%E5%9E%8B%E7%B1%BB&spm=1001.2101.3001.7020)Pair，这是编译器看到的代码：

```java
public class Pair<T> {
    private T first;
    private T last;
    public Pair(T first, T last) {
        this.first = first;
        this.last = last;
    }
    public T getFirst() {
        return first;
    }
    public T getLast() {
        return last;
    }
}
```

而虚拟机根本不知道泛型。这是虚拟机执行的代码：

```java
public class Pair {
    private Object first;
    private Object last;
    public Pair(Object first, Object last) {
        this.first = first;
        this.last = last;
    }
    public Object getFirst() {
        return first;
    }
    public Object getLast() {
        return last;
    }
}
```

泛型类型在逻辑上看以看成是多个不同的类型，实际上都是相同的基本类型。

因此，Java使用擦拭法实现泛型，导致了：

- 编译器把类型< T>视为Object；
- 编译器根据< T>实现安全的强制转型。

使用泛型的时候，我们编写的代码也是编译器看到的代码：

```java
Pair<String> p = new Pair<>("Hello", "world");
String first = p.getFirst();
String last = p.getLast();
```

而虚拟机执行的代码并没有泛型：

```java
Pair p = new Pair("Hello", "world");
String first = (String) p.getFirst();
String last = (String) p.getLast();
```

所以，Java的泛型是由编译器在编译时实行的，编译器内部永远把所有类型T视为Object处理，但是，在需要转型的时候，编译器会根据T的类型自动为我们实行安全地强制转型。

了解了Java泛型的实现方式——擦拭法，我们就知道了Java泛型的局限：

- 局限一：< T>不能是基本类型，例如int，因为实际类型是Object，Object类型无法持有基本类型：

```java
Pair<int> p = new Pair<>(1, 2); // compile error!
```

- 局限二：无法取得带泛型的Class。观察以下代码：

```java
public class Main {
    public static void main(String[] args) {
        Pair<String> p1 = new Pair<>("Hello", "world");
        Pair<Integer> p2 = new Pair<>(123, 456);
        Class c1 = p1.getClass();
        Class c2 = p2.getClass();
        System.out.println(c1==c2); // true
        System.out.println(c1==Pair.class); // true
    }
}

class Pair<T> {
    private T first;
    private T last;
    public Pair(T first, T last) {
        this.first = first;
        this.last = last;
    }
    public T getFirst() {
        return first;
    }
    public T getLast() {
        return last;
    }
}
```

- 局限三：无法判断带泛型的类型：

```java
Pair<Integer> p = new Pair<>(123, 456);
// Compile error:
if (p instanceof Pair<String>) {
}
```

- 局限四：不能实例化T类型：

```java
public class Pair<T> {
    private T first;
    private T last;
    public Pair() {
        // Compile error:
        first = new T();
        last = new T();
    }
}
```

上述代码无法通过编译，因为构造方法的两行语句：

```java
first = new T();
last = new T();
```

这样一来，创建new Pair()和创建new Pair()就全部成了Object，显然编译器要阻止这种类型不对的代码。

要实例化T类型，我们必须借助额外的Class< T>参数：

```java
public class Pair<T> {
    private T first;
    private T last;
    public Pair(Class<T> clazz) {
        first = clazz.newInstance();
        last = clazz.newInstance();
    }
}
```

上述代码借助Class< T>参数并通过反射来实例化T类型，使用的时候，也必须传入Class< T>。例如：

```java
Pair<String> pair = new Pair<>(String.class);
```

因为传入了Class的实例，所以我们借助String.class就可以实例化String类型。

> 在定义方法的时候，注意名字与系统自带的方法发生冲突。有些时候，一个看似正确定义的方法会无法通过编译。例如：
> 
> ```
> public class Pair<T> {
>     public boolean equals(T t) {
>         return this == t;
>     }
> }
> ```
> 
> 这是因为，定义的`equals(T t)`方法实际上会被擦拭成`equals(Object t)`，而这个方法是继承自`Object`的，编译器会阻止一个实际上会变成覆写的泛型方法定义。
> 
> 换个方法名，避开与`Object.equals(Object)`的冲突就可以成功编译：
> 
> ```
> public class Pair<T> {
>     public boolean same(T t) {
>         return this == t;
>     }
> }
> ```

> 子类可以获取父类的泛型类型<T>。

## 通配符

### extends和super通配符

使用类似`<? extends Number>`通配符作为**方法参数**时表示：

- 方法内部可以调用获取`Number`引用的方法。

- 方法内部无法调用传入`Number`引用的方法（`null`除外）。无法传入参数

```java
ArrayList<Apple> apples = new ArrayList<>();
apples.add(new Apple());
ArrayList<? extends Fruit> fruits = apples;
// 如果方法的返回值是泛型，可以正常使用
Fruit fruit = fruits.get(0);
// 如果方法参数含有泛型参数，在编译器就会报错
// fruits.add(new Fruit());
// 方法参数不含有泛型参数，可以正常使用
fruits.remove(0);
```

使用类似`<T extends Number>`定义泛型类时表示：

- 泛型类型限定为`Number`以及`Number`的子类。

使用`<T super Integer>`定义泛型类时表示:

- 泛型类型限定为`Integer`或者`Integer`的父类

**<? extends T>和<? super T>的区别**

- <? extends T>表示该通配符所代表的类型是T类型的子类。
- 表示该通配符所代表的类型是T类型的父类。

使用`<? super Integer>`通配符表示：

- 允许调用`set(? super Integer)`方法传入`Integer`的引用；

- 不允许调用`get()`方法获得`Integer`的引用。
  
  刚好跟extends相反

当使用`<? super T>`通配符定义一个变量，这个变量中所有返回值是泛型的方法都会变成返回Object

```java
ArrayList<Fruit> fruits = new ArrayList<>();
fruits.add(new Apple());
ArrayList<? super Apple> apples = fruits;
// 返回值是泛型的方法只会返回Object类型
Object object = apples.get(0);
// 但是添加没有问题, 可以添加的类型需要时apple及其子类
apples.add(new Apple());
apples.add(new RedApple());
apples.add(new GreenApple());
// apples.add(new Fruit()); // 父类无法添加
```

作为**方法参数**，`<? extends T>`类型和`<? super T>`类型的区别在于：

- `<? extends T>`允许调用读方法`T get()`获取`T`的引用，但不允许调用写方法`set(T)`传入`T`的引用（传入`null`除外）；

- `<? super T>`允许调用写方法`set(T)`传入`T`的引用，但不允许调用读方法`T get()`获取`T`的引用（获取`Object`除外）。

一个是允许读不允许写，另一个是允许写不允许读。

### ?通配符

我们知道`Ingeter`是`Number`的一个子类，并且`Generic<Ingeter>`与`Generic<Number>`实际上是相同的一种基本类型。那么问题来了，在使用`Generic<Number>`作为形参的方法中，能否使用`Generic<Ingeter>`的实例传入呢？在逻辑上类似于`Generic<Number>`和`Generic<Ingeter>`是否可以看成具有父子关系的泛型类型呢？

为了弄清楚这个问题，我们使用`Generic<T>`这个泛型类继续看下面的例子：

```java
public void showKeyValue1(Generic<Number> obj){
 Log.d("泛型测试","key value is " + obj.getKey());
}
```

```java
Generic<Integer> gInteger = new Generic<Integer>(123);
Generic<Number> gNumber = new Generic<Number>(456);
showKeyValue(gNumber);

// showKeyValue这个方法编译器会为我们报错：Generic<java.lang.Integer> 
// cannot be applied to Generic<java.lang.Number>
// showKeyValue(gInteger);
```

通过提示信息我们可以看到`Generic<Integer>`不能被看作为`` `Generic<Number> ``的子类。由此可以看出:同一种泛型可以对应多个版本（因为参数类型是不确定的），不同版本的泛型类实例是不兼容的。

回到上面的例子，如何解决上面的问题？总不能为了定义一个新的方法来处理`Generic<Integer>`类型的类，这显然与java中的多台理念相违背。因此我们需要一个在逻辑上可以表示同时是`Generic<Integer>`和`Generic<Number>`父类的引用类型。由此类型通配符应运而生。

我们可以将上面的方法改一下：

```java
public void showKeyValue1(Generic<?> obj){
 Log.d("泛型测试","key value is " + obj.getKey());
}
```

类型通配符一般是使用`?`代替具体的类型实参，注意了，此处`?`是类型实参，而不是类型形参 。重要说三遍！此处`?`是类型实参，而不是类型形参 ！ 此处`?`是类型实参，而不是类型形参 ！再直白点的意思就是，此处的`?`和Number、String、Integer一样都是一种实际的类型，可以把`?`看成所有类型的父类。**是一种真实的类型**。

可以解决当具体类型不确定的时候，这个通配符就是`?`；当操作类型时，不需要使用类型的具体功能时，只使用Object类中的功能。那么可以用`?`通配符来表未知类型。

## 泛型数组

这样写是错误的，Java中无法创建一个确切的泛型类型的数组。

`List<String>[] ls = new ArrayList<String>[10];`

使用通配符创建泛型数组是可以的，如下面这个例子：

`List<?>[] ls = new ArrayList<?>[10];`

这样也是可以的:

`List<String>[] ls = new ArrayList[10];`

如果使用第一种写法：

```java
//第一种写法
List<String>[] lsa = new List<String>[10]; // Not really allowed.    
Object o = lsa;    
Object[] oa = (Object[]) o;    
List<Integer> li = new ArrayList<Integer>();    
li.add(new Integer(3));    
oa[1] = li; // Unsound, but passes run time store check    
String s = lsa[1].get(0); // Run-time error: ClassCastException.
```

这种情况下，由于JVM泛型的擦除机制，在运行时JVM是不知道泛型信息的，所以可以给oa[1]赋上一个ArrayList而不会出现异常，  

但是在取出数据的时候却要做一次**类型转换**，所以就会出现ClassCastException，如果可以进行泛型数组的声明，这里的话是因为第一行会因为jvm无法识别出`List<String>`里面的`String`类型，而是把它看成Object类，所有后面转换会出现问题，不知道这样理解对不对。

上面说的这种情况在编译期将不会出现任何的警告和错误，只有在运行时才会出错。
而对泛型数组的声明进行限制，对于这样的情况，可以在编译期提示代码有类型安全问题，比没有任何提示要强很多。

可以看看[Sun文档](https://docs.oracle.com/javase/tutorial/extra/generics/fineprint.html)对这些内容的解释。

## 泛型我也很多没理解，后续用到再学！

参考自廖雪峰老师博客:[什么是泛型 - 廖雪峰的官方网站 (liaoxuefeng.com)](https://www.liaoxuefeng.com/wiki/1252599548343744/1265102638843296)
