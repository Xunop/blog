---
title: Redis基础内容
cover: https://cos.asuka-xun.cc/blog/assets/redis.jpg
date: 2022/5/10 14:23
categories:
- [数据库]
tags:
- Redis
---
## Redis

`redis-cli`

`./redis-server`看你redis安装到哪的吧，这样启动的话是启动啊的默认配置。

`./redis-server redis.conf`你可以带上你的配置路径启动。

`shutdown`关闭redis服务。

`exit`退出连接。

## key键操作

- `keys *` 查看redis中的所有key

- `exists key` 判断是否存在这个key。

- `del key` 删除这个key数据。

- `unlink key` 根据value选择非阻塞删除，仅从keys从keyspace元数据中删除，真正的删除会在后续异步操作。

- `type key` 查看key是什么类型

- `expire key 10` 为给定的key设置过期时间。

- `ttl key` 查看还有多少秒过期，-1表示永不过期，-2表示已过期。

> `select`切换数据库
> 
> `dbsize`查看当前数据库的key的数量
> 
> `flushall`通杀当前库
> 
> `flushdb`清空当前库

## redis数据类型

Redis支持五种数据类型：string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)。

### String字符串

string 是 redis 最基本的类型，你可以理解成与 Memcached 一模一样的类型，一个 key 对应一个 value。

string 类型是二进制安全的。意思是 redis 的 string 可以包含任何数据。比如jpg图片或者序列化的对象。

string 类型是 Redis 最基本的数据类型，string 类型的值最大能存储 512MB。

```
redis 127.0.0.1:6379> SET runoob "菜鸟教程"
OK
redis 127.0.0.1:6379> GET runoob
"菜鸟教程"
```

> 第一个数key、 第二个是value。

#### 常用命令：

`mset<key1><value><key2><value2>`....同时设置一个或多个key-value对

`mget<key1><key2><key3>`....同时获取一个或多个value

`msetnx<key1><value1><key2><value2>`同时设置一个或多个key-value对，当且仅当所有给定key都不存在。**原子性，有一个失败时全部失败**

`getrange<key><起始位置><结束位置>`获取值的范围，类似java中的substring，前包，后包。

`setrange<key><起始位置><value>`用<value>覆写所储存的字符串值，从起始位置开始索引从0到

`setex<key><过期时间><value>`设置键值的同时，设置过期时间，单位秒。

`getset<key><value>`设置新值的同时

### Hash（哈希）

Redis hash 是一个键值(key=>value)对集合。

Redis hash 是一个 string 类型的 field 和 value 的映射表，hash 特别适合用于存储对象。

```
redis 127.0.0.1:6379> DEL runoob
redis 127.0.0.1:6379> HMSET runoob field1 "Hello" field2 "World"
"OK"
redis 127.0.0.1:6379> HGET runoob field1
"Hello"
redis 127.0.0.1:6379> HGET runoob field2
"World"
```

> DEL runoob 用于删除前面测试用过的 key，不然会报错：**(error) WRONGTYPE Operation against a key holding the wrong kind of value**。
> 
> 实例中我们使用了 Redis **HMSET, HGET** 命令，**HMSET** 设置了两个 field=>value 对, HGET 获取对应 **field** 对应的 **value**。
> 
> 每个 hash 可以存储 232 -1 键值对（40多亿）。

redis中的hash有些不一样，它的值可以有很多种

![background picture2022-05-10-13-16-47-image.png](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-10-13-16-47-image.png)

有这几种使用方法：

![background picture2022-05-10-13-23-09-image.png](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-10-13-23-09-image.png)

第三中比较好。

#### 常用命令：

- `hset <key><field><value>`给`<key>`集合中的 `<field>`键赋值`<value>`

- `hget <key1><field>` 从`<key1>`集合`<field>`取出 `value`

- `hmset<key1><field><value1><field2><value2>`... 批量设置hash的值

- `hexists <key1><field>`查看哈希表`key`中，给定域 `field` 是否存在

- `hkeys <key>`列出该hash集合的所有`field`

- `hvals <key>`列出该hash集合中的所有`value`

- `hincrby <key><field><increment(这里是需要加多少)>`为哈希表 `key`中的域`field`的值加上增量1 -1

- `hsetnx <key><field><value>`将哈希表中的 `key`中的域`field`的值设置为`value`当且仅当域`field`不存在。

### List（列表）

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。`lpush`

```
redis 127.0.0.1:6379> DEL runoob
redis 127.0.0.1:6379> lpush runoob redis
(integer) 1
redis 127.0.0.1:6379> lpush runoob mongodb
(integer) 2
redis 127.0.0.1:6379> lpush runoob rabbitmq
(integer) 3
redis 127.0.0.1:6379> lrange runoob 0 10
1) "rabbitmq"
2) "mongodb"
3) "redis"
redis 127.0.0.1:6379>
```

#### 常用命令：

> `lpush`/`rpush`<key1><vlaue1><value2><value3>...从左边/右边插入一个或多个值。k1是从左边放，k2是从右边 放。跟栈那样的前面放进去的被压到后面去。
> 
> ![background picture2022-05-10-12-40-41-image.png](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-10-12-40-41-image.png)
> 
> `lpop`/`rpop<key>`从左边或者右边取出一个值，值在键在，值光键亡。
> 
> `rpoplpush<key1><key2>`从<key1>列表右边吐出一个值，插到<key2>列表左边。
> 
> `lrange<key><start><stop>`按照索引下标获得元素（从左到右）
> 
> `lrange mylist 0 -1` 0 左边第一个， -1 右边第一个，（0-1代表获取所有  ）
> 
> `lindex<key1><index>`按照索引下标获得元素（从左到右）
> 
> `llen<key>`获取列表长度
> 
> `linsert<key> before <value><newvalue>`在`<value>`的后面插入`<newvalue>`插入值
> 
> `lrem<key><n><value>`从左边杀出n个value(从左到右)
> 
> `lset<key><index><value>`将列表key下标为index的值替换为value

