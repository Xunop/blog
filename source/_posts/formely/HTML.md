---
description: --- ---
title: HTML（不建议观看）
date: 2022/3/20 22:27
categories:
- [旧时期产物]
tags:
- 前端
---
# 这是我之前博客写的，第一次写，写得很烂。
# HTML标签上

[1. 标题标签](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#1)  
[2. 段落和换行标签](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#2)  
[3. 标题标签](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#3)  
[4.`<div>`和`<span>`标签](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#4)  
[5. 图像标签](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#5)  
[6. 超链接标签](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#6)

# HTML标签下

## 表格

[7. 表格的基本用法](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#7)  
[8. 表头单元格标签](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#8)  
[9. 表格属性](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#9)  
[10. 表头结构标签](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#10)  
[11. 合并单元格](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#11)

---

---

### 标题标签

# 一级标题

## 二级标题

### 三级标题

#### 四级标题

##### 五级标题

###### 六级标题

` **标签语义**:作为标题使用，并且根据重要性递减。 **特点**: 1. 加了标题的文字会变粗，自豪会变大。 2. 一个标题独占一行。 3. 随着标题的级数降低字号也在降低。

---

### 段落和换行标签

#### 段落标签

```html
<p></p>
```

一个段落标签  
**标签语义**：可以将HTML文档分成好几个段落。  
**特点**：

1. 文本在一个段落中会根据浏览器窗口的大小自动换行。

2. 段落和段落之间保有空隙。
   
   #### 换行标签

```html
<br />
```

**标签语义**：将某段文本强制换行。

---

### 文本格式化标签

| 语义  | 标签                             | 说明              |
| --- | ------------------------------ | --------------- |
| 加粗  | `<strong></strong>`或者`<b></b>` | 建议使用strong语义更强烈 |
| 斜体  | `<em></em>` 或者 `<i></i>`       | 建议使用前者，理由同上     |
| 删除线 | `<del></del>`或者`<s></s>`       | 建议如上            |
| 下划线 | `<ins></ins>`或者`<u><.u>`       | 同上              |

---

### div和span标签

`<div>头部</div>`  
`<span>小盒子<span>`

**这两个标签是没有语义的，它们是一个盒子，用来装内容，div标签是大盒子，span标签是小盒子**  
**特点**:

```html
<div></div>
```

用来布局，但是一行只能放一个,相当于一个大盒子。

```html
<span></span>
```

用来布局，一行可以放多个，相当于一个小盒子。

---

### 图像标签和路径

**图像标签**

| 属性     | 属性值  | 说明                 |
| ------ | ---- | ------------------ |
| src    | 图片路径 | 必须具备的属性            |
| alt    | 文本   | 替换文本。图像不能显示的文字     |
| title  | 文本   | 提示文本。鼠标放在图像上，显示的文字 |
| width  | 像素   | 设置图像的宽度            |
| height | 像素   | 设置图像的高度            |
| border | 像素   | 设置图像的边框粗细          |

*注意点：*  
①图像标签可以拥有多个属性，必须写在标签名的后面。  
②属性之间不分先后顺序，标签名与属性、属性与属性之间均以空格分开。  
③属性采取键值对的格式，即key = “value”的格式，属性= “属性值”。  
举个🌰：  
[![](http://47.97.252.72/wordpress/wp-content/uploads/2022/03/wp_editor_md_269e29c501be08838d142f15969f6a92.jpg)](http://47.97.252.72/wordpress/wp-content/uploads/2022/03/wp_editor_md_269e29c501be08838d142f15969f6a92.jpg)  
这是效果[![](http://47.97.252.72/wordpress/wp-content/uploads/2022/03/wp_editor_md_e67ee4707c0d22e3676da5698165a7fe.jpg)](http://47.97.252.72/wordpress/wp-content/uploads/2022/03/wp_editor_md_e67ee4707c0d22e3676da5698165a7fe.jpg)  
在鼠标放到图片上时会出现”萌王”两个字就是title的效果。  
**路径**  
相对路径：以引用文件所在位置为参考基础，而建立出的目录路径。在这里就是说，图片相对于HTML页面的位置。

| 相对路径分类 | 符号  | 说明                            |
| ------ | --- | ----------------------------- |
| 同一级路径  |     | 图片文件位于HTML文件同一级，可直接引用。        |
| 下一级路径  | /   | 图片位于HTML文件的下一级                |
| 上一级路径  | ../ | 图像文件位于HTML文件上一级，引用的时候要先回到上一级。 |

---

### 超链接标签

1. 语法格式
   
   ```html
   <a href="跳转目标" target="目标窗口的弹出方式" rel="noopener">文本或图像</a>
   ```

| 属性     | 作用                                                |
| ------ | ------------------------------------------------- |
| href   | 用于指定链接目标的url地址，这个是必须要的属性，当标签应用href属性时，它就具有了超链接的功能 |
| target | 用于指定链接页面的打开方式，其中_self为默认值，在本窗口打开，_blank为在新窗口打开    |

举个🌰：  
代码：

```html
<a href="http:///www.baidu.com" target="_blank" rel="noopener"> 百度</a>
```

这是效果：  
[百度](http://www.baidu.com/)

2. 链接分类：  
   ①外部链接：例如上面那个🌰。  
   ②内部链接：网站内部页面之间的相互链接，直接链接内部页面名称即可。就是同一个文件里面的html文件，你直接把链接换成html文件的名字就好了。  
   ③空链接：如果当时没有确定链接目标时，可以这样写：
   
   ```html
   <a href="#"> 文本或图像</a>
   ```
   
   🌰效果： [这是空的链接](http://xjmdbd.xyz/wp-admin/post.php?post=42&action=edit#)  
   ④下载链接：如果href里面地址是一个文件或者压缩包，会下载这个文件。
   
   ```html
   <a href="xxx.zip"> 文本或图像</a>
   ```
   
   🌰效果：[下载](http://xjmdbd.xyz/wp-admin/img.zip)(这里面的压缩文件我瞎打的，点不开的)  
   ⑤网页元素链接：在网页中的各种网页元素，如文本、图像、表格、音频、视频等都可以添加超链接。
   
   ```html
   <a href="一个链接"> 文本图像表格等</a>
   ```
   
   🌰效果：不太好做，自己测试。  
   ⑥锚点链接：当我们点击时，可以快速定位到页面中的某个位置。  
   i.在链接文本的href属性中，设置属性值为#名字的形式，如

```html
<a href= "#1">第一个</a>
```

ii.这时在目标位置的标签应该为

```html
<h3 id="1">第一个的位置</h3>
```

这里不一定要用标题标签。  
我前面的目录就用了锚点链接，点击的话就能到达目标位置。

### 表格的基本用法

效果：

| 姓名  | 性别  | 年龄  |
| --- | --- | --- |
| xxx | 男   | 100 |

代码：

```html
<table>
        <tr>
            <th>姓名</th>
            <th>性别</th>
            <th>年龄</th>
        </tr>
        <tr>
            <td>xxx</td>
            <td>男</td>
            <td>100</td>
        </tr>
</table>
```

th和td的区别：th标签代表HTML表格的表头部分，th一般用于第一列，能加粗跟居中。  
如果把上面的th改成td的话就成这样：

| 姓名  | 性别  | 年龄  |
| --- | --- | --- |
| xxx | 男   | 100 |

---

### 表格属性

| 属性名         | 属性值               | 描述                         |
| ----------- | ----------------- | -------------------------- |
| align       | left、center、right | 规定表格相对周围元素的对齐方式            |
| border      | 1 或 “”            | 规定表格单元是否拥有边框，默认为””,表示没有边框. |
| cellpadding | 像素值               | 规定单元边沿与其内容之间的空白，默认为1像素。    |
| cellspacing | 像素值               | 规定单元格之间的空白，默认为2像素          |
| width       | 像素值或百分比           | 规定表格的宽度                    |

---

### 表格结构标签

定义表格的头部:

```html
<thead></thead>
```

内部必须拥有下面这个标签，一般位于第一行。

```html
<tr></tr>
```

用于定义表格的主体，主要用于放数据本体：

```html
<tbody></tbody>
```

以上标签都是下面这个标签里

```html
<table></table>
```

---

### 合并单元格

跨行合并:rowspan="合并单元格的个数"。 在最上侧单元格的地方写这个这个代码。如：

```html
<td rowspan="2"></td>
```

合并完记得删除多余的单元格。

跨列合并:colspan=”合并的单元个数”，与跨行合并差不多，只不过是以最左侧单元格为目标单元格。
