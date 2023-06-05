---
title: MyBatisPlus常用操作
cover: https://cos.asuka-xun.cc/blog/assets/mybatisplus.jpg
date: 2022/7/26 00:54
categories:
- [Java]
tags:
- MyBatis
- Spring
---
# MyBatisPlus

**MyBatisPlus**是**MyBatis**的增强工具，在 MyBatis 的基础上只做增强不做改变，为简化开发、提高效率而生。

## MyBatisPlus配置（后面有提到再补）
<!-- more -->

```yaml
#MyBatis-Plus相关配置
mybatis-plus:
  configuration:
    #配置日志
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
```

## 增删改查

### BaseMapper<T>

```java
public interface UserMapper extends BaseMapper<User>
```

需要注意Mapper层的写法。需要继承`BaseMapper<T>`。

> 说明:
>
> 通用 CRUD 封装BaseMapper 接口，为 `Mybatis-Plus` 启动时自动解析实体表关系映射转换为 `Mybatis` 内部对象注入容器
>
> 泛型 `T` 为任意实体对象
>
> 参数 `Serializable` 为任意类型主键 `Mybatis-Plus` 不推荐使用复合主键约定每一张表都有自己的唯一 `id` 主键
>
> 对象 `Wrapper` 为条件构造器

MyBatis-Plus中的基本CRUD在内置的BaseMapper中都已得到了实现，因此我们继承该接口以后可以直接使用。这就是MyBatis-Plus的方便之处，大部分SQL语句不需要我们写。

---

#### Insert

```java
// 插入一条记录
int insert(T entity);
```

```java
    @Test
    public void testInsert() {
        // INSERT INTO user ( name, age, email ) VALUES ( ?, ?, ? )
        User user = new User();
        user.setAge(19);
        user.setEmail("xxx.@gmail.com");
        user.setName("小明");
        int res = userMapper.insert(user);
        System.out.println("res:" + res);
        System.out.println("id:" + user.getId());
    }
```

我们可以从控制台看到MyBatisPlus生成的SQL语句。从这个插入的代码块可以知道怎么使用了吧`userMapper.insert(user);`, MyBatisPlus就是相当于将一些SQL操作封装起来，我们调用这个方法就能实现相对应的SQL操作。下面的操作也是一样。

#### Delete

 ```java
  // 根据 entity 条件，删除记录
  int delete(@Param(Constants.WRAPPER) Wrapper<T> wrapper);
  // 删除（根据ID 批量删除）
  int deleteBatchIds(@Param(Constants.COLLECTION) Collection<? extends Serializable> idList);
  // 根据 ID 删除
  int deleteById(Serializable id);
  // 根据 columnMap 条件，删除记录
  int deleteByMap(@Param(Constants.COLUMN_MAP) Map<String, Object> columnMap);
  java
 ```

```java
    @Test
    public void testDelete() {
        // 通过id删除用户信息
        // DELECT FROM user WHERE id=?
        int res = userMapper.deleteById(1545995108796071938L);
        System.out.println("res:" + res);

        // 通过条件删除用户
        // DELETE FROM user WHERE name = ? AND age = ? AND email = ?
        Map<String, Object> map = new HashMap<>();
        map.put("name", "小明");
        map.put("age", 19);
        map.put("email", "xxx.@gmail.com");
        userMapper.deleteByMap(map);

        // 通过多个id删除用户
        // DELETE FROM user WHERE id IN ( ? , ? , ? )

        // asList将里面的这三个数字转成一个list集合
        List<Long> list = Arrays.asList(1L, 2L, 3L);
        res = userMapper.deleteBatchIds(list);
        System.out.println("res:" + res);
    }
```

#### Update

```java
// 根据 whereWrapper 条件，更新记录
int update(@Param(Constants.ENTITY) T updateEntity, @Param(Constants.WRAPPER) Wrapper<T> whereWrapper);
// 根据 ID 修改
int updateById(@Param(Constants.ENTITY) T entity);
```

```java
    @Test
    public void testUpdate() {
        // 根据id更新数据
        // UPDATE user SET name=?, email=? WHERE id=?
        User user = new User();
        user.setId(4L);
        user.setName("李四");
        user.setEmail("xxx.@gemail.com");
        int res = userMapper.updateById(user);
        System.out.println("res:" + res);
    }
```

