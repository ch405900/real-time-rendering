// #version 300 es 不需要添加此行，因为Three.js会自动处理版本号和上下文创建
precision highp float;

in vec2 vUv;
out vec4 fragColor;

void main() {
  fragColor = vec4(vUv, 0.0, 0.5);
}