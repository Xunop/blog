---
title: java多线程
cover: https://cos.asuka-xun.cc/blog/assets/java_thread.jpg
date: 2022/7/3 15:00
categories:
- [Java]
tags:
- 编程语言
---

可以去了解一下什么是并发和并行及进程与多线程。

[并发和并行 ](https://asuka-xun.cc/2022/06/29/java/concurrent_parallel/)
<!-- more -->

[进程与线程](https://asuka-xun.cc/2022/06/26/java/process/)

Java语言内置了多线程支持：一个Java程序实际上是一个JVM进程，JVM进程用一个主线程来执行`main()`方法，在`main()`方法内部，我们又可以启动多个线程。此外，JVM还有负责垃圾回收的其他工作线程等。

因此，对于大多数Java程序来说，我们说多任务，实际上是说如何使用**多线程**实现多任务。

## 创建新线程

Java语言内置了多线程支持。当Java程序启动的时候，实际上是启动了一个JVM进程，然后，JVM启动主线程来执行`main()`方法。在`main()`方法中，我们又可以启动其他线程。**推荐使用`Runable()`。**

要创建一个新线程非常容易，我们需要实例化一个`Thread`实例，然后调用它的`start()`或者使用下方代码块提供的其他两种方法。

```java
public static void main(String[] args) {
        Thread t = new Thread();
        t.start(); // 启动新线程
    }
```

```java
public class CreatThread {
    public static void main(String[] args) throws InterruptedException {
        System.out.println("线程main启动");
        // 方法一
        Thread thread = new MyThread();
        // 方法二 (推荐使用)
        Thread thread1 = new Thread(new MyRunnable());
        // 方法三 lambda
        Thread thread2 = new Thread(() -> {
            System.out.println("线程thread启动");
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
            }
            System.out.println("thread end...");
        });
        // 启动新线程
        thread.start();
        thread1.start();
        thread2.start();
        // 线程休眠 单位为毫秒
        Thread.sleep(1000);
        System.out.println("main end...");
    }
}

// 方法一
class MyThread extends Thread {
    @Override
    public void run() {
        System.out.println("线程thread已启动");
        System.out.println("thread end...");
    }
}

// 方法二
class MyRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println("线程thread已启动");
    }
}

```

我们无法确定线程`main`启动之后会先输出哪个，但是我给`main`线程休眠了1秒，所以`main end...`会是最后输出。

需要注意：

> 直接调用`run()`方法，相当于调用了一个普通的Java方法，当前线程并没有任何改变，也不会启动新线程。上述代码实际上是在`main()`方法内部又调用了`run()`方法，打印`hello`语句是在`main`线程中执行的，**没有任何新线程被创建**。
>
> **必须调用`Thread`实例的`start()`方法才能启动新线程**，如果我们查看`Thread`类的源代码，会看到`start()`方法内部调用了一个`private native void start0()`方法，`native`修饰符表示这个方法是由JVM虚拟机内部的C代码实现的，不是由Java代码实现的。

### Callable

如果我们的线程需要**返回一个值**，我们需要使用另一个接口`Callable`。和`Runnable`接口比，它多了一个返回值。

```java
class Task implements Callable<String> {
    @Override
    public String call() throws Exception {
        return "test";
    }
}
```

```java
ExecutorService executor = Executors.newFixedThreadPool(5); 
// 定义任务:
Callable<String> task = new Task();
// 提交任务并获得Future:
Future<String> future = executor.submit(task);
// 从Future获取异步执行返回的结果:
String result = future.get(); // 可能阻塞
```

返回结果是什么类型就写什么类型。获取到future对象之后，可以调用`get()`方法获得异步执行的结果。在调用`get()`时，如果异步任务已经完成，我们就直接获得结果。如果异步任务还没有完成，那么`get()`会阻塞，直到任务完成后才返回结果。

一个`Future<V>`接口表示一个未来可能会返回的结果，它定义的方法有：

- `get()`：获取结果（可能会等待）
- `get(long timeout, TimeUnit unit)`：获取结果，但只等待指定的时间，超过会报错然后结束线程；
- `cancel(boolean mayInterruptIfRunning)`：取消当前任务；
- `isDone()`：判断任务是否已完成。

### CompletableFuture

因为当调用future的get()方法时,当前主线程是堵塞的，这不太合理，可能在某些场景不太适用。于是Java提供了`CompletableFuture`改善这问题。`CompletableFuture`通过回调的方式计算处理结果，并且提供了函数式编程能力，让代码更美观。

`CompletableFuture`源码中有四个静态方法用来执行异步任务:

```java
// 四种创建任务方式

public static <U> CompletableFuture<U> supplyAsync(Supplier<U> supplier){..}

public static <U> CompletableFuture<U> supplyAsync(Supplier<U> supplier,Executor executor){..}

public static CompletableFuture<Void> runAsync(Runnable runnable){..}

public static CompletableFuture<Void> runAsync(Runnable runnable,
Executor executor){..}
```

显然Run开头的没有返回值，因为`Runable()`接口并不提供返回值。

执行异步任务：

```java
CompletableFuture<Integer> test = CompletableFuture.supplyAsync(() -> {
            System.out.println("执行");
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            return 999;
        });
```

返回值，我们可以利用以下这几个方法获取执行结果：

```java
V get();
V get(long timeout,Timeout unit);
T getNow(T defaultValue);
T join();
```

`get()` 获取执行结果，但是会使当前线程堵塞，如果执行线程一直没有返回数据，`get()`会一直等待下去。

第二个`get(long timeout,Timeout unit)`，可以自己设置等待时间，超过等待时间会报错`TimeoutException – if the wait timed out`，然后结束线程。

`getNow(T defaultValue)`表示当有了返回结果时会返回结果，如果异步线程抛了异常会返回自己设置的默认值。

`join()`返回结果。如果异步线程抛出异常则它抛出` CompletionException`异常。源码中说抛出以下这两种异常

```java
CancellationException – if the computation was cancelled
CompletionException – if this future completed exceptionally or a completion computation threw an exception
```

#### thenAccept()

**功能**:当前任务正常完成以后执行,当前任务的执行结果可以作为下一任务的输入参数,无返回值.

```java
    public static void main(String[] args) {
        CompletableFuture<String> futureA = CompletableFuture.supplyAsync(() -> "任务A");
        CompletableFuture<String> futureB = CompletableFuture.supplyAsync(() -> "任务B");

        CompletableFuture<Void> futureC = futureB.thenAccept(System.out::println);
    }
```

执行任务A,同时异步执行任务B,待任务B正常返回之后,用B的返回值执行任务C,任务C无返回值。

#### thenRun(...)

**功能**:对不关心上一步的计算结果，执行下一个操作

```java
        CompletableFuture<String> futureA = CompletableFuture.supplyAsync(() -> "任务A");
		CompletableFuture<String> futureB = CompletableFuture.supplyAsync(() -> "任务B");
        CompletableFuture<Void> test = futureA.thenRun(() -> System.out.println("执行任务B"));
```

执行任务A,任务A执行完以后,执行任务B,任务B不接受任务A的返回值(不管A有没有返回值),test无返回值。

可以跟`thenAccept()`比较一下：前者需要利用到上一步的返回结果，后者不需要。

#### thenApply(..)

**功能**:当前任务正常完成以后执行，当前任务的执行的结果会作为下一任务的输入参数,有返回值

```java
CompletableFuture<String> futureA = CompletableFuture.supplyAsync(() -> "任务A");
        CompletableFuture<String> futureC = futureA.thenApply(a -> {
            System.out.println(a + "test");
            return "successful";
        });
System.out.println(futureC.join());
```

就相当于有返回值了而已，跟前面两个的区别就在于它有返回值了。它跟`thenAccept()`比较相似，是需要上次执行结果作为参数。

~~我趣，`CompletableFuture`还有好多内容，我懒，我不看了。~~

`CompletableFuture`还有许多方法优化代码效率，可以去看看（会不会是因为我没看才这样说的呢）。

`CompletableFuture`的命名规则：

- `xxx()`：表示该方法将继续在已有的线程中执行；
- `xxxAsync()`：表示将异步在线程池中执行。



## 线程的优先级

可以对线程设定优先级，设定优先级的方法是：

```
Thread.setPriority(int n) // 1~10, 默认值5
```

优先级高的线程被操作系统调度的优先级较高，操作系统对高优先级线程可能调度更频繁，但我们不能通过设置优先级来确保高优先级的线程一定会先执行。

## 线程的状态

  在Java程序中，一个线程对象只能调用**一次**`start()`方法启动新线程，并在新线程中执行`run()`方法。一旦`run()`方法执行完毕，线程就结束了。因此，Java线程的状态有以下几种：

- New：新创建的线程，尚未执行；
- Runnable：运行中的线程，正在执行`run()`方法的Java代码；
- Blocked：运行中的线程，因为某些操作被阻塞而挂起；
- Waiting：运行中的线程，因为某些操作在等待中；
- Timed Waiting：运行中的线程，因为执行`sleep()`方法正在计时等待；
- Terminated：线程已终止，因为`run()`方法执行完毕。

用一个状态转移图表示如下：

```ascii
         ┌─────────────┐
         │     New     │
         └─────────────┘
                │
                ▼
┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
 ┌─────────────┐ ┌─────────────┐
││  Runnable   │ │   Blocked   ││
 └─────────────┘ └─────────────┘
│┌─────────────┐ ┌─────────────┐│
 │   Waiting   │ │Timed Waiting│
│└─────────────┘ └─────────────┘│
 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
                │
                ▼
         ┌─────────────┐
         │ Terminated  │
         └─────────────┘
```

当线程启动后，它可以在`Runnable`、`Blocked`、`Waiting`和`Timed Waiting`这几个状态之间切换，直到最后变成`Terminated`状态，线程终止。除了新建和终止外还有四个状态处于同一层。

可以使用`getState()`查看线程状态。

线程终止的原因有：

- 线程正常终止：`run()`方法执行到`return`语句返回；
- 线程意外终止：`run()`方法因为未捕获的异常导致线程终止；

一个线程可以**等待**另一个线程直到它运行结束。使用`join()`方法。

代码：

```java
public static void main(String[] args) throws InterruptedException {
        Thread thread = new Thread(() -> {
            System.out.println("hello");
        });
        System.out.println("start");
        thread.start();
        thread.join();
        System.out.println("end");
    }
```

输出：

```
start
hello
end
```

如果把`thread.join()`去掉，则输出:

```
start
end
hello
```

等待thread这个线程结束再继续运行main线程。`join`就是等待该线程结束，然后才继续往下执行自身线程。

## 中断线程

### 调用`interrupt()`方法



对目标线程调用`interrupt()`方法，目标线程需要反复检测自身状态是否是interrupted状态，如果是，就立刻结束运行。

```java
    public static void main(String[] args) throws InterruptedException {
        MyThread1 myThread = new MyThread1();
        myThread.start();
        Thread.sleep(1);
        myThread.interrupt();
        myThread.join();
        System.out.println("end");
    }

}
class MyThread1 extends Thread {
    public void run() {
        int n = 0;
        while (! isInterrupted()) {
            n ++;
            System.out.println(n + " hello!");
        }
    }
```

输出结果：

```
1 hello!
end
```

这里如果把sleep去掉，代码直接中断，来不及输出东西了。这里sleep把休眠的时间改长的话会输出更多，因为有更多的时间。

如果我们把调换一下代码的位置：

```java
    public static void main(String[] args) throws InterruptedException {
        MyThread1 myThread = new MyThread1();
        myThread.start();
        Thread.sleep(1);
        myThread.join();
        myThread.interrupt();
        System.out.println("end");
    }
```

如果换成这样，把`interrupt()`方法放到后面再调用，但是前面有一个`join()`方法，就表示我们只能等待myThread这个线程结束才能往下走，又因为MyThread1里有一个while循环语句，永远都是false，结束不了，所以会一直输出。



```java
public static void main(String[] args) throws InterruptedException {
        Thread t = new MyThread2();
        t.start();
        Thread.sleep(1000);
        t.interrupt(); // 中断t线程
        t.join(); // 等待t线程结束
        System.out.println("end");
    }
}

class MyThread2 extends Thread {
    public void run() {
        Thread hello = new HelloThread();
        hello.start(); // 启动hello线程
        try {
            hello.join(); // 等待hello线程结束
        } catch (InterruptedException e) {
            System.out.println("interrupted!");
        }
        hello.interrupt();
    }
}

class HelloThread extends Thread {
    public void run() {
        int n = 0;
        while (!isInterrupted()) {
            n++;
            System.out.println(n + " hello!");
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                break;
            }
        }
    }
```

`t`线程启动，执行`run()`然后`hello`线程启动，开始输出`hello`直到睡眠时间到，`t`线程调用`interrupt()`，而此时，`t`线程正位于`hello.join()`的等待中，`hello.join()`就会报错，`try{...} catch(){...}`捕获到这个异常，输出`interrupted!`。在`t`线程结束前，对`hello`线程也进行了`interrupt()`调用通知其中断。如果去掉这一行代码，可以发现`hello`线程仍然会继续运行，且JVM不会退出。

### **设置标志位**中断

对目标线程调用`interrupt()`方法是中断线程的一种方法，还有另一种通过**设置标志位**中断方法。

```java
public static void main(String[] args)  throws InterruptedException {
        HelloThread t = new HelloThread();
        t.start();
        Thread.sleep(1);
        t.running = false; // 标志位置为false
    }
}

class HelloThread extends Thread {
    // 标志位 volatile 关键词
    public volatile boolean running = true;
    
    public void run() {
        int n = 0;
        while (running) {
            n ++;
            System.out.println(n + " hello!");
        }
        System.out.println("end!");
    }

```

`HelloThread`的标志位`boolean running`是一个线程间共享的变量。线程间共享变量需要使用`volatile`关键字标记，确保每个线程都能读取到更新后的变量值。

对线程间共享的变量用关键字`volatile`声明涉及到Java的内存模型。在Java虚拟机中，变量的值保存在主内存中，但是，当线程访问变量时，它会先获取一个副本，并保存在自己的工作内存中。如果线程修改了变量的值，虚拟机会在某个时刻把修改后的值回写到主内存，但是，这个时间是**不确定**的！

```ascii
┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
           Main Memory
│                               │
   ┌───────┐┌───────┐┌───────┐
│  │ var A ││ var B ││ var C │  │
   └───────┘└───────┘└───────┘
│     │ ▲               │ ▲     │
 ─ ─ ─│─│─ ─ ─ ─ ─ ─ ─ ─│─│─ ─ ─
      │ │               │ │
┌ ─ ─ ┼ ┼ ─ ─ ┐   ┌ ─ ─ ┼ ┼ ─ ─ ┐
      ▼ │               ▼ │
│  ┌───────┐  │   │  ┌───────┐  │
   │ var A │         │ var C │
│  └───────┘  │   │  └───────┘  │
   Thread 1          Thread 2
└ ─ ─ ─ ─ ─ ─ ┘   └ ─ ─ ─ ─ ─ ─ ┘
```

这会导致如果一个线程更新了某个变量，另一个线程读取的值可能还是更新前的。例如，主内存的变量`a = true`，线程1执行`a = false`时，它在此刻仅仅是把变量`a`的副本变成了`false`，主内存的变量`a`还是`true`，在JVM把修改后的`a`回写到主内存之前，其他线程读取到的`a`的值仍然是`true`，这就造成了多线程之间共享的变量不一致。

因此，`volatile`关键字的目的是告诉虚拟机：

- 每次访问变量时，总是获取主内存的最新值；
- 每次修改变量后，**立刻**回写到主内存。

`volatile`关键字解决的是可见性问题：当一个线程修改了某个共享变量的值，其他线程能够立刻看到修改后的值。

针对多线程使用的变量如果不是volatile或者final修饰的，很有可能产生不可预知的结果（另一个线程修改了这个值，但是之后在某线程看到的是修改之前的值）。其实道理上讲同一实例的同一属性本身只有一个副本。但是多线程是会缓存值的，本质上，volatile就是不去缓存，直接取值。在线程安全的情况下加volatile会牺牲性能。

中断是一个状态`！interrupt()`方法只是将这个状态置为true而已。所以说正常运行的程序不去检测状态，就不会终止，而`wait()`等阻塞方法会去检查并抛出异常。如果在正常运行的程序中添加`while(!Thread.interrupted()) `，则同样可以在中断后离开代码体。

## 守护线程

守护线程是指为其他线程服务的线程。在JVM中，所有非守护线程都执行完毕后，无论有没有守护线程，虚拟机都会自动退出。

因此，JVM退出时，不必关心守护线程是否已结束。

不是字面看着守护这个线程不让它结束，而是可以直接结束这个线程从而可以结束JVM。**不要看表面意思啊喂**

```java
Thread t = new MyThread();
t.setDaemon(true);
t.start();
```

在守护线程中，编写代码要注意：守护线程不能持有任何需要关闭的资源，例如打开文件等，因为虚拟机退出时，守护线程没有任何机会来关闭文件，这会导致数据丢失。

## 线程同步（加锁解锁）

```java
public class Main {
    public static void main(String[] args) throws Exception {
        var add = new AddThread();
        var dec = new DecThread();
        add.start();
        dec.start();
        add.join();
        dec.join();
        System.out.println(Counter.count);
    }
}

class Counter {
    public static int count = 0;
}

class AddThread extends Thread {
    public void run() {
        for (int i=0; i<10000; i++) { Counter.count += 1; }
    }
}

class DecThread extends Thread {
    public void run() {
        for (int i=0; i<10000; i++) { Counter.count -= 1; }
    }
}

```

当多个线程同时运行时，线程的调度由操作系统决定，程序本身无法决定。因此，任何一个线程都有可能在任何指令处被操作系统暂停，然后在某个时间段后继续执行。比如上方这个代码块的执行结果就不一定是0，对数据的处理不是原子操作，导致多个线程读写一个变量，数据不一致。

这个时候，有个单线程模型下不存在的问题就来了：如果多个线程同时读写共享变量，会出现数据不一致的问题。这个结果每次执行都不一样，不会是我们想象的那样得到执行加一次后执行减一次。

🌰：两个人分别去银行向同一张卡取钱、排队干饭。

多线程模型下，要保证逻辑正确，对共享变量进行读写时，必须保证一组指令以原子方式执行：即某一个线程执行时，其他线程必须等待：

```ascii
┌───────┐     ┌───────┐
│Thread1│     │Thread2│
└───┬───┘     └───┬───┘
    │             │
    │-- lock --   │
    │ILOAD (100)  │
    │IADD         │
    │ISTORE (101) │
    │-- unlock -- │
    │             │-- lock --
    │             │ILOAD (101)
    │             │IADD
    │             │ISTORE (102)
    │             │-- unlock --
    ▼             ▼
```

通过加锁和解锁的操作，就能保证3条指令总是在一个线程执行期间，不会有其他线程会进入此指令区间。即使在执行期线程被操作系统中断执行，其他线程也会因为无法获得锁导致无法进入此指令区间。只有执行线程将锁释放后，其他线程才有机会获得锁并执行。这种加锁和解锁之间的代码块我们称之为临界区（Critical Section），任何时候临界区最多只有一个线程能执行。

可见，保证一段代码的原子性就是通过加锁和解锁实现的。Java程序使用`synchronized`关键字对一个对象进行加锁：

```java
public class Main {
    public static void main(String[] args) throws Exception {
        var add = new AddThread();
        var dec = new DecThread();
        add.start();
        dec.start();
        add.join();
        dec.join();
        System.out.println(Counter.count);
    }
}

class Counter {
    public static int count = 0;
    public static final Object lock = new Object();
}

class AddThread extends Thread {
    public void run() {
        for (int i = 0; i < 10000; i++) {
            // 同步块
            synchronized (Counter.lock) {
                Counter.count += 1;
            }
        }
    }
}

class DecThread extends Thread {
    public void run() {
        for (int i = 0; i < 10000; i++) {
            // 同步块
            synchronized (Counter.lock) {
                Counter.count -= 1;
            }
        }
    }
}
```

它表示用`Counter.lock`实例作为锁，两个线程在执行各自的`synchronized(Counter.lock) { ... }`代码块时，**必须先获得锁，才能进入代码块进行**。执行结束后，在`synchronized`语句块结束会自动释放锁。这样一来，对`Counter.count`变量进行读写就不可能同时进行。上述代码无论运行多少次，最终结果都是0。

同步方法跟同步块差不多，这里写的是同步块。不同的是同步方法默认锁住的对象是本身这个方法的类，默认锁的是`this.`而同步块可以锁任何对象，只要你传这个对象过去就行了，就是上面这个栗子。

使用`synchronized`解决了多线程同步访问共享变量的正确性问题。但是，它的缺点是带来了性能下降。因为`synchronized`代码块无法并发执行。此外，加锁和解锁需要消耗一定的时间，所以，`synchronized`会降低程序的执行效率。

在使用`synchronized`的时候，不必担心抛出异常。因为无论是否有异常，都会在`synchronized`结束处正确释放锁。

需要注意的是线程各自的`synchronized`锁住的必须是**同一个对象**，因为JVM只保证同一个锁在任意时刻只能被一个线程获取，但是两个不同的锁在同一时刻可以被两个线程分别获取。

使用锁的时候根据共享实例选择不同的锁，避免好几个线程使用的都是同一个锁降低了效率。

JVM规范定义了几种原子操作：

- 基本类型（`long`和`double`除外）赋值，例如：`int n = m`；
- 引用类型赋值，例如：`List<String> list = anotherList`。

**原子操作**是指不难被中断的一个或者一系列操作。

这两种都不需要synchronized的操作。

但是，如果是多行赋值，就必须保证是同步操作。

有时候赋值操作可以转换成利用指针引用进行赋值从而达到把非原子操作变为原子操作。

多行赋值，必须进行同步操作：

```java
class Pair {
    int first;
    int last;
    public void set(int first, int last) {
        synchronized(this) {
            this.first = first;
            this.last = last;
        }
    }
}
```

可以改造成这样：

```java
class Pair {
    int[] pair;
    public void set(int first, int last) {
        int[] ps = new int[] { first, last };
        this.pair = ps;
    }
}
```

这里不再需要同步，因为`this.pair = ps`是引用赋值的原子操作。

这里的`ps`是方法内部定义的局部变量，每个线程都会有各自的局部变量，互不影响，并且互不可见，并不需要同步。

## 死锁

多个线程各自持有不同的锁，然后各自试图获取对方手里的锁，造成了双方无限等待下去，这就是死锁。在获取多个锁的时候，不同线程获取多个不同对象的锁可能导致死锁。

```java
package lock;

/**
 * @Author xun
 * @create 2022/7/1 16:23
 */
public class DeadLock {
    public static void main(String[] args) {
        test t1 = new test("工藤新一");
        test t2 = new test("怪盗基德");
        t1.start();
        t2.start();
    }
}
class LockA {

}

class LockB {
}
class test extends Thread {
    static final LockA lockA = new LockA();
    static final LockB lockB = new LockB();

    String obj;
    test (String obj) {
        this.obj = obj;
    }

    @Override
    public void run() {
        try {
            fight();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    public void fight() throws InterruptedException {
        if (this.obj.equals("工藤新一")) {
            synchronized (lockA) {
                System.out.println(this.obj + "获得lockA");
                Thread.sleep(100);
                synchronized (lockB) {
                    System.out.println(this.obj + "获得lockB");
                }
            }
        } else {
            synchronized (lockB) {
                System.out.println(this.obj + "获得lockB");
                Thread.sleep(100);
                synchronized (lockA) {
                    System.out.println(this.obj + "获得lockA");
                }
            }
        }
    }
}

```

如果是按这样写的话

- 线程1：工藤新一进入`fight()`，获得`lockA`；
- 线程2：怪盗基德进入`fight()`，获得`lockB`。

随后

- 线程1：工藤新一准备获得`lockB`，失败，等待中；
- 线程2：怪盗基德准备获得`lockA`，失败，等待中。

此时，两个线程各自持有不同的锁，然后各自试图获取对方手里的锁，造成了双方无限等待下去，这就是死锁。死锁发生后，没有任何机制能解除死锁，只能强制结束JVM进程。

如果我们把获取第二把锁的位置换一下

```java
public void fight() throws InterruptedException {
        if (this.obj.equals("工藤新一")) {
            synchronized (lockA) {
                System.out.println(this.obj + "获得lockA");
                Thread.sleep(100);
            }synchronized (lockB) {
                System.out.println(this.obj + "获得lockB");
            }
        } else {
            synchronized (lockB) {
                System.out.println(this.obj + "获得lockB");
                Thread.sleep(100);
            }
            synchronized (lockA) {
                System.out.println(this.obj + "获得lockA");
            }
        }
    }
```

再拿到一个锁之后马上解锁，然后拿下一把锁，不抱死，让两个人都能拿到下一把锁。

产生死锁的四个条件：

1. 互斥条件：一个资源每次只能被一个进程使用。
2. 请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放。
3. 不剥夺条件：进程已获得的资源，在未使用完之前，不能强行剥夺。
4. 循环等待条件：若干进程之间形成一种头尾相接的循环等待资源关系。

Java的线程锁是可重入的锁。对同一个线程，在获取到锁以后继续获取同一个锁。JVM允许同一个线程重复获取同一个锁，这种能被同一个线程反复获取的锁，就叫做**可重入锁**（ReentrantLock）。由于Java的线程锁是可重入锁，所以，获取锁的时候，不但要判断是否是第一次获取，还要记录这是第几次获取。每获取一次锁，记录+1，每退出`synchronized`块，记录-1，减到0的时候，才会真正释放锁。

## ReentrantLock

```java
public class TestLock extends Thread{

    int ticketNums = 10;

    // 定义lock锁
    private final ReentrantLock lock = new ReentrantLock();

    @Override
    public void run() {
        while (true) {
            try {
                // 加锁
                lock.lock();
                if (ticketNums > 0) {
                    try {
                        Thread.sleep(100);
                    }catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println(ticketNums--);
                }else {
                    break;
                }
            } finally {
                // 解锁
                lock.unlock();
            }
        }
    }

    public static void main(String[] args) {
        TestLock t1 = new TestLock();
        new Thread(t1).start();
        new Thread(t1).start();
        new Thread(t1).start();
    }
}

```

保证线程安全，好像跟`synchronized`用处一样，只是使用更方便了。

使用`ReentrantLock`比直接使用`synchronized`更安全，可以替代`synchronized`进行线程同步。和`synchronized`不同的是，`ReentrantLock`可以尝试获取锁：

```
if (lock.tryLock(1, TimeUnit.SECONDS)) {
    try {
        ...
    } finally {
        lock.unlock();
    }
}
```

上述代码在尝试获取锁的时候，最多等待1秒。如果1秒后仍未获取到锁，`tryLock()`返回`false`，程序就可以做一些额外处理，而不是无限等待下去。

所以，使用`ReentrantLock`比直接使用`synchronized`更安全，线程在`tryLock()`失败的时候不会导致死锁。

## wait()和notify()

这两个方法就是睡眠线程和唤醒线程。基于`synchronized`。

```java
package PC;

/**
 * 测试生产者消费者模型:管程法
 * @Author xun
 * @create 2022/7/1 17:51
 */
public class TestPC {
    public static void main(String[] args) {
        SynContainer container = new SynContainer();

        new Productor(container).start();
        new Consumer(container).start();
    }
}
// 生产者
class Productor extends Thread {
    SynContainer container;
    public Productor(SynContainer container){
        this.container = container;
    }

    // 生产
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            try {
                container.push(new Chicken(i));
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            System.out.println("生产了" + i + "只鸡");
        }
    }
}

// 消费者
class Consumer extends Thread {
    SynContainer container;

    public Consumer(SynContainer container) {
        this.container = container;
    }

    // 消费
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            try {
                System.out.println("消费了-->" + container.pop().id + "只鸡");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
// 产品
class Chicken {
    // 产品编号
    int id;

    public Chicken(int id) {
        this.id = id;
    }
}

// 缓冲区
class SynContainer {
    // 需要一个容器大小
    Chicken[] chickens = new Chicken[10];
    // 容器计数器
    int count = 0;

    // 生产者放入产品
    public synchronized void push(Chicken chicken) throws InterruptedException {
        // 如果容器满了，就需要等待消费者消费
        if (count == chickens.length) {
            // 通知消费者消费，生产等待
            this.wait();
        }

        // 如果没有满，我们就需要丢入产品
        chickens[count] = chicken;
        count++;
        // 可以通知消费者消费了。
        this.notifyAll();
    }

    // 消费者消费产品
    public synchronized Chicken pop () throws InterruptedException {
        // 判断是否可以消费
        if(count == 0) {
            // 等待生产者生产，消费者等待。
            this.wait();
        }
        // 如果可以消费
        count--;

        // 吃完了，通知生产者生产
        this.notifyAll();
        return chickens[count];
    }

}
```

`wait`和`notify`用于多线程协调运行：

- 在`synchronized`内部可以调用`wait()`使线程进入等待状态；
- 必须在已获得的锁对象上调用`wait()`方法；
- 在`synchronized`内部可以调用`notify()`或`notifyAll()`唤醒其他等待线程；
- 必须在已获得的锁对象上调用`notify()`或`notifyAll()`方法；
- 已唤醒的线程还需要重新获得锁后才能继续执行。

必须写在`synchronized(锁对象){......}`代码块中。

`wait()`定义在`Object`类中的一个方法，`wait()`方法在调用时，**会释放线程获得的锁**，直到`wait()`方法返回后，线程才重新试图获得锁。

`notifyAll()`将唤醒**所有**当前正在`this`锁等待的线程，而`notify()`只会唤醒其中一个（具体哪个依赖操作系统，有一定的随机性）。

~~多线程编程好好好难。~~

## Condition

`synchronized`可以配合`wait`和`notify`实现线程在条件不满足时等待，条件满足时唤醒。而当我们使用`ReentrantLock`的时候就需要使用`Condition`对象来实现`wait`和`notify`的功能。

```java
    private final Condition condition = lock.newCondition();

	public void add(String s) {
        lock.lock();
        try {
            queue.add(s);
            condition.signalAll();
        } finally {
            lock.unlock();
        }
    }

    public String get() throws InterruptedException {
        lock.lock();
        try {
            while (queue.isEmpty()) {
                condition.await();
            }
            return queue.remove();
        }finally {
            lock.unlock();
        }
    }
```

使用`Condition`时，引用的`Condition`对象必须从`Lock`实例的`newCondition()`返回，这样才能获得一个绑定了`Lock`实例的`Condition`实例。

- `await()`会释放当前锁，进入等待状态；
- `signal()`会唤醒某个等待线程；
- `signalAll()`会唤醒所有等待线程；
- 唤醒线程从`await()`返回后需要重新获得锁。

## ReadWriteLock

- 只允许一个线程写入（其他线程既不能写入也不能读取）；
- 没有写入时，多个线程允许同时读（提高性能）。

```java
 private final ReadWriteLock rwlock = new ReentrantReadWriteLock();
    private final Lock rlock = rwlock.readLock();// 获取读锁
    private final Lock wlock = rwlock.writeLock();// 获取写锁
    wlock.lock(); // 加写锁
    wlock.unlock(); // 释放写锁
	rlock.lock(); // 加读锁
	rlock.unlock(); // 释放读锁
```

分别用读锁和写锁去加锁读写操作，读取时可以多个线程同时获取读锁。注意，如果有线程正在读，写线程需要等待读线程释放锁后才能获取写锁，即**读的过程中不允许写**。这是悲观的读锁。

## StampedLock

乐观的读锁，读的过程中也允许获取写锁后写入，写入后我们的数据可能会发生变化，所以需要判断我们读入的时候是否有写入数据。`StampedLock`和`ReadWriteLock`区别在读锁不同。`StampedLock`是**不可重入锁**，不能在一个线程中反复获取同一个锁。

```java
private final StampedLock stampedLock = new StampedLock();// 创建StampedLock对象
```

```java
long stamp = stampedLock.writeLock(); // 获取写锁
stampedLock.unlockWrite(stamp); // 释放写锁
```

```java
long stamp = stampedLock.tryOptimisticRead(); // 获得一个乐观读锁
```

通过`validate()`去验证版本号，如果读取过程没有写入，版本号不变，验证成功。如果在读取过程中有写入，版本号会发生变化，验证将失败。在失败的时候，我们再通过获取悲观读锁再次读取。

```java
stampedLock.validate(stamp)// 检查乐观读锁后是否有其他写锁发生
```

```java
stamp = stampedLock.readLock(); // 获取一个悲观读锁
stampedLock.unlockRead(stamp); // 释放悲观读锁
```

## Concurrent集合

`java.util.concurrent`包提供了几种并发集合类。

| interface | non-thread-safe         | thread-safe                              |
| :-------- | :---------------------- | :--------------------------------------- |
| List      | ArrayList               | CopyOnWriteArrayList                     |
| Map       | HashMap                 | ConcurrentHashMap                        |
| Set       | HashSet / TreeSet       | CopyOnWriteArraySet                      |
| Queue     | ArrayDeque / LinkedList | ArrayBlockingQueue / LinkedBlockingQueue |
| Deque     | ArrayDeque / LinkedList | LinkedBlockingDeque                      |

当我们需要多线程访问时，我们可以把对应的集合换成并发集合类。

## Atomic原子类

**这个更是重量级**，内容有点多，我都没细学，大概看了看，用到再说。

Atomic包下所有的原子类都只适用于单个元素，即只能保证一个基本数据类型、对象、或者数组的原子性。根据使用范围，可以将这些类分为四种类型，分别为原子**更新基本类型**、**原子更新数组**、**原子更新引用**、**原子更新属性**。

#### 原子更新基本类型

atomic包下原子更新基本数据类型包括AtomicInteger（原子更新整数类型）、AtomicLong（原子更新长整数类型）、AtomicBoolean（原子更新布尔类型）三个类。

这里只举`AtomicInteger`栗子。

`AtomicInteger`中提供许多方法给我们调用：

```java
// 获取当前值
get();
// 设置新值
set(int newValue);
// 获取当前值并设置新值
getAndSet(int newValue);
// 获取当前值，然后自加，相当于i++
getAndIncrement()
// 获取当前值，然后自减，相当于i--
getAndDecrement()
// 自加1后并返回，相当于++i
incrementAndGet()
// 自减1后并返回，相当于--i
decrementAndGet()
// 获取当前值，并加上预期值
getAndAdd(int delta)
// ...
```

可以去Java源码中查看。

使用：

```java
public class AtomicTest {

    public static void main(String[] args) throws Exception {
        var add = new AddThread();
        var dec = new DecThread();
        add.start();
        dec.start();
        add.join();
        dec.join();
        System.out.println(AtomicTest.getCount());
    }

    public static int getCount() {
        return atomicInteger.get();
    }
}

class Counter {
    public static int count = 0;
    public static AtomicInteger atomicInteger = new AtomicInteger();
}

class AddThread extends Thread {
    public void run() {
        for (int i = 0; i < 10000; i++) {
            atomicInteger.getAndIncrement();
        }
    }
}

class DecThread extends Thread {
    public void run() {
        for (int i = 0; i < 10000; i++) {
            atomicInteger.getAndDecrement();
        }
    }
}
```

这个栗子使用的是线程同步那里的栗子，我们这里使用`getAndIncrement()`和`getAndDecrement()`确保原子操作。线程同步那边使用的是`synchronized`保证原子性。

#### 原子更新引用类型

基本类型的原子类只能更新一个变量，如果需要原子更新多个变量，则需要使用引用类型原子类。引用类型的原子类包括AtomicReference、AtomicStampedReference、AtomicMarkableReference三个。

- **AtomicReference** 引用原子类
- **AtomicStampedReference** 原子更新带有版本号的引用类型。该类将整数值与引用关联起来，可用于解决原子的更新数据和数据的版本号，可以解决使用 CAS 进行原子更新时可能出现的 ABA 问题。(CAS是一个算法，无锁算法)
- **AtomicMarkableReference** 原子更新带有标记的引用类型。该类将 boolean 标记与引用关联起来。

以`AtomicReference`为例:

`AtomicReference`同样提供了许多方法：

```java
// 获取当前值
get();
// 设置新值
set(V newValue)
// 获取旧值设置新值，返回的是修改前的值
getAndSet(V newValue)
// CAS更新值 传入两个值， 如果expectedValue的值正确，则更新为newValue，返回true，否则什么也不干返回false
compareAndSet(V expectedValue, V newValue)
// ...
```

可以去源码中查看。

```java
public class Evangelion {
    public String pilots;

    public String series;

    public Evangelion(String series, String pilots) {
        this.pilots = pilots;
        this.series = series;
    }

    public static void main(String[] args) {
        AtomicReference<Evangelion> atomicReference = new AtomicReference<>();

        Evangelion unit0 = new Evangelion("Zerogōki", "Rei Ayanami");
        Evangelion unit1 = new Evangelion("Shogōki", "Shinji Ikari");
        Evangelion unit2 = new Evangelion("Nigōki", "Asuka Langley Soryu");

        atomicReference.set(unit0);
        String series0 = atomicReference.get().series;
        String pilots0 = atomicReference.get().pilots;
        System.out.println(series0 + "驾驶员为" + pilots0);

        // 如果atomicReference关联的值是unit0，则更新为unit2
        boolean res = atomicReference.compareAndSet(unit0, unit2);
        System.out.println(res);
        String series2 = atomicReference.get().series;
        String pilots2 = atomicReference.get().pilots;
        System.out.println(series2 + "驾驶员为" + pilots2);
    }
}
```

输出结果：

```
Zerogōki驾驶员为Rei Ayanami
true
Nigōki驾驶员为Asuka Langley Soryu
```

#### 原子更新数组

原子更新数组并不是对数组本身的原子操作，而是对数组中的元素。主要包括3个类：`AtomicIntegerArray`(原子更新整数数组的元素)、`AtomicLongArray`（原子更新长整数数组的元素）及`AtomicReferenceArray`（原子更新引用类型数组的元素）

以 `AtomicIntegerArray`为例：

```java
public class AtomicIntegerArray implements java.io.Serializable {
    // final类型的int数组
    private final int[] array;
    // 获取数组中第i个元素
    public final int get(int i) {
        return (int)AA.getVolatile(array, i);
    }   
    // 设置数组中第i个元素
    public final void set(int i, int newValue) {
        AA.setVolatile(array, i, newValue);
    }
    // CAS更改第i个元素
    public final boolean compareAndSet(int i, int expectedValue, int newValue) {
        return AA.compareAndSet(array, i, expectedValue, newValue);
    }
    // 获取第i个元素，并加1
    public final int getAndIncrement(int i) {
        return (int)AA.getAndAdd(array, i, 1);
    }
    // 获取第i个元素并减1
    public final int getAndDecrement(int i) {
        return (int)AA.getAndAdd(array, i, -1);
    }   
    // 对数组第i个元素加1后再获取
    public final int incrementAndGet(int i) {
        return (int)AA.getAndAdd(array, i, 1) + 1;
    }  
    // 对数组第i个元素减1后再获取
    public final int decrementAndGet(int i) {
        return (int)AA.getAndAdd(array, i, -1) - 1;
    }    
    // ... 省略
} 
```

```java
public class Array {
    public static void main(String[] args) {

        int[] array = new int[5];
        // 创建一个长度为5的数组，里面值全是0
        AtomicIntegerArray atomicIntegerArray = new AtomicIntegerArray(5);
        // 传入一个已创建好的数组， 数组为空时抛出NullPointerException
        AtomicIntegerArray atomicIntegerArray1 = new AtomicIntegerArray(array);


        atomicIntegerArray.set(0, 100);
        System.out.println(atomicIntegerArray.get(0));
    }
}
```

#### 原子更新对象属性

只选择更新某个对象中的字段，可以使用更新对象字段的原子类。包括三个类，AtomicIntegerFieldUpdater、AtomicLongFieldUpdater以及AtomicReferenceFieldUpdater。需要注意的是这些类的使用需要满足以下条件才可。

- 被操作的字段不能是static类型；
- 被操纵的字段不能是final类型；
- 被操作的字段必须是volatile修饰的；
- 属性必须对于当前的Updater所在区域是可见的。

以`AtomicReferenceFieldUpdater`为栗：

```java
public class Evangelion {
    // 这里用volatile修饰
    public volatile String pilot;

    public String series;

    public Evangelion(String series, String pilot) {
        this.pilot = pilot;
        this.series = series;
    }

    public static void main(String[] args) {
        // 更新unit1对象属性
        AtomicReferenceFieldUpdater<Evangelion,String> updater = AtomicReferenceFieldUpdater.newUpdater(Evangelion.class, String.class, "pilot");
        Evangelion unit1 = new Evangelion("Shogōki", "Shinji Ikari");
        // 把unit1中的pilot改成Rei Ayanami
        updater.set(unit1, "Rei Ayanami");
        System.out.println(unit1.pilot);
    }
}
```

输出结果

```
Rei Ayanami
```

`AtomicReferenceFieldUpdater`是一个抽象类。直接调用里面的`newUpdater(...)`方法。

```java
/**
* <T> 需要更新的对象的类型
* <V> 字段的类型
*/
public abstract class AtomicReferenceFieldUpdater<T,V>

/**
* tclass 需要更新的对象的类
* vclass 字段类型的类
* fieldName 字段名
*/
public static <U,W> AtomicReferenceFieldUpdater<U,W> newUpdater(Class<U> tclass,
                                                                Class<W> vclass,
                                                                String fieldName)
```

#### CAS

CAS是Compare And Swap的简称，即比较并交换的意思。CAS是一种无锁算法，其算法思想如下：

> CAS的函数公式：compareAndSwap(V,E,N)； 其中V表示要更新的变量，E表示预期值，N表示期望更新的值。调用compareAndSwap函数来更新变量V，如果V的值等于期望值E，那么将其更新为N，如果V的值不等于期望值E，则说明有其它线程跟新了这个变量，此时不会执行更新操作，而是重新读取该变量的值再次尝试调用compareAndSwap来更新。

可见CAS其实存在一个循环的过程，如果有多个线程在同时修改这一个变量V，在修改之前会先拿到这个变量的值，再和变量对比看是否相等，如果相等，则说明没有其它线程修改这个变量，自己更新变量即可。如果发现要修改的变量和期望值不一样，则说明再读取变量V的值后，有其它线程对变量V做了修改，那么，放弃本次更新，重新读变量V的值，并再次尝试修改，直到修改成功为止。这个循环过程一般也称作**自旋**，CAS操作的整个过程如下图所示：

![CAS流程图](https://cos.asuka-xun.cc/blog/background pictureCAS.jpg)

#####  应用

在应用中CAS可以用于实现无锁数据结构，常见的有无锁队列（先入先出 以及无锁栈（先入后出）。对于可在任意位置插入数据的链表以及双向链表，实现无锁操作的难度较大。

##### 缺陷

###### ABA问题

ABA问题是无锁结构实现中常见的一种问题，可基本表述为：

1. 进程P1读取了一个数值A
2. P1被挂起(时间片耗尽、中断等)，进程P2开始执行
3. P2修改数值A为数值B，然后又修改回A
4. P1被唤醒，比较后发现数值A没有变化，程序继续执行。

对于P1来说，数值A未发生过改变，但实际上A已经被变化过了，继续使用可能会出现问题。在CAS操作中，由于比较的多是指针，这个问题将会变得更加严重。试想如下情况：

```
   top
    |
    V   
  0x0014
| Node A | --> |  Node X | --> ……
```

有一个栈(先入后出)中有top和节点A，节点A目前位于栈顶top指针指向A。现在有一个进程P1想要pop一个节点，因此按照如下无锁操作进行

```
pop()
{
  do{
    ptr = top;            // ptr = top = NodeA
    next_prt = top->next; // next_ptr = NodeX
  } while(CAS(top, ptr, next_ptr) != true);
  return ptr;   
}
```

而进程P2在执行CAS操作之前打断了P1，并对栈进行了一系列的pop和push操作，使栈变为如下结构：

```
   top
    |
    V  
  0x0014
| Node C | --> | Node B | --> |  Node X | --> ……
```

进程P2首先pop出NodeA，之后又push了两个NodeB和C，由于内存管理机制中广泛使用的内存重用机制，导致NodeC的地址与之前的NodeA一致。

这时P1又开始继续运行，在执行CAS操作时，由于top依旧指向的是NodeA的地址(实际上已经变为NodeC)，因此将top的值修改为了NodeX，这时栈结构如下：

```
                                   top
                                    |
   0x0014                           V
 | Node C | --> | Node B | --> |  Node X | --> ……
```

经过CAS操作后，top指针错误地指向了NodeX而不是NodeB。

~~直接cv维基百科~~。

## 线程池

使用线程池的好处：

- 提高响应速度（减少了创建新线程的时间）
- 降低资源消耗（重复利用线程池中线程，不需要每次都创建）
- 便于线程管理（）
  - corePoolSize：核心池的大小
  - maximumPoolSize：最大线程数
  - keepAliveTime：线程没有任务时最多保持多长时间后会终止。

Java提供`ExecutorService`接口表示线程池。

详细用法看代码：

```java
public class TestPool {
    public static void main(String[] args) {
        // 创建服务，创建线程池
        // newFixedThreadPool 参数为线程池大小
        ExecutorService service = Executors.newFixedThreadPool(10);

        // 执行
        service.execute(new MyThread());
        service.execute(new MyThread());
        service.execute(new MyThread());
        service.execute(new MyThread());
        service.execute(new MyThread());

        // 关闭连接
        service.shutdown();

    }
}


class MyThread implements Runnable {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName());
    }
}
```

输出结果：

```java
pool-1-thread-1
pool-1-thread-4
pool-1-thread-3
pool-1-thread-2
pool-1-thread-5
```

线程池在程序结束的时候要关闭。使用`shutdown()`方法关闭线程池的时候，它会等待正在执行的任务先完成，然后再关闭。`shutdownNow()`会立刻停止正在执行的任务，`awaitTermination()`则会等待指定的时间让线程池关闭。

Java提供`ExecutorService`接口的几个实现类有：

- FixedThreadPool：线程数固定的线程池；（上面那个代码就使用这个实现类）
- CachedThreadPool：线程数根据任务动态调整的线程池；
- SingleThreadExecutor：仅单线程执行的线程池。

动态限制线程池的大小`CachedThreadPool`,可以根据`Executors.newCachedThreadPool()`方法的源码：

```java
public static ExecutorService newCachedThreadPool() {
        return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
                                      60L, TimeUnit.SECONDS,
                                      new SynchronousQueue<Runnable>());
    }
```

第一个参数是创建最小的线程、第二个是最大进程、第三个是未使用60秒的线程将被终止并从缓存中删除。

### 利用ScheduledThreadPool实现定时任务

需要反复执行的任务使用`ScheduledThreadPool`。

```java
ScheduledExecutorService ses = Executors.newScheduledThreadPool(4);
```

我们可以提交一次性任务，它会在指定延迟后只执行一次：

```
// 1秒后执行一次性任务:
ses.schedule(new Mythread(), 1, TimeUnit.SECONDS);

// 参数
schedule(Runnable command,
         long delay, TimeUnit unit);
// 另一种写法         
schedule(Callable<V> callable,
         long delay, TimeUnit unit);
```

如果任务以固定的每3秒执行，我们可以这样写：

```
// 2秒后开始执行定时任务，每3秒执行:
ses.scheduleAtFixedRate(new Mythread(), 2, 3, TimeUnit.SECONDS);

// 参数
scheduleAtFixedRate(Runnable command,
                    long initialDelay,
                    long period,
                    TimeUnit unit);
```

如果任务以固定的3秒为间隔执行，我们可以这样写：

```
// 2秒后开始执行定时任务，以3秒为间隔执行:
ses.scheduleWithFixedDelay(new Mythread(), 2, 3, TimeUnit.SECONDS);

// 参数
scheduleWithFixedDelay(Runnable command,
                       long initialDelay,
                       long delay,
                       TimeUnit unit);
```

注意`scheduleAtFixedRate`和`scheduleWithFixedDelay`的区别。`scheduleAtFixedRate`是指任务总是以固定时间间隔触发，~~不管任务执行多长时间(不管前面任务是否执行完毕)~~**(我还不确定)**：

```ascii
│░░░░   │░░░░░░ │░░░    │░░░░░  │░░░  
├───────┼───────┼───────┼───────┼────>
│<─────>│<─────>│<─────>│<─────>│
```

而`scheduleWithFixedDelay`是指，上一次任务执行**完毕后（上一次的任务执行完毕后，再开始计时）**，等待固定的时间间隔，再执行下一次任务：

```ascii
│░░░│       │░░░░░│       │░░│       │░
└───┼───────┼─────┼───────┼──┼───────┼──>
    │<─────>│     │<─────>│  │<─────>│
```

这有个坑，但是不知道原因。

我自己测试`scheduleAtFixedRate`的时候是出现执行完任务才进行下一次任务的执行，而不是以固定时间间隔触发。

测试代码：

```java
public class TestPool {

    public static void main(String[] args) {
        // 创建服务，创建线程池
        // newFixedThreadPool 参数为线程池大小
        ScheduledExecutorService ses = Executors.newScheduledThreadPool(10);

        // 执行
        ses.scheduleAtFixedRate(new MyThread(), 2, 3, TimeUnit.SECONDS);
    }
}


class MyThread implements Runnable {
    public static int count = 0;

    @Override
    public void run() {
        count++;
        System.out.println(Thread.currentThread().getName() + "现在时间是" + LocalDateTime.now());
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
```

## ForkJoin

这是另一种线程池，它主要功能是**把一个大任务拆成多个小任务并行执行**。

利用分治的思想：通过分解任务，并行执行，最后合并结果得到最终结果。

摆烂了，不写了。之后一定看。