### Redis集合（set）

> Redis 的 Set 是 String 类型的无序集合。集合成员是唯一的，这就意味着集合中不能出现重复的数据。

> 集合对象的编码可以是 intset 或者 hashtable。

> Redis 中集合是通过哈希表实现的，所以添加，删除，查找的**复杂度都是 O(1)**。

> 集合中最大的成员数为 232 - 1 (4294967295, 每个集合可存储40多亿个成员)。

#### 常用命令：

| 序号  | 命令及描述                                                                                                                |
| --- | -------------------------------------------------------------------------------------------------------------------- |
| 1   | [SADD key member1 [member2]](https://www.redis.net.cn/order/3594.html) 向集合添加一个或多个成员                                  |
| 2   | [SCARD key](https://www.redis.net.cn/order/3595.html) 获取集合的成员数                                                       |
| 3   | [SDIFF key1 [key2]](https://www.redis.net.cn/order/3596.html) 返回给定所有集合的差集                                            |
| 4   | [SDIFFSTORE destination key1 [key2]](https://www.redis.net.cn/order/3597.html) 返回给定所有集合的差集并存储在 destination 中         |
| 5   | [SINTER key1 [key2]](https://www.redis.net.cn/order/3598.html) 返回给定所有集合的交集                                           |
| 6   | [SINTERSTORE destination key1 [key2]](https://www.redis.net.cn/order/3599.html) 返回给定所有集合的交集并存储在 destination 中        |
| 7   | [SISMEMBER key member](https://www.redis.net.cn/order/3600.html) 判断 member 元素是否是集合 key 的成员                           |
| 8   | [SMEMBERS key](https://www.redis.net.cn/order/3601.html) 返回集合中的所有成员                                                  |
| 9   | [SMOVE source destination member](https://www.redis.net.cn/order/3602.html) 将 member 元素从 source 集合移动到 destination 集合 |
| 10  | [SPOP key](https://www.redis.net.cn/order/3603.html) 移除并返回集合中的一个随机元素                                                 |
| 11  | [SRANDMEMBER key [count]](https://www.redis.net.cn/order/3604.html) 返回集合中一个或多个随机数                                    |
| 12  | [SREM key member1 [member2]](https://www.redis.net.cn/order/3605.html) 移除集合中一个或多个成员                                  |
| 13  | [SUNION key1 [key2]](https://www.redis.net.cn/order/3606.html) 返回所有给定集合的并集                                           |
| 14  | [SUNIONSTORE destination key1 [key2]](https://www.redis.net.cn/order/3607.html) 所有给定集合的并集存储在 destination 集合中         |
| 15  | [SSCAN key cursor [MATCH pattern] [COUNT count]](https://www.redis.net.cn/order/3608.html) 迭代集合中的元素                  |

### Redis有序集合Zset(sorted set)

Redis 有序集合和集合一样也是 string 类型元素的集合,且不允许重复的成员。

**不同的是每个元素都会关联一个 double 类型的分数。redis 正是通过分数来为集合中的成员进行从小到大的排序。**（这个就是数据的重要程度）

有序集合的成员是唯一的,但分数(score)却可以重复。

集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。 集合中最大的成员数为 232 - 1 (4294967295, 每个集合可存储40多亿个成员)。

#### 常用命令：

- `zadd <key><score1><value1><score2><value2>`...将一个或多个 member 元素及其 score 值加入到有序集key中。

- `zrange <key><start><stop>[WITHSCORES]`返回有序集 key 中， 下标在`<start><stop>`之间的元素，后面那个`WITHSCORES`，可以把分数也给返回，不加就不返回。

- `zrangebyscore key minmax [withscores][limit offset count]`返回有序集key中，所有`score`值介于 min 和 max 之（包括等于 min 或 max ）的成员。有序集成员按 score值递增（从小到大）次序排列。

- `zrevrangebyscore key maxmin [withscores][limit offset count]`改为从大到小排列。

- `zincrby <key><increment(需要增加的值10或者20等等)><value>` 为元素的score加上增量。

- `zrem <key><value>` 删除该集合下，指定值的元素。

- `zocunt <key><min><max>`统计该集合，分数区间的元素个数。

- `zrank <key><value>`返回该值在集合中的排名，从0开始。就是相当于我们平时的第一名就是它的第0名。

底层实现：

- 跳跃表

- hash 

### Bitmaps

BitMap 原本的含义是用一个比特位来映射某个元素的状态。由于一个比特位只能表示 0 和 1 两种状态，所以 BitMap 能映射的状态有限，但是使用比特位的优势是能**大量的节省内存空间**。

在 Redis 中，可以把 Bitmaps 想象成一个以比特位为单位的数组，数组的每个单元只能存储0和1，数组的下标在 Bitmaps 中叫做偏移量。

举个例子:当你选择判断用户浏览量的时候![](https://cos.asuka-xun.cc/blog%2F2022-05-10-20-38-45-image.png)

#### 一些简单命令：

```
# 设置值，其中value只能是 0 和 1
setbit key offset value

# 获取值
getbit key offset

# 获取指定范围内值为 1 的个数
# start 和 end 以字节为单位
bitcount key start end

# BitMap间的运算
# operations 位移操作符，枚举值
  AND 与运算 &
  OR 或运算 |
  XOR 异或 ^
  NOT 取反 ~
# result 计算的结果，会存储在该key中
# key1 … keyn 参与运算的key，可以有多个，空格分割，not运算只能一个key
# 当 BITOP 处理不同长度的字符串时，较短的那个字符串所缺少的部分会被看作 0。返回值是保存到 destkey 的字符串的长度（以字节byte为单位），和输入 key 中最长的字符串长度相等。
bitop [operations] [result] [key1] [keyn…]

# 返回指定key中第一次出现指定value(0/1)的位置
bitpos [key] [value]
```

### HyperLogLog

**主要用于解决基数问题**

Redis HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小的。

在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基 数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。![](https://cos.asuka-xun.cc/blog%2F2022-05-10-20-41-11-image.png)

什么叫基数？

![](https://cos.asuka-xun.cc/blog%2F2022-05-10-20-41-33-image.png)

就是数据集中不重复的个数的数量，这里是5个，13578嘛

#### 常用命令：

能去重，这里最后面加了一个Java但是是0

![](https://cos.asuka-xun.cc/blog%2F2022-05-10-20-44-24-image.png)

HLL就是**HyperLogLog**

- `pfadd<key><element>[element...]`添加指定元素到HyperLogLog中。可以加多个。成功就是1，失败就是0.![](https://cos.asuka-xun.cc/blog%2F2022-05-10-20-46-20-image.png)

- `pfcount<key>[key...]`计算HLL的近似基数，可以计算多个HLL，比如用HLL储存梅泰诺的UV，计算一周的UV可以使用七天之和。

- `pfmerge<destkey><sourcekey>[sourcekey...]`将一个或多个HLL合并后的结果存储在另一个HLL中，比如每月活跃用户可以使用每天的活跃用户合并计算可得。

### Geographic

Redis GEO 主要用于存储地理位置信息，并对存储的信息进行操作。![](https://cos.asuka-xun.cc/blog%2F2022-05-10-21-03-05-image.png)

#### 常用命令：

- `geoadd<key><longitude><latitude><member>[longitude latitude member...]`：添加地理位置的坐标(经度，纬度，名称)。
  
  例如：
  
  ```
  GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
  (integer) 2
  ```

- `geopos<key><member>[member...]`：获取地理位置的坐标。

- `geodist<key><member1><member2> [m|km|ft|mi]`：计算两个位置之间的距离。![](https://cos.asuka-xun.cc/blog%2F2022-05-10-21-37-01-image.png)

- `georadius<key><longitude><latitude><latitude>radius m|km|ft|mi`：根据用户给定的经纬度坐标来获取指定范围内的地理位置集合。以给定得经纬度为中心，找出某一半径内的元素。

- georadiusbymember：根据储存在位置集合里面的某个地点获取指定范围内的地理位置集合。

- geohash：返回一个或多个位置对象的 geohash 值。

## Redis配置文件

看尚硅谷视频区第13集

## Redis发布订阅

![](https://cos.asuka-xun.cc/blog%2F2022-05-10-18-16-55-image.png)

## 事务和锁机制

### 基本操作

- `multi`

- `exec`

- `discard`

![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-11-10-30-13-image.png)

![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-11-10-37-12-image.png)**注意：** 

- 组队中某个命令出现了报告错误，执行时整个的所有队列都会被取消![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-11-10-37-45-image.png)

- 如果执行阶段某个命令报出了错误，则只有报错的命令不会被执行，而其他命令都会执行，不会回滚。

### 事务冲突

  例子：

![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-11-10-41-12-image.png)

#### 悲观锁

悲观锁：悲观锁在操作数据时比较悲观，认为别人会同时修改数据。因此操作数据时直接把数据锁住，直到操作完成后才会释放锁；上锁期间其他人不能修改数据。（效率比较底下）

#### 乐观锁

乐观锁：乐观锁在操作数据时非常乐观，认为别人不会同时修改数据。因此乐观锁不会上锁，只是在执行更新的时候判断一下在此期间别人是否修改了数据：如果别人修改了数据则放弃操作，否则执行操作。

## Springboot整合redis

导入依赖

```
      <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>    
```

配置文件

```
spring:
  redis:
    # 地址
    host: 192.168.56.102
    # 端口号
    port: 3306
    # 密码
    password: 123456
    # 超时时间，单位毫秒
    timeout: 3000
    # 数据库编号
    database: 0
    # 配置lettuce
    lettuce:
      pool:
        # 连接池中的最小空闲连接
        min-idle: 1
        # 连接池中的最大空闲连接
        max-idle: 6
        # 连接池最大连接数（使用负值表示没有限制,不要配置过大，否则可能会影响redis的性能）
        max-active: 10
        # 连接池最大阻塞等待时间（使用负值表示没有限制）；单位毫秒
        max-wait: 1000
      #关闭超时时间；单位毫秒
      shutdown-timeout: 200
```

### 操作不同的数据类型

```
    @Autowired
    private StringRedisTemplate stringRedisTemplate;//操作不同的数据类型
```

`StringRedisTemplate`key和value都是String。

` RedisTemplate`这个就不太一样了，不过这个使用的范围更大。

然后上面那个对象具有这些方法：

```
        stringRedisTemplate.opsForValue();//操作字符串，类似String
        stringRedisTemplate.opsForList();//操作List，类似List
        stringRedisTemplate.opsForGeo();//操作Geo，地图
        stringRedisTemplate.opsForHash();//Hash
        stringRedisTemplate.opsForSet();//Set集合
        stringRedisTemplate.opsForHyperLogLog();//hll
```

这些方法操作redis的数据类型，举个例子：

```
String kc = stringRedisTemplate.opsForValue().get(kcKey);
```

这是操作字符串，get();

### 获取redis连接对象

可以对数据库进行操作

```
        RedisConnection connection = redisTemplate.getConnectionFactory().getConnection();
        connection.flushDb();
        connection.flushAll();
```

### 传递对象

redis传递对象必须序列化。

我们可以借助fasterxml.jackson的依赖包中的`new ObjectMapper().writeValueAsString()`进行序列化。

```
@Test
    void test1() throws JsonProcessingException {
        RedisConnection connection = redisTemplate.getConnectionFactory().getConnection();
        connection.flushDb();
        User user = new User("xxx", 88);
//        String jsonUser = new ObjectMapper().writeValueAsString(user);
        redisTemplate.opsForValue().set("user", user);
        System.out.println(redisTemplate.opsForValue().get("user"));
    }
```

这里把那个注释掉了，就会报错。

还有一个办法就是 ![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-11-21-59-40-image.png)

pojo类继承这个东西。但是这个json的格式是jdk版本的。

### springbootredis配置

```
@Configuration
public class RedisConfig {
    //编写自己的 redisTemplate
    @Bean(name = "template")
    public RedisTemplate<String, Object> template(RedisConnectionFactory factory) {
        // 创建RedisTemplate<String, Object>对象
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        // 配置连接工厂
        template.setConnectionFactory(factory);
        // 定义Jackson2JsonRedisSerializer序列化对象
        Jackson2JsonRedisSerializer<Object> jacksonSeial = new Jackson2JsonRedisSerializer<>(Object.class);
        ObjectMapper om = new ObjectMapper();
        // 指定要序列化的域，field,get和set,以及修饰符范围，ANY是都有包括private和public
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        // 指定序列化输入的类型，类必须是非final修饰的，final修饰的类，比如String,Integer等会报异常
        om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        jacksonSeial.setObjectMapper(om);
        StringRedisSerializer stringSerial = new StringRedisSerializer();
        // redis key 序列化方式使用stringSerial
        template.setKeySerializer(stringSerial);
        // redis value 序列化方式使用jackson
        template.setValueSerializer(jacksonSeial);
        // redis hash key 序列化方式使用stringSerial
        template.setHashKeySerializer(stringSerial);
        // redis hash value 序列化方式使用jackson
        template.setHashValueSerializer(jacksonSeial);
        template.afterPropertiesSet();
        return template;
    }
}
```

直接抄的网上的配置。

## Redis配置

存放在Redis安装目录下。

`redis.conf`

`daemonize no` Redis 默认不是以守护进程的方式运行，可以通过该配置项修改，使用 yes 启用守护进程（Windows 不支持守护线程的配置为 no ）

`pidfile /var/run/redis.pid`当 Redis 以守护进程方式运行时，Redis 默认会把 pid 写入 /var/run/redis.pid 文件，可以通过 pidfile 指定

`port 6379` 指定 Redis 监听端口，默认端口为 6379，作者在自己的一篇博文中解释了为什么选用 6379 作为默认端口，因为 6379 在手机按键上 MERZ 对应的号码，而 MERZ 取自意大利歌女 Alessia Merz 的名字

`bind 127.0.0.1`绑定的主机地址,我把它注释掉了，说明谁都可以访问。

`protected-mode yes`这个是保护模式，应该改成no不然无法访问。

直接搬redis中文网：

### 常用配置参数说明

redis.conf 配置项说明如下：

1. Redis 默认不是以守护进程的方式运行，可以通过该配置项修改，使用 yes 启用守护进程

    **daemonize no**

2. 当 Redis 以守护进程方式运行时，Redis 默认会把 pid 写入 /var/run/redis.pid 文件，可以通过 pidfile 指定

    **pidfile /var/run/redis.pid**

3. 指定 Redis 监听端口，默认端口为 6379，作者在自己的一篇博文中解释了为什么选用 6379 作为默认端口，因为 6379 在手机按键上 MERZ 对应的号码，而 MERZ 取自意大利歌女 Alessia Merz 的名字

    **port 6379**

4. 绑定的主机地址

    **bind 127.0.0.1**

5. 当客户端闲置多长时间后关闭连接，如果指定为 0，表示关闭该功能

    **timeout 300**

6. 指定日志记录级别，Redis 总共支持四个级别：debug、verbose、notice、warning，默认为 verbose

    **loglevel verbose**

7. 日志记录方式，默认为标准输出，如果配置 Redis 为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给 /dev/null

    **logfile stdout**

8. 设置数据库的数量，默认数据库为 0，可以使用 SELECT `<dbid>` 命令在连接上指定数据库 id

    **databases 16**

9. 指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合

    **save `<seconds>` `<changes>`**

    Redis 默认配置文件中提供了三个条件：

    **save 900 1**

 **save 300 10**

 **save 60 10000**

分别表示 90 0 秒（15 分钟）内有 1 个更改，300 秒（5 分钟）内有 10 个更改以及 60 秒内有 10000 个更改。

10. 指定存储至本地数据库时是否压缩数据，默认为 yes，Redis 采用 LZF 压缩，如果为了节省 CPU 时间，可以关闭该选项，但会导致数据库文件变的巨大

    **rdbcompression yes**

11. 指定本地数据库文件名，默认值为 dump.rdb

    **dbfilename dump.rdb**

12. 指定本地数据库存放目录

    **dir ./**

13. 设置当本机为 slave 服务时，设置 master 服务的 IP 地址及端口，在 Redis 启动时，它会自动从 master 进行数据同步

    **slaveof `<masterip>` `<masterport>`**

14. 当 master 服务设置了密码保护时，slave 服务连接 master 的密码

    **masterauth `<master-password>`**

15. 设置 Redis 连接密码，如果配置了连接密码，客户端在连接 Redis 时需要通过 AUTH `<password>`命令提供密码，默认关闭

    **requirepass foobared**

16. 设置同一时间最大客户端连接数，默认无限制，Redis 可以同时打开的客户端连接数为 Redis 进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis 会关闭新的连接并向客户端返回 max number of clients reached 错误信息

    **maxclients 128**

17. 指定 Redis 最大内存限制，Redis 在启动时会把数据加载到内存中，达到最大内存后，Redis 会先尝试清除已到期或即将到期的 Key，当此方法处理后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。Redis 新的 vm 机制，会把 Key 存放内存，Value 会存放在 swap 区

    **maxmemory `<bytes>`**

18. 指定是否在每次更新操作后进行日志记录，Redis 在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis 本身同步数据文件是按上面 save 条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为 no

    **appendonly no**

20. 指定更新日志文件名，默认为 appendonly.aof

     **appendfilename appendonly.aof**

21. 指定更新日志条件，共有 3 个可选值：    
   **no**：表示等操作系统进行数据缓存同步到磁盘（快）    
   **always**：表示每次更新操作后手动调用 fsync() 将数据写到磁盘（慢，安全） **everysec**：表示每秒同步一次（折衷，默认值）

    **appendfsync everysec**

22. 指定是否启用虚拟内存机制，默认值为 no，简单的介绍一下，VM 机制将数据分页存放，由 Redis 将访问量较少的页即冷数据 swap 到磁盘上，访问多的页面由磁盘自动换出到内存中（在后面的文章我会仔细分析 Redis 的 VM 机制）

     **vm-enabled no**

24. 虚拟内存文件路径，默认值为 /tmp/redis.swap，不可多个 Redis 实例共享

     **vm-swap-file /tmp/redis.swap**

25. 将所有大于 vm-max-memory 的数据存入虚拟内存,无论 vm-max-memory 设置多小,所有索引数据都是内存存储的( Redis 的索引数据就是 keys ),也就是说,当 vm-max-memory 设置为 0 的时候,其实是所有 value 都存在于磁盘。默认值为 0

     **vm-max-memory 0**

26. Redis swap 文件分成了很多的 page，一个对象可以保存在多个 page 上面，但一个 page 上不能被多个对象共享，vm-page-size 是要根据存储的数据大小来设定的，作者建议如果存储很多小对象，page 大小最好设置为 32 或者 64 bytes；如果存储很大大对象，则可以使用更大的 page，如果不确定，就使用默认值

     **vm-page-size 32**

27. 设置 swap 文件中的 page 数量，由于页表（一种表示页面空闲或使用的 bitmap）是在放在内存中的，在磁盘上每 8 个 pages 将消耗 1byte 的内存。

     **vm-pages 134217728**

28. 设置访问 swap 文件的线程数,最好不要超过机器的核数,如果设置为 0,那么所有对 swap 文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为 4

     **vm-max-threads 4**

29. 设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启

    **glueoutputbuf yes**

30. 指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法

    **hash-max-zipmap-entries 64**

 **hash-max-zipmap-value 512**

31. 指定是否激活重置哈希，默认为开启（后面在介绍 Redis 的哈希算法时具体介绍）

    **activerehashing yes**

32. 指定包含其它的配置文件，可以在同一主机上多个 Redis 实例之间使用同一份配置文件，而同时各个实例又拥有自己的特定配置文件

    **include /path/to/local.conf**

## Redis持久化（cv）

### redis持久化RDB

RDB 方式，是将 redis 某一时刻的数据持久化到磁盘中，是一种快照式的持久化方法。

redis 在进行数据持久化的过程中，会先将数据写入到一个临时文件中，待持久化过程都结束了，才会用这个临时文件替换上次持久化好的文件。正是这种特性，让我们可以随时来进行备份，因为快照文件总是完整可用的。

对于 RDB 方式，redis 会单独创建（fork）一个子进程来进行持久化，而主进程是不会进行任何 IO 操作的，这样就确保了 redis 极高的性能。

如果需要进行大规模数据的恢复，且对于数据恢复的完整性不是非常敏感，那 RDB 方式要比 AOF 方式更加的高效。

虽然 RDB 有不少优点，但它的缺点也是不容忽视的。如果你对数据的完整性非常敏感，那么 RDB 方式就不太适合你，因为即使你每 5 分钟都持久化一次，当 redis 故障时，仍然会有近 5 分钟的数据丢失。所以，redis 还提供了另一种持久化方式，那就是 AOF。

![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-12-19-58-28-image.png)

![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-12-19-48-59-image.png)

![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-12-19-57-16-image.png)

### redis持久化  AOF

AOF，英文是 Append Only File，即只允许追加不允许改写的文件。

如前面介绍的，AOF 方式是将执行过的写指令记录下来，在数据恢复时按照从前到后的顺序再将指令都执行一遍，就这么简单。

我们通过配置 `redis.conf` 中的 `appendonly yes` 就可以打开 AOF 功能。如果有写操作（如 SET 等），redis 就会被追加到 AOF 文件的末尾。默认不开启。

默认的 AOF 持久化策略是每秒钟 fsync 一次（fsync 是指把缓存中的写指令记录到磁盘中），因为在这种情况下，redis 仍然可以保持很好的处理性能，即使 redis 故障，也只会丢失最近 1 秒钟的数据。

如果在追加日志时，恰好遇到磁盘空间满、inode 满或断电等情况导致日志写入不完整，也没有关系，redis 提供了 redis-check-aof 工具，可以用来进行日志修复。

因为采用了追加方式，如果不做任何处理的话，AOF 文件会变得越来越大，为此，redis 提供了 AOF 文件重写（rewrite）机制，即当 AOF 文件的大小超过所设定的阈值时，redis 就会启动 AOF 文件的内容压缩，只保留可以恢复数据的最小指令集。举个例子或许更形象，假如我们调用了 100 次 INCR 指令，在 AOF 文件中就要存储 100 条指令，但这明显是很低效的，完全可以把这 100 条指令合并成一条 SET 指令，这就是重写机制的原理。

在进行 AOF 重写时，仍然是采用先写临时文件，全部完成后再替换的流程，所以断电、磁盘满等问题都不会影响 AOF 文件的可用性，这点大家可以放心。

AOF 方式的另一个好处，我们通过一个“场景再现”来说明。某同学在操作 redis 时，不小心执行了 FLUSHALL，导致 redis 内存中的数据全部被清空了，这是很悲剧的事情。不过这也不是世界末日，只要 redis 配置了 AOF 持久化方式，且 AOF 文件还没有被重写（rewrite），我们就可以用最快的速度暂停 redis 并编辑 AOF 文件，将最后一行的 FLUSHALL 命令删除，然后重启 redis，就可以恢复 redis 的所有数据到 FLUSHALL 之前的状态了。是不是很神奇，这就是 AOF 持久化方式的好处之一。但是如果 AOF 文件已经被重写了，那就无法通过这种方法来恢复数据了。

虽然优点多多，但 AOF 方式也同样存在缺陷，比如在同样数据规模的情况下，AOF 文件要比 RDB 文件的体积大。而且，AOF 方式的恢复速度也要慢于 RDB 方式。

如果你直接执行 BGREWRITEAOF 命令，那么 redis 会生成一个全新的 AOF 文件，其中便包括了可以恢复现有数据的最少的命令集。

如果运气比较差，AOF 文件出现了被写坏的情况，也不必过分担忧，redis 并不会贸然加载这个有问题的 AOF 文件，而是报错退出。这时可以通过以下步骤来修复出错的文件：

1. 备份被写坏的 AOF 文件\ 

2. 运行 `redis-check-aof –fix` 进行修复\ 

3. 用 diff -u 来看下两个文件的差异，确认问题点\ 

4. 重启 redis，加载修复后的 AOF 文件。

![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-12-20-17-12-image.png)

### Redis持久化 – AOF重写

AOF 重写的内部运行原理，我们有必要了解一下。

在重写即将开始之际，redis 会创建（fork）一个“重写子进程”，这个子进程会首先读取现有的 AOF 文件，并将其包含的指令进行分析压缩并写入到一个临时文件中。

与此同时，主工作进程会将新接收到的写指令一边累积到内存缓冲区中，一边继续写入到原有的 AOF 文件中，这样做是保证原有的 AOF 文件的可用性，避免在重写过程中出现意外。

当“重写子进程”完成重写工作后，它会给父进程发一个信号，父进程收到信号后就会将内存中缓存的写指令追加到新 AOF 文件中。

当追加结束后，redis 就会用新 AOF 文件来代替旧 AOF 文件，之后再有新的写指令，就都会追加到新的 AOF 文件中了。

### redis持久化 – 如何选择RDB和AOF

对于我们应该选择 RDB 还是 AOF，官方的建议是两个同时使用。这样可以提供更可靠的持久化方案。

## Redis发布订阅

- [Redis Unsubscribe 命令](https://www.redis.net.cn/order/3637.html)
- [Redis Subscribe 命令](https://www.redis.net.cn/order/3636.html)
- [Redis Pubsub 命令](https://www.redis.net.cn/order/3633.html)
- [Redis Punsubscribe 命令](https://www.redis.net.cn/order/3635.html)
- [Redis Publish 命令](https://www.redis.net.cn/order/3634.html)
- [Redis Psubscribe 命令](https://www.redis.net.cn/order/3632.html)

## Redis主从复制

打开几个端口给redis运行。这是在一台服务器上。

增加几个配置文件给redis。

注意配置文件中需要更改一些东西。

`info replication`

![](https://cos.asuka-xun.cc/blog%2Fredis%2F2022-05-12-20-51-05-image.png)

### 一主二从

默认情况，每台redis都是主节点。

设置主节点

`SLAVEOF 127.0.0.1 6379` 以这样的格式。

真是配置去配置文件中配置。这将会是永久的。

### 哨兵模式

#### 哨兵模式原理

哨兵模式是一种特殊的模式，Redis 为其提供了专属的哨兵命令，它是一个独立的进程，能够独立运行。下面使用 Sentinel 搭建 Redis 集群，基本结构图如下所示：  

![哨兵模式](https://cos.asuka-xun.cc/blog/uissddff.jpg)  
图1：哨兵基本模式

在上图过程中，哨兵主要有两个重要作用：

- 第一：哨兵节点会以每秒一次的频率对每个 Redis 节点发送`PING`命令，并通过 Redis 节点的回复来判断其运行状态。
- 第二：当哨兵监测到主服务器发生故障时，会自动在从节点中选择一台将机器，并其提升为主服务器，然后使用 PubSub 发布订阅模式，通知其他的从节点，修改配置文件，跟随新的主服务器。

在实际生产情况中，Redis Sentinel 是集群的高可用的保障，为避免 Sentinel 发生意外，它一般是由 3～5 个节点组成，这样就算挂了个别节点，该集群仍然可以正常运转。其结构图如下所示：  

![Redis哨兵模式](https://cos.asuka-xun.cc/blog/sdfb.jpg)  
图2：多哨兵模式

上图所示，多个哨兵之间也存在互相监控，这就形成了多哨兵模式，现在对该模式的工作过程进行讲解，介绍如下：  

##### 1) 主观下线

主观下线，适用于主服务器和从服务器。如果在规定的时间内(配置参数：down-after-milliseconds)，Sentinel 节点没有收到目标服务器的有效回复，则判定该服务器为“主观下线”。比如 Sentinel1 向主服务发送了`PING`命令，在规定时间内没收到主服务器`PONG`回复，则 Sentinel1 判定主服务器为“主观下线”。  

##### 2) 客观下线

客观下线，只适用于主服务器。 Sentinel1 发现主服务器出现了故障，它会通过相应的命令，询问其它 Sentinel 节点对主服务器的状态判断。如果超过半数以上的  Sentinel 节点认为主服务器 down 掉，则 Sentinel1 节点判定主服务为“客观下线”。  

##### 3) 投票选举

投票选举，所有 Sentinel 节点会通过投票机制，按照谁发现谁去处理的原则，选举 Sentinel1 为领头节点去做 Failover（故障转移）操作。Sentinel1 节点则按照一定的规则在所有从节点中选择一个最优的作为主服务器，然后通过发布订功能通知其余的从节点（slave）更改配置文件，跟随新上任的主服务器（master）。至此就完成了主从切换的操作。

#### 配置哨兵模式

`vim sentinel.conf`

1. 创建配置。

在配置中写:

```
#sentinel monitor 被监控的名称 host port 1
sentinel monitor myredis 127.0.0.1 6379 1
```

后面那个1是投票数，当主节点挂后，哨兵将给这个从节点投票看谁票数最多，最多的将成为主节点。（有个投票算法）

2. 启动哨兵

```
redis-sentinel 配置文件路径
```

如果主节点回来，所以以前的从节点全部转回从节点。

哨兵模式优点：

1. 哨兵集群，基于主从复制模式，所有的主从配置优点全有。
2. 主从可以切换，故障可以转移，系统可用性更好。
3. 哨兵模式为主从模式的升级，手动到自动，更为健壮。

哨兵模式缺点：

1. Redis在线扩容不太友好，集群容量一旦到大上限，在线扩容会十分麻烦
2. 实现哨兵模式的配置麻烦。

完整的哨兵模式配置文件 sentinel.conf

```
# Example sentinel.conf

# 哨兵sentinel实例运行的端口 默认26379
port 26379

# 哨兵sentinel的工作目录
dir /tmp

# 哨兵sentinel监控的redis主节点的 ip port 
# master-name  可以自己命名的主节点名字 只能由字母A-z、数字0-9 、这三个字符".-_"组成。
# quorum 当这些quorum个数sentinel哨兵认为master主节点失联 那么这时 客观上认为主节点失联了
# sentinel monitor <master-name> <ip> <redis-port> <quorum>
sentinel monitor mymaster 127.0.0.1 6379 1

# 当在Redis实例中开启了requirepass foobared 授权密码 这样所有连接Redis实例的客户端都要提供密码
# 设置哨兵sentinel 连接主从的密码 注意必须为主从设置一样的验证密码
# sentinel auth-pass <master-name> <password>
sentinel auth-pass mymaster MySUPER--secret-0123passw0rd


# 指定多少毫秒之后 主节点没有应答哨兵sentinel 此时 哨兵主观上认为主节点下线 默认30秒
# sentinel down-after-milliseconds <master-name> <milliseconds>
sentinel down-after-milliseconds mymaster 30000

# 这个配置项指定了在发生failover主备切换时最多可以有多少个slave同时对新的master进行 同步，
这个数字越小，完成failover所需的时间就越长，
但是如果这个数字越大，就意味着越 多的slave因为replication而不可用。
可以通过将这个值设为 1 来保证每次只有一个slave 处于不能处理命令请求的状态。
# sentinel parallel-syncs <master-name> <numslaves>
sentinel parallel-syncs mymaster 1



# 故障转移的超时时间 failover-timeout 可以用在以下这些方面： 
#1. 同一个sentinel对同一个master两次failover之间的间隔时间。
#2. 当一个slave从一个错误的master那里同步数据开始计算时间。直到slave被纠正为向正确的master那里同步数据时。
#3.当想要取消一个正在进行的failover所需要的时间。  
#4.当进行failover时，配置所有slaves指向新的master所需的最大时间。不过，即使过了这个超时，slaves依然会被正确配置为指向master，但是就不按parallel-syncs所配置的规则来了
# 默认三分钟
# sentinel failover-timeout <master-name> <milliseconds>
sentinel failover-timeout mymaster 180000

# SCRIPTS EXECUTION

#配置当某一事件发生时所需要执行的脚本，可以通过脚本来通知管理员，例如当系统运行不正常时发邮件通知相关人员。
#对于脚本的运行结果有以下规则：
#若脚本执行后返回1，那么该脚本稍后将会被再次执行，重复次数目前默认为10
#若脚本执行后返回2，或者比2更高的一个返回值，脚本将不会重复执行。
#如果脚本在执行过程中由于收到系统中断信号被终止了，则同返回值为1时的行为相同。
#一个脚本的最大执行时间为60s，如果超过这个时间，脚本将会被一个SIGKILL信号终止，之后重新执行。

#通知型脚本:当sentinel有任何警告级别的事件发生时（比如说redis实例的主观失效和客观失效等等），将会去调用这个脚本，
#这时这个脚本应该通过邮件，SMS等方式去通知系统管理员关于系统不正常运行的信息。调用该脚本时，将传给脚本两个参数，
#一个是事件的类型，
#一个是事件的描述。
#如果sentinel.conf配置文件中配置了这个脚本路径，那么必须保证这个脚本存在于这个路径，并且是可执行的，否则sentinel无法正常启动成功。
#通知脚本
# sentinel notification-script <master-name> <script-path>
  sentinel notification-script mymaster /var/redis/notify.sh

# 客户端重新配置主节点参数脚本
# 当一个master由于failover而发生改变时，这个脚本将会被调用，通知相关的客户端关于master地址已经发生改变的信息。
# 以下参数将会在调用脚本时传给脚本:
# <master-name> <role> <state> <from-ip> <from-port> <to-ip> <to-port>
# 目前<state>总是“failover”,
# <role>是“leader”或者“observer”中的一个。 
# 参数 from-ip, from-port, to-ip, to-port是用来和旧的master和新的master(即旧的slave)通信的
# 这个脚本应该是通用的，能被多次调用，不是针对性的。
# sentinel client-reconfig-script <master-name> <script-path>
sentinel client-reconfig-script mymaster /var/redis/reconfig.sh
```

## 缓存穿透和雪崩

### 缓存

```
public Goods searchArticleById(Long goodsId){
    Object object = redisTemplate.opsForValue().get(String.valueOf(goodsId));
    if(object != null){// 缓存查询到了结果
        return (Goods)object;
    }
    // 开始查询数据库
    Goods goods = goodsMapper.selectByPrimaryKey(goodsId);
    if(goods!=null){
        // 将结果保存到缓存中
        redisTemplate.opsForValue().set(String.valueOf(goodsId),goods,60,TimeUnit.MINUTES);;
    }
    return goods;
}
```

### 缓存雪崩

当**大量缓存数据在同一时间过期（失效）或者 Redis 故障宕机**时，如果此时有大量用户请求，都无法在Redis中处理，于是全部请求都直接访问数据库，从而导致数据库压力骤增，严重的会造成数据库宕(dang)机,从而形成一系列连锁反应，造成整个系统崩溃，这就是**缓存雪崩**

发生 **缓存雪崩** 有两个原因：

- 大量数据同时过期
- Redis故障宕机

不同的诱因，应对的策略也不同。

#### 大量数据同时过期

常见应对方法：

1. **均匀设置过期时间**
   
   避免将大量数据设置成同一个过期时间。可以在对缓存数据设置过期时间时，给这些数据的过期时间加上一个随机数，这样就保证数据不会子啊同一时间过期。

2. **互斥锁**
   
   如果发现访问的数据不在Redis里，就加个互斥锁，保证同一时间内只有一个请求来构建缓存(从数据库读取数据，再更新到Redis里)。
   
   设置互斥锁最好设置超时时间，不然会出现请求发生某种意外而一直阻塞，一直不释放锁，这时其他请求也一直拿不到锁，整个系统会出现无响应的现象。

3. **双 Key 策略**
   
   对缓存可以使用两个 Key，一个是主 Key，会设置过期时间，一个是备 Key，不会设置过期，只是 Key不一样，但是 value值是一样的，相当于给缓存数据做了个副本。
   
   当业务线程访问不到主Key的缓存数据时，就直接返回备Key的缓存数据，然后在更新缓存的时候，同时更新两个Key的数据

4. **后台更新缓存** 后台更新缓存缓存不设置有效期，让缓存”永久有效“，并将更新缓存的工作交由后台线程定时更新。
   事实上，缓存数据不设置有效期，不意味着数据一直能在内存里，因为当内存紧张时，会有些数据会被淘汰。为了解决业务线程读取缓存失败，有两种解决方法：
   
   **第一种方式**，后台线程不仅负责定时更新缓存，还负责频繁检测缓存是否有效，检测到缓存失效了，原因可能是系统紧张而被淘汰的，于是就要马上从数据库读取数据，并更新到缓存。
   这种方式的检测时间间隔不能太长，太长也导致用户获取的数据是一个空值而不是真正的数据，所以检测的间隔最好是毫秒级的，但是总归是有个间隔时间，用户体验一般。
   
   **第二种方式**，通过消息队列发送一条消息通知后台线程更新缓存。这种方式相比第一种方式缓存的更新会更及时，用户体验也比较好。
   在业务刚上线的时候，我们最好提前把数据缓起来，而不是等待用户访问才来触发缓存构建，这就是所谓的**缓存预热**，后台更新缓存的机制刚好也适合干这个事情。  

#### Redis故障宕机

常见应对方法：

1. **服务熔断或请求限流机制** 当Redis因为故障宕机而导致缓存雪崩问题时，可以启动服务熔断机制**，暂停业务应用对缓存服务的访问**，直接返回错误，不再继续访问数据库，从而降低对数据库的访问压力，保证数据库系统正常运行，然后等到Redis恢复正常后，再允许业务访问缓存服务。
   服务熔断机制虽然保护了数据库正常运行，但是暂停了业务应用访问缓存服务系统，全部业务无法正常工作。
   
   为了减少对业务的影响，可以启用**请求限流机制**，只将少部分请求发送到数据库进行处理，等到Redis恢复正常并把缓存预热完毕后，再解除请求限流的机制。

2. **构建Redis缓存高可靠集群**
   
   服务熔断或请求限流机制是缓存雪崩发生后的应对方案，我们最好通过**主从节点的方式构建 Redis 缓存高可靠集群**。
   
   如果Redis缓存的主节点故障宕机从节点可以切换成为主节点继续提供缓存服务，避免了由于 Redis 故障宕机而导致的缓存雪崩问题。

### 缓存穿透

缓存穿透指用户请求的数据在**缓存中不存在**并且在**数据库中也不存在**，导致当有大量这样的请求到来时，数据库压力骤增，这就是缓存穿透。

缓存穿透的发生一般有这两种情况：

- 业务误操作，缓存中的数据和数据库中的数据都被误删除了，所以导致缓存和数据库中都没有数据；
- 黑客恶意攻击，故意大量访问某些读取不存在数据的业务；

#### 解决方法

1. **非法请求的限制**
   
   在接口层判断请求参数是否合理，如果判断出是恶意请求就直接返回错误，避免进一步访问缓存和数据库。

2. **缓存空值或者默认值**
   
   当我们线上业务发现缓存穿透的现象时，可以针对查询的数据，在缓存中设置一个空值或者默认值，这样后续请求就可以从缓存中读取到空值或者默认值，返回给应用，而不会继续查询数据库。

### 布隆过滤器

我们可以在写入数据库数据时，使用布隆过滤器做个标记，然后在用户请求到来时，业务线程确认缓存失效后，可以通过查询布隆过滤器快速判断数据是否存在，如果不存在，就不用通过查询数据库来判断数据是否存在。

即使发生了缓存穿透，大量请求只会查询 Redis 和布隆过滤器，而不会查询数据库，保证了数据库能正常运行，Redis 自身也是支持布隆过滤器的。

> **布隆过滤器**
> 
> 布隆过滤器由「初始值都为 0 的位图数组」和「 N 个哈希函数」两部分组成。当我们在写入数据库数据时，在布隆过滤器里做个标记，这样下次查询数据是否在数据库时，只需要查询布隆过滤器，如果查询到数据没有被标记，说明不在数据库中。
> 
> 布隆过滤器会通过 3 个操作完成标记：
> 
> - 第一步，使用 N 个哈希函数分别对数据做哈希计算，得到 N 个哈希值；
> - 第二步，将第一步得到的 N 个哈希值对位图数组的长度取模，得到每个哈希值在位图数组的对应位置。
> - 第三步，将每个哈希值在位图数组的对应位置的值设置为 1；
> 
> **当应用要查询数据 x 是否数据库时，通过布隆过滤器只要查到位图数组的3个 位置的值是否全为 1，只要有一个为 0，就认为数据 x 不在数据库中**。
> 
> **因为哈希冲突的存在，查询布隆过滤器说数据存在，并不一定证明数据库中存在这个数据，但是查询到数据不存在，数据库中一定就不存在这个数据**。