#### Select

```java
// 根据 ID 查询
T selectById(Serializable id);
// 根据 entity 条件，查询一条记录
T selectOne(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);

// 查询（根据ID 批量查询）
List<T> selectBatchIds(@Param(Constants.COLLECTION) Collection<? extends Serializable> idList);
// 根据 entity 条件，查询全部记录
List<T> selectList(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
// 查询（根据 columnMap 条件）
List<T> selectByMap(@Param(Constants.COLUMN_MAP) Map<String, Object> columnMap);
// 根据 Wrapper 条件，查询全部记录
List<Map<String, Object>> selectMaps(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
// 根据 Wrapper 条件，查询全部记录。注意： 只返回第一个字段的值
List<Object> selectObjs(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);

// 根据 entity 条件，查询全部记录（并翻页）
IPage<T> selectPage(IPage<T> page, @Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
// 根据 Wrapper 条件，查询全部记录（并翻页）
IPage<Map<String, Object>> selectMapsPage(IPage<T> page, @Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
// 根据 Wrapper 条件，查询总记录数
Integer selectCount(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
```

```java
	@Test
    public void testSelect() {
        // 通过id查找用户
        // SELECT id,name,age,email FROM user WHERE id=?
        User user = new User();
        user.setId(9L);
        User res = userMapper.selectById(user.getId());
        System.out.println(res);

        // 根据id批量查询
        // SELECT id,name,age,email FROM user WHERE id IN ( ? , ? , ? )
        List<Long> list = Arrays.asList(8L, 9L, 10L);
        List<User> users = userMapper.selectBatchIds(list);
        users.forEach(System.out::println);

        // 通过map查询数据
        // SELECT id,name,age,email FROM user WHERE name = ? AND age = ?
        Map<String, Object> map = new HashMap<>();
        map.put("name","晴雯");
        map.put("age",16);
        List<User> users1 = userMapper.selectByMap(map);
        users1.forEach(System.out::println);

        // 查询所有数据
        // SELECT id,name,age,email FROM user
        List<User> users2 = userMapper.selectList(null);
        users2.forEach(System.out::println);
    }
```



### IService<T>

`Service`接口及它的实现类需要这样写。`ServiceImpl<M extends BaseMapper<T>, T>` M 表示需要操作的实体类的`Mapper`，T 表示需要操作的实体类。

```java
public interface UserService extends IService<User>
```

```java
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

```



> 说明:
>
> 通用 Service CRUD 封装`IService`接口，进一步封装 CRUD 采用 `get 查询单行` `remove 删除` `list 查询集合` `page 分页` 前缀命名方式区分 `Mapper` 层避免混淆
>
> 泛型 `T` 为任意实体对象
>
> 建议如果存在自定义通用 Service 方法的可能，请创建自己的 `IBaseService` 继承 `Mybatis-Plus` 提供的基类
>
> 对象 `Wrapper` 为 条件构造器

MyBatisPlus还提供了Service层的CRUD方法。

需要注意的是Service层的CRUD方法有**批量操作**。

#### Insert

```java
// 插入一条记录（选择字段，策略插入）
boolean save(T entity);
// 插入（批量）
boolean saveBatch(Collection<T> entityList);
// 插入（批量）
boolean saveBatch(Collection<T> entityList, int batchSize);

// TableId 注解存在更新记录，否插入一条记录
boolean saveOrUpdate(T entity);
// 根据updateWrapper尝试更新，否继续执行saveOrUpdate(T)方法
boolean saveOrUpdate(T entity, Wrapper<T> updateWrapper);
// 批量修改插入
boolean saveOrUpdateBatch(Collection<T> entityList);
// 批量修改插入
boolean saveOrUpdateBatch(Collection<T> entityList, int batchSize);
```

```java
    @Test
    public void testInsert() {
        // 批量添加
        // INSERT INTO user ( id, name, age ) VALUES ( ?, ?, ? )
        List<User> list = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            User user = new User();
            user.setName("mmm" + i);
            user.setAge(18 + i);
            list.add(user);
        }
        // 注意这里的SQL操作也是单个插入的操作,只不过是循环多次操作
        boolean res = userService.saveBatch(list);
        System.out.println(res);
    }
```

