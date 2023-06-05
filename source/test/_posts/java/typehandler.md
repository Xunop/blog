---
title: 关于字段类型处理器
date: 2022/7/22 11:35
categories:
- [Java]
tags:
- MyBatis
---
# 关于字段类型处理器

 最近写的一个项目报错：

```java
<!-- more -->
2022-07-22 00:23:00.295 ERROR 21860 --- [0.1-8081-exec-1] o.a.c.c.C.[.[.[/].[dispatcherServlet]    : Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception [Request processing failed; nested exception is org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.exceptions.PersistenceException: 
### Error updating database.  Cause: java.lang.IllegalStateException: Type handler was null on parameter mapping for property 'reviewSettings'. It was either not specified and/or could not be found for the javaType (com.alibaba.fastjson.JSONObject) : jdbcType (null) combination.
### The error may exist in com/sast/crs/mapper/AdminMapper.java (best guess)
### The error may involve com.sast.crs.mapper.AdminMapper.insert
### The error occurred while executing an update
### Cause: java.lang.IllegalStateException: Type handler was null on parameter mapping for property 'reviewSettings'. It was either not specified and/or could not be found for the javaType (com.alibaba.fastjson.JSONObject) : jdbcType (null) combination.] with root cause

java.lang.IllegalStateException: Type handler was null on parameter mapping for property 'reviewSettings'. It was either not specified and/or could not be found for the javaType (com.alibaba.fastjson.JSONObject) : jdbcType (null) combination.

```

情况是这样的：我准备测试一个接口，其中测试传的一个参数类型是`json`格式，我在程序中实体类对应的字段也设置成了`JSONObject`来接收这个字段，如果我设置成`String`或者其他类型时会直接警告：

```java
2022-07-22 11:17:55.413  WARN 17492 --- [0.1-8081-exec-2] .w.s.m.s.DefaultHandlerExceptionResolver : Resolved [org.springframework.http.converter.HttpMessageNotReadableException: JSON parse error: Cannot deserialize value of type `java.lang.String` from Object value (token `JsonToken.START_OBJECT`); nested exception is com.fasterxml.jackson.databind.exc.MismatchedInputException: Cannot deserialize value of type `java.lang.String` from Object value (token `JsonToken.START_OBJECT`)<EOL> at [Source: (org.springframework.util.StreamUtils$NonClosingInputStream); line: 16, column: 24] (through reference chain: com.sast.crs.entity.Competition["review_settings"])]

```

所以我就直接使用`JSONObject`这个类型了，但是呢，使用这个类型数据是接收到了就是在插入时会报最上面那个错，大概意思是**处理映射的时候没有匹配的类型**。所以我们就应该给它加一个类型处理器。

修改措施：在该字段位置新增一个注解`@TableField(typeHandler = FastjsonTypeHandler.class)`。 `mybatis-plus` 内置常用类型处理器通过`TableField`注解快速注入到 `mybatis` 容器中。

---

## 问题总结

主要就是要明白**字段类型处理器**的作用：

- 将我们传入接口的参数转换为对应的数据库类型
- 将数据库种查询回来的字段类型转换为对应的java类型

参考至：

[字段类型处理器 | MyBatis-Plus (baomidou.com)](https://baomidou.com/pages/fd41d8/)