---
description: 首先了解一下注解。 这个是`Controller`的源代码，以它为例。
title: Springboot常用注解
cover: https://cos.asuka-xun.cc/blog/assets/springbootannotations.jpg
date: 2022/7/8 13:00
categories:
- [Java]
tags:
- 计算机科学与技术
- Spring
---
# Springboot常用注解

## Java注解（Annotation）

首先了解一下注解。

这个是`Controller`的源代码，以它为例。

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Controller {
    @AliasFor(
        annotation = Component.class
    )
    String value() default "";
}
```

里面有六个个注解（注意有个`@interface`），注解可以作用于注解：

1. `@Target`

   `java.lang.annotation.Target` 自身也是一个注解，它只有一个数组属性，用于设定该注解的目标范围。比如我要让这个注解作用于类或者作用于方法上。它为数组属性，可以同时设定多个值，就是可以同时作用于类或者方法上。

   这里说几个常用的作用的类型：

   - ElementType.TYPE

     > 可以作用于 类、接口类、枚举类上

   - ElementType.FIELD

     > 可以作用于类的属性上

   - ElementType.METHOD

     > 可以作用于类的方法上

   - ElementType.PARAMETER

     > 可以作用于类的参数

   如果需要同时作用于类和方法上，那么可以这样写：

   ```java
   @Target({ElementType.TYPE,ElementType.METHOD})
   ```

   可以看看`java.lang.annotation.ElementType`这个枚举类中提供的类型，一共提供了11个`target`可以作用的类型。

   举栗子：

   1.1 ElementType.TYPE，作用在类上。

   ```java
   @Service
   public class DocServiceImpl extends ServiceImpl<DocMapper, Doc> implements DocService
   ```

   1.2 ElementType.FIELD,作用在类的属性上。

   ```java
       @Resource
       private DocMapper docMapper;
   ```

   1.3 ElementType.PARAMETER，作用在类的参数上。这里的`@Param`。

   ```java
   void addS (@Param("sid") Integer sid, @Param("did") Integer did);
   ```

2. `@Retention`

   `java.lang.annotation.Retention` 自身也是一个注解，它用于声明该注解的生命周期，就是在 Java 编译、运行的哪个环节有效。有三个值可以选择：

   1. SOURCE: 编译器将无视这个注解，就是这个注解相当于注释

   2. CLASS: 注释由编译器记录在类文件中，在VM 运行时不需要保留这些注释，已经默认保留。也就是在编译阶段是有效的。

   3. RUNTIME: 在运行时有效。

3. `@Documented`

   如果一个注解使用 Documted 进行注释，默认情况下，像 javadoc 这样的工具将在其输出中显示该注解中的元素（注解类型信息），而不使用 Documted 的注解将不会显示。就是说，用@Documented 注解修饰的注解类会被JavaDoc 工具提取成文档。

   Javadoc（最初是JavaDoc）是由Sun Microsystems为Java语言（现在由甲骨文公司拥有）创建的文档生成器，用于从Java源代码生成HTML格式的API文档，HTML格式用于增加将相关文档链接在一起的便利性。Javadoc不影响Java中的性能，因为在编译时会删除所有注释。编写注释和Javadoc是为了更好地理解代码，从而更好地维护代码。

   **一般都会添加这个注解。**

4. `@Component`

   这个是Spring的注解，把当前类对象存入Spring容器，Spring会把这个类标记为bean,方便后期装配。

   这个注解后面跟四大组件再一起说。

5. `@interface`
    就是声明当前的 Java 类型是 Annotation，固定语法。

6. `@AliasFor`
    起别名。上面那个`@Controller`用法使用这个注解时有点特殊。

   `@AliasFor`可以用来对一个类中的不同属性起别名，起相同的别名，然后可以用这个别名互相调用这几个不同的属性。

   ```java
   @Retention(RetentionPolicy.RUNTIME)
   @Target(ElementType.TYPE)
   @Documented
   @Repeatable(ComponentScans.class)
   public @interface ComponentScan {
   
       @AliasFor("basePackages")
       String[] value() default {};
   
       @AliasFor("value")
       String[] basePackages() default {};
   ...
   }
   ```
   
   意味着我们可以互换使用它们。所以，以下这三种用法是一样的。
   
   ```java
   @ComponentScan("com.baeldung.aliasfor")
   
   @ComponentScan(basePackages = "com.baeldung.aliasfor")
   
   @ComponentScan(value = "com.baeldung.aliasfor")
   ```
   
   `@Controller`特殊在哪呢，你发现它起的别名不是一个注解内的属性，而是跨注解的属性，所以`@AliasFor`可以声明跨注解的属性别名。这里的意思就是`@Component`和`@Controller`互通。实际上，`@Component`跟`@Service`和`@Controller`都互通（应该是有那么一点差异吧，但是可以实现一样的功能）。

   ```java
       @AliasFor(
           annotation = Component.class
       )
   ```
   

除了注解中的注解需要了解之外，注解中的属性我们也需要知道，跟类的属性很像。有基础类型，属性名称（默认为`value`，在引用的时候可以忽略），default 代表的是默认值。

```java
String value() default "";
```

我们正常引用一个注解，比如`@Service`

```java
@Service
public class StarServiceImpl extends ServiceImpl<StarMapper,Star> implements StarService
```

也可以这样：

```java
@Service(value="StarServiceImpl")
public class StarServiceImpl extends ServiceImpl<StarMapper,Star> implements StarService
```

`value`可以不写。

## @SpringBootApplication

这个注解实际包含了以下几个注解：

- @SpringBootConfiguration
  - @Configuration
- @EnableAutoConfiguration
  - @AutoConfigurationPackage
- @ComponentScan

这个注解就启动了**自动配置**和**自动扫描**。

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }
}
```