前面也说了为了区分`Mapper`层，所以起名不是使用`insert`但是SQL操作还是。

#### Delete

```java
// 根据 entity 条件，删除记录
boolean remove(Wrapper<T> queryWrapper);
// 根据 ID 删除
boolean removeById(Serializable id);
// 根据 columnMap 条件，删除记录
boolean removeByMap(Map<String, Object> columnMap);
// 删除（根据ID 批量删除）
boolean removeByIds(Collection<? extends Serializable> idList);
```

#### Update

```java
// 根据 entity 条件，删除记录
boolean remove(Wrapper<T> queryWrapper);
// 根据 ID 删除
boolean removeById(Serializable id);
// 根据 columnMap 条件，删除记录
boolean removeByMap(Map<String, Object> columnMap);
// 删除（根据ID 批量删除）
boolean removeByIds(Collection<? extends Serializable> idList);
```

#### Select

```java
// 根据 ID 查询
T getById(Serializable id);
// 根据 Wrapper，查询一条记录。结果集，如果是多个会抛出异常，随机取一条加上限制条件 wrapper.last("LIMIT 1")
T getOne(Wrapper<T> queryWrapper);
// 根据 Wrapper，查询一条记录
T getOne(Wrapper<T> queryWrapper, boolean throwEx);
// 根据 Wrapper，查询一条记录
Map<String, Object> getMap(Wrapper<T> queryWrapper);
// 根据 Wrapper，查询一条记录
<V> V getObj(Wrapper<T> queryWrapper, Function<? super Object, V> mapper);


// 查询所有
List<T> list();
// 查询列表
List<T> list(Wrapper<T> queryWrapper);
// 查询（根据ID 批量查询）
Collection<T> listByIds(Collection<? extends Serializable> idList);
// 查询（根据 columnMap 条件）
Collection<T> listByMap(Map<String, Object> columnMap);
// 查询所有列表
List<Map<String, Object>> listMaps();
// 查询列表
List<Map<String, Object>> listMaps(Wrapper<T> queryWrapper);
// 查询全部记录
List<Object> listObjs();
// 查询全部记录
<V> List<V> listObjs(Function<? super Object, V> mapper);
// 根据 Wrapper 条件，查询全部记录
List<Object> listObjs(Wrapper<T> queryWrapper);
// 根据 Wrapper 条件，查询全部记录
<V> List<V> listObjs(Wrapper<T> queryWrapper, Function<? super Object, V> mapper);

// 查询总记录数
int count();
// 根据 Wrapper 条件，查询总记录数
int count(Wrapper<T> queryWrapper);
```

#### 分页

这个好像跟分页查询不同，没怎么用过这个。

```java
// 根据 ID 查询
T getById(Serializable id);
// 根据 Wrapper，查询一条记录。结果集，如果是多个会抛出异常，随机取一条加上限制条件 wrapper.last("LIMIT 1")
T getOne(Wrapper<T> queryWrapper);
// 根据 Wrapper，查询一条记录
T getOne(Wrapper<T> queryWrapper, boolean throwEx);
// 根据 Wrapper，查询一条记录
Map<String, Object> getMap(Wrapper<T> queryWrapper);
// 根据 Wrapper，查询一条记录
<V> V getObj(Wrapper<T> queryWrapper, Function<? super Object, V> mapper);
```

## MybatisPlus注解

### @TableName

设置实体类所对应的表名。

```java
@TableName("user")
```

也可以在配置文件中改：

```yaml
  #设置Mybatis-plus的全局配置
  global-config:
    db-config:
      # 设置实体类所对应的表的统一前缀
      table-prefix: 
```

### @TableId

这个注解用于设置主键。

MybatisPlus主键生成策略默认使用**雪花算法**（如果你在数据库中设置了自动递增但是MybatisPlus这里没有设置，它仍然使用的是雪花算法），我们可以使用`type`属性可以设置主键生成策略。主键生成策略有以下几种：

