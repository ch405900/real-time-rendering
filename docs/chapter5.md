---
outline: deep
head:
  - - link
    - rel: stylesheet
      href: https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/katex.min.css
---
# Shading Basics 着色基础

<script setup>
import Gooch from './components/Gooch.vue'
</script>

## Gooch 着色模型

$
\mathbf{c}_{\text {shaded }}=s \mathbf{c}_{\text {highlight }}+(1-s)\left(t \mathbf{c}_{\text {warm }}+(1-t) \mathbf{c}_{\text {cool }}\right).
\tag{5.1} 
$

::: code-group
<!-- 文件名默认用作标题 -->
<<< ./shaders/chapter5/gooch_vertex.glsl{glsl}
<!-- 也可以提供定制的代码组 -->
<<< ./shaders/chapter5/gooch_fragment.glsl{glsl}
:::

<Gooch />
