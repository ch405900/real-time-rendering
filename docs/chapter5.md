---
outline: deep
---
# Shading Basics 着色基础

<script setup>
import Gooch from './components/Gooch.vue'
import Lambertian from './components/Lambertian.vue'
</script>

## 5.1着色模型
Gooch 着色模型被设计用于增加技术插图（工程制图）中细节的易读性。

$$
\mathbf{c}_{\text {shaded }}=s \mathbf{c}_{\text {highlight }}+(1-s)\left(t \mathbf{c}_{\text {warm }}+(1-t) \mathbf{c}_{\text {cool }}\right).
$$
- $\mathbf{c}_{\text{shaded}}$ 是最终着色颜色。
- $\mathbf{c}_{\text{highlight}}$ 是高光颜色。
- $\mathbf{c}_{\text{warm}}$ 是暖色调值。
- $\mathbf{c}_{\text{cool}}$ 是冷色调值。

$$
\begin{aligned} \mathbf{c}_{\mathrm{cool}} &=(0,0,0.55)+0.25 \mathbf{c}_{\mathrm{surface}}, \\ \mathbf{c}_{\mathrm{warm}} &=(0.3,0.3,0)+0.25 \mathbf{c}_{\mathrm{surface}}, \\ \mathbf{c}_{\mathrm{highlight}} &=(1,1,1), \\ t &=\frac{(\mathbf{n} \cdot \mathbf{l})+1}{2}, \\ \mathbf{r} &=2(\mathbf{n} \cdot \mathbf{l}) \mathbf{n}-\mathbf{l}, \\ s &=(100(\mathbf{r} \cdot \mathbf{v})-97)^{\mp} . \end{aligned}
$$

::: code-group
<!-- 文件名默认用作标题 -->
<<< ./shaders/chapter5/gooch.glsl{glsl}
:::

<Gooch />

## 5.2 光照

Lambertian模型可以用于对理想漫反射表面的着色，例如完美的哑光表面等

$$
\mathbf{c}_{\text {shaded }}=f_{\text {unlit }}(\mathbf{n}, \mathbf{v})+\sum_{i=1}^{n}\left(\mathbf{l}_{i} \cdot \mathbf{n}\right)^{+} \mathbf{c}_{\text {light }_{i}} \mathbf{c}_{\text {surface }}
$$

::: code-group
<!-- 文件名默认用作标题 -->
<<< ./shaders/chapter5/lambertian_fragment.glsl{glsl}
<<< ./shaders/chapter5/lambertian_vertex.glsl{glsl}
:::

<Lambertian />


## 5.3 实现着色模型
