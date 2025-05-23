---
outline: deep
---

<script setup>
import Texturing from './components/Texturing.vue'
import TexturingUVTest from './components/TexturingUVTest.vue'
import TexturingCorresponder from './components/TexturingCorresponder.vue'
import TexturingMinMagMipmap from './components/TexturingMinMagMipmap.vue'
import TexturingUVAnimation from './components/TexturingUVAnimation.vue'
import TexturingAlphaBlend from './components/TexturingAlphaBlend.vue'
import TextureBlinn from './components/TextureBlinn.vue'
import { ref } from 'vue'
const showCode = ref(false)
</script>

# Texturing 纹理


## UV
使用Three.js内置的多个模型分别显示测试UV图片效果.

`测试图片来自[oxpal](https://www.oxpal.com/uv-checker-texture.html)`

<TexturingUVTest />

::: code-group
<<< ./shaders/chapter6/texture_uv_test.glsl{glsl}
:::


## 转换函数
转换函数处理纹理坐标超出[0,1]之外的行为.
常见的转换函数有
名称 | 特点
-|-
wrap,repeat,tile | 整数部分被丢弃, 整体不断重复
mirror | 图像在表面上不断重复，但是每重复一次就会被镜像（翻转）一次
clamp,clamp to edge | 位于[0,1]范围外的纹理坐标会被限制在这个范围内
border,clamp to border  | 位于[0,1]范围外的纹理坐标所采样到的值，会被设定为同一个颜色，它被称为边框颜色

> [!IMPORTANT] three.js中没有border模式, 下面的border效果实为模拟效果
 
<TexturingCorresponder/>

::: code-group
<<< ./shaders/chapter6/texture_uv_corresponder_func.glsl{glsl}
:::

## 放大和缩小

左半部分使用Nearest, 右半部分使用Linear
<TexturingMinMagMipmap/>


## 程序化纹理



## 纹理动画

在UV一节中的基础上, 让纹理随着时间进行偏移.

<TexturingUVAnimation />


## 材质映射

## Alpha映射

![tree](./public/textures/tree-with-white-background.png)


<TexturingAlphaBlend/>


## 凹凸映射
### Blinn方法
Blinn于1978年提出使用凹凸贴图在不增加顶点的情况下,增加凹凸变化.凹凸贴图的内容通常是高度图.
![heightmap](./public/textures/heightmap.png)
<TextureBlinn />

### 法线贴图