## 四大注解

添加这四个注解都会将这个类自动注册为Spring Beans。~~这四个注解可以混着用~~，都是一样的作用，不过不建议四个注解当成一个注解用。

### @Component

> 通用的注解，可标识任意类为Spring组件。下面三个注解都是这个注解的拓展。当该类不知道属于以上三类的那一类时可以使用该注解。

### @Service

> 服务层，主要在这里编写逻辑

### @Repository

> 持久层也就是Dao层，负责数据库相关操作。

### @Controller

> 作用于 Web Bean，Spring在处理传入的Web请求时会传到这个类。

## @RestController

表明这个注解下的类是一个web`@Controller`，所以Spring在处理传入的Web请求时会传到这个类。

**区别`@Controller`**，`@RestController`返回结果字符串，即返回数据内容，`@Controller`返回页面

`@RestController`相当于`@Controlle`和`@ResponseBody`

## @RequestMapping

提供路由信息，告诉Spring任何带有`/`路径的HTTP请求都映射到`home`方法。用于解析 URL 请求路径，这个注解默认是支持所有的 Http Method 的。

## @Autowire

依赖注入。`@SpringBootApplication`已经为我们自动装配和自动扫描好了，现在我们需要完成依赖注入。

为什么需要使用`@Autowire`去完成依赖注入呢？`@Autowire`它的作用是什么？

我们都知道使用类的时候需要都需要实例化对象，需要去new一个对象，但是当我们需要实例化的对象太多了就会出现很多`new`实例对象，这样容易出错，也不好看。

所以我们使用`@Autowire`，在任何我们需要使用类（bean）的地方，用 `@Autowired` 注解标记，告诉 *Spring* 这里需要注入实现类的实例。项目启动过程中，*Spring* 会 **自动** 实例化服务实现类，然后 **自动** 注入到变量中。

前提条件是该类**被注册为Spring Bean**。

```java
@Service
public class AdminService
```

```java
@Autowired
AdminService adminService;
```

我们也可以不使用`@Autowire`实现注入，我们也可以使用构造函数注入,似乎这是更推荐的方法。

```java
    private final AdminService adminService;
    public AdminController (AdminService adminService) {
        this.adminService = adminService;
    }
```

## @PathVariable

接收路径参数。

```java
@GetMapping("/api/employeeswithvariable/{id}")
@ResponseBody
public String getEmployeesByIdWithVariableName(@PathVariable("id") String employeeId) {
    return "ID: " + employeeId;
}
```

```
输入网址：http://localhost:8080/api/employeeswithvariable/1 
---- 
输出结果：ID: 1
```

`@PathVariable`获取url中的数据。

## @RequestParam

```java
@PostMapping("/api/foos")
@ResponseBody
public String addFoo(@RequestParam(name = "id") String fooId) { 
    return "ID: " + fooId;
}
```

我们可以`@RequestParam(value = "id")`或者`@RequestParam("id")`

`@RequestParam`获取查询参数。

```
http://localhost:8080/spring-mvc-basics/api/foos?id=abc
----
ID: abc
```

`@RequestParam(required = false)`说明这个参数不是必须的。

```java
@GetMapping("/api/foos")
@ResponseBody
public String getFoos(@RequestParam(required = false) String id) { 
    return "ID: " + id;
}
```

可以这样：

```
http://localhost:8080/spring-mvc-basics/api/foos?id=abc
----
ID: abc
```

也可以这样：

```
http://localhost:8080/spring-mvc-basics/api/foos
----
ID: null
```

## @RequestBody

`@RequestBody`将 HttpRequest 主体映射到传输对象或域对象，从而支持将入站 HttpRequest 主体自动反序列化到 Java 对象。就是将传来的参数数据映射到我们的Java实体类中。

`@requestBody`注解常用来处理**content-type（http请求头）不是默认的application/x-www-form-urlcoded编码**的内容，比如说：application/json或者是application/xml等。一般情况下来说常用其来处理application/json类型。

感觉跟`@RequestParam`差不多，只不过就是映射的是一个对象多个属性，还有就是参数放在request体中，而不是在直接连接在地址后面。

```java
@PostMapping("/request")
public ResponseEntity postController(
  @RequestBody LoginForm loginForm) {
 
    exampleService.fakeAuthenticate(loginForm);
    return ResponseEntity.ok(HttpStatus.OK);
}
```

```java
public class LoginForm {
    private String username;
    private String password;
    // ...
}
```

写法就是像上面一样，然后我们传参数的话，将

POST请求body传数据：`{"username": "johnny", "password": "password"}`。这将会映射到我们的`LoginForm`这个实体类上。

## @ResponseBody

将返回值放在response内，而不是一个页面，通常用户返回json数据。

## @ExceptionHandler

```java
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ExceptionHandler {
    Class<? extends Throwable>[] value() default {};
}
```

```java
@ExceptionHandler({RuntimeException.class})
```

作用在方法上。

用于全局处理控制器里的异常。是个数组，可以传多个Class（一个`Class`实例包含了该`class`的所有完整信息，反射那边的知识吧）。

## @Scheduled

申明这是一个任务，包括`cron,fixDelay,fixRate`等类型。可以用它写定时任务。
