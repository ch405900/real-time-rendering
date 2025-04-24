---
outline: deep
---
# Shading Basics 着色基础

<script setup>
import Gooch from './components/Gooch.vue'
</script>

## Gooch 着色模型
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
<<< ./shaders/chapter5/gooch_fragment.glsl{glsl}
<<< ./shaders/chapter5/gooch_vertex.glsl{glsl}
:::

<Gooch />