- AUTO(0)：使用自动递增。
- NONE(1)：该类型为未设置主键类型,默认使用雪花算法生成。
- INPUT(2)：由用户输入。
- ASSIGN_ID(3),：使用雪花算法。
- ASSIGN_UUID(4)：只有当用户未输入时，采用雪花算法**生成**一个适用于分布式环境的全局唯一**主键**，类型可以是String和number；

```java
    // 将属性所对应的字段指定为主键
    // value属性用于指定主键的字段
    // type属性可以设置主键生成策略
    @TableId(value = "id", type = IdType.AUTO)
```

可以在配置文件中改：

```yaml
  #设置Mybatis-plus的全局配置
  global-config:
    db-config:
      # 设置实体类所对应的表的统一前缀
      table-prefix:
      # 设置统一的主键生成策略
      id-type: auto
```

之前看到过一篇文章是说使用雪花算法生成的id效率不如自增的`id`来着。不过不管效率我还是觉得使用自增更舒服，不然看到`id`一大串看着膈应。

### @TableField

指定属性所对应的字段名。不过`MyBatisPlus`可以**自动将下划线命名风格转化为驼峰命名风格**。如果实在不行可以使用这个注解。

### @TableLogic

#### 逻辑删除

- 物理删除：真实删除，将对应数据从数据库中删除，之后查询不到此条被删除的数据。
- 逻辑删除：假删除，将对应的数据中代表是否被删除字段的状态修改为“被删除状态”，之后再数据库中仍旧能看到此条数据记录。
- 使用场景：可以进行数据恢复

实现：

数据库中新增一个一个字段`is_deleted`。

```java
    @TableLogic
    private Integer isDeleted;
```

此后我们的删除操作变成修改操作。将字段`is_deleted`的值修改。此时查询的值也不会存在假删除的这个数据。

**注意：**在增加了这个注解之后，`MyBatisPlus`将默认把删除变为假删除操作。

实际使用的逻辑删除就是使用`Update`操作，将`is_deleted`字段改变。

---

## **条件构造器**

可以看到我前面列出来的方法中出现了很多次`Wrapper<T> wrapper`这个玩意，这个玩意才是真正使用用的最多的。

![条件构造器](https://cos.asuka-xun.cc/blog/image-20220521092812125.png)

- `Wrapper` ： 条件构造抽象类，最顶端父类
- `AbstractWrapper `： 用于查询条件封装，生成 sql 的 where 条件
- `QueryWrapper `： 查询条件封装
- `UpdateWrapper `： Update 条件封装
- `AbstractLambdaWrapper `： 使用Lambda 语法
- `LambdaQueryWrapper `：用于Lambda语法使用的查询Wrapper
- `LambdaUpdateWrapper `： Lambda 更新封装Wrapper

### QueryWrapper

平时用的比较多的是这个。

看栗子理解。

- 

```java
    @Test
    public void test01() {
        // 查询用户名包含 雯，年龄在16到25之间，邮箱信息不为null的用户信息
        // SELECT id,name,age,email FROM user WHERE (name LIKE ? AND age BETWEEN ? AND ? AND email IS NOT NULL)
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.like("name", "雯")
                .between("age", 16, 25)
                .isNotNull("email");
        List<User> list = userMapper.selectList(queryWrapper);
        list.forEach(System.out::println);
    }
```

- 

```java
    @Test
    public void test02() {
        // 查询用户信息，按照年龄的降序排序，若年龄相同，则按照id升序排序
        // SELECT id,name,age,email FROM user ORDER BY age DESC,id ASC
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("age")
                .orderByAsc("id");
        List<User> users = userMapper.selectList(queryWrapper);
        users.forEach(System.out::println);
    }
```

- 

```java
    @Test
    public void test03() {
        // 删除邮箱地址为null的用户信息
        // DELETE FROM user WHERE (email IS NULL)
        // 我并没有使用假删除
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.isNull("email");
        int result = userMapper.delete(queryWrapper);
        System.out.println(result > 0 ? "删除成功！" : "删除失败！");
        System.out.println("受影响的行数为：" + result);
    }
```

- 

```java
    @Test
    public void test04() {
        // 将（年龄大于20并且用户名中包含有a）或邮箱为null的用户信息修改
        // UPDATE user SET name=?, email=? WHERE (age > ? AND name LIKE ? OR email IS NULL)
        UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
        // gt是大于
        updateWrapper.gt("age", 20)
                .like("name", "贝")
                .or()
                .isNull("email");
        User user = new User();
        user.setName("Oz");
        user.setEmail("test@oz6.com");

        // user
        int result = userMapper.update(user, updateWrapper);
        System.out.println(result > 0 ? "修改成功！" : "修改失败！");
        System.out.println("受影响的行数为：" + result);
    }
```

- 注意**lambda中的条件优先执行**
```java
@Test
public void test05() {
    // 将用户名中包含有 张 并且（年龄大于19或邮箱为null）的用户的信息修改
    // lambda中的条件优先执行
    // UPDATE user SET name=?, email=? WHERE (name LIKE ? AND (age > ? OR email IS NULL))
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.like("name", "张")
            .and(i -> i.gt("age", 18).or().isNull("email"));
    User user = new User();
    user.setName("test");
    user.setEmail("ttttt.@qq.com");
    int res = userMapper.update(user, queryWrapper);
    System.out.println("result:" + res);
}
```

- 

```java
    @Test
    public void test06() {
        // 查询用户的用户名、年龄、邮箱信息
        // SELECT name,age,email FROM user
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.select("name", "age", "email");
        List<Map<String, Object>> maps = userMapper.selectMaps(queryWrapper);
        maps.forEach(System.out::println);
    }
```

- 子查询

```java
    @Test
    public void test07() {
        // 子查询
        // 查询id小于等于100的用户信息
        // SELECT id,name,age,email FROM user WHERE (id IN (select id from user where id <= 100))
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.inSql("id", "select id from user where id <= 100");
        List<User> list = userMapper.selectList(queryWrapper);
        list.forEach(System.out::println);
    }
```

### UpdateWrapper

> `UpdateWrapper`不仅拥有`QueryWrapper`的组装条件功能，还提供了`set`方法进行修改对应条件的数据库信息

- 

```java
    @Test
    public void test08() {
        // 将用户名中包含有test并且（年龄大于18或邮箱为null）的用户信息修改邮箱
        // UPDATE user SET email=? WHERE (name LIKE ? AND (age > ? OR email IS NULL))
        UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
        updateWrapper.like("name", "test").and(i -> i.gt("age", 18).or().isNull("email")).set("email", "svip@qq.com");
        // 第一个参数为 null，不需要创建实体对象
        int result = userMapper.update(null, updateWrapper);
        System.out.println(result > 0 ? "修改成功！" : "修改失败！");
        System.out.println("受影响的行数为：" + result);
    }
```

### Condition

这个比较秀了，在处理一些复杂的情况会很有用。比如在进行搜索时，用户可以利用多个关键词进行搜索，但是一个用户不一定知道所有的关键词，所以用户查询的时候会有一些关键词不输入，这时候我们就可以利用`Condition`这种好东西来处理了。我们只把用户输入的关键词来进行搜索，用户没有输入的关键词字段我们不进行搜索。

下面这种就是我们平时进行关键词判断，只是用的`if`语句，没用到`Condition`。

```java
    @Test
    public void test09() {
        // SELECT id,name,age,email FROM user WHERE (age <= ?)
        String username = "";
        Integer ageBegin = null;
        Integer ageEnd = 25;
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        // StringUtils是MybatisPlus中的包
        if (StringUtils.isNotBlank(username)) {
            //isNotBlank判断某个字符创是否不为空字符串、不为null、不为空白符
            queryWrapper.like("name", username);
        }
        if (ageBegin != null) {
            queryWrapper.ge("age", ageBegin);
        }
        if (ageEnd != null) {
            queryWrapper.le("age", ageEnd);
        }
        List<User> list = userMapper.selectList(queryWrapper);
        list.forEach(System.out::println);
    }
```

`Condition`:

```java
@Test
public void test10() {
    // 动态组装条件
    // SELECT id,name,age,email FROM user WHERE (age <= ?)
    String username = "";
    Integer ageBegin = null;
    Integer ageEnd = 30;
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    // 看源代码会发现有个 condition 参数
    queryWrapper.like(StringUtils.isNotBlank(username), "name", username)
            .ge(ageBegin != null, "age", ageBegin)
            .le(ageEnd != null, "age", ageEnd);
    List<User> list = userMapper.selectList(queryWrapper);
    list.forEach(System.out::println);
}
```

### LambdaQueryWrapper

> 功能等同于QueryWrapper，提供了Lambda表达式的语法可以避免填错列名。

```java
@Test
public void test11(){
    String username = "a";
    Integer ageBegin = null;
    Integer ageEnd = 30;
    LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
    // 看源代码会发现有个 condition 参数
    queryWrapper.like(StringUtils.isNotBlank(username), User::getName, username)
        .ge(ageBegin != null, User::getAge, ageBegin)
        .le(ageEnd != null, User::getAge, ageEnd);
    List<User> list = userMapper.selectList(queryWrapper);
    list.forEach(System.out::println);
}
```

### LambdaUpdateWrapper

> 功能等同于UpdateWrapper，提供了Lambda表达式的语法可以避免填错列名。

```java
@Test
public void test12() {
    // 将用户名中包含有test并且（年龄大于18或邮箱为null）的用户信息修改邮箱
    // UPDATE user SET name=?,email=? WHERE (name LIKE ? AND (age > ? OR email IS NULL))
    LambdaUpdateWrapper<User> updateWrapper = new LambdaUpdateWrapper<>();
    updateWrapper.like(User::getName, "test").and(i -> i.gt(User::getAge, 18).or().isNull(User::getEmail));
    updateWrapper.set(User::getName, "雯").set(User::getEmail, "svip@qq.com");
    // 第一个参数为 null，不需要创建实体对象
    int result = userMapper.update(null, updateWrapper);
    System.out.println(result > 0 ? "修改成功！" : "修改失败！");
    System.out.println("受影响的行数为：" + result);
}
```

---

## **分页插件**

> MyBatis Plus自带分页插件，只要简单的配置即可实现分页功能。

```java
@Configuration
@MapperScan("com.expmale.mybatisplus.mapper")
public class MyBatisPlusConfig {
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor(){
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        //添加分页插件
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
```

使用：
```java
    @Test
    public void testPage() {
        // SELECT id,name,age,email FROM user LIMIT ?
        Page<User> page = userMapper.selectPage(new Page<>(1, 3), null);
        List<User> users = page.getRecords();
        users.forEach(System.out::println);
        System.out.println("当前页数为：" + page.getCurrent());
        System.out.println("总页数为：" + page.getPages());
        System.out.println("总数据量为：" + page.getTotal());
        System.out.println("页数大小为：" + page.getSize());
        System.out.println("是否有下一页：" + page.hasNext());
        System.out.println("是否有前一页：" + page.hasPrevious());
    }
```

` Page(long current, long size)`,第一个参数是当前页数，第二个是每页大小。

它还有个**自定义分页**：

```java
    @Test
    public void test2() {
        // 自定义分页
        // select id,name as name,age,email from user where age > ? LIMIT ?
        Page<User> page = userMapper.selectPageVo(new Page<>(1, 3), 18);
        List<User> users = page.getRecords();
        users.forEach(System.out::println);
        System.out.println("当前页数为：" + page.getCurrent());
        System.out.println("总页数为：" + page.getPages());
        System.out.println("总数据量为：" + page.getTotal());
        System.out.println("页数大小为：" + page.getSize());
        System.out.println("是否有下一页：" + page.hasNext());
        System.out.println("是否有前一页：" + page.hasPrevious());
    }
```

```java
/**
     * 根据年龄查询用户列表，分页显示
     * @param page 分页对象,xml中可以从里面进行取值,传递参数 Page 即自动分页,必须放在第一位
     * @param age 年龄
     * @return
     */
    Page<User> selectPageVo(@Param("page") Page<User> page, @Param("age") Integer age);

```

```xml
<select id="selectPageVo" resultType="com.exp.mybatisplus.pojo.User">
    select id,name as name,age,email from user where age > #{age}
</select>
```

---

好了，`MyBatisPlus`写到这。也学到这，用的比较多的应该也就是我上面说的那些东西了吧，做这些笔记自己也方便查看。
