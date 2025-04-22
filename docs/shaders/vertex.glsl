// #version 300 es 不需要添加此行，因为Three.js会自动处理版本号和上下文创建
// 内置了uv, projectionMatrix, modelViewMatrix, position
precision highp float;

out vec2 vUv;

void main() {
  vUv = uv; // 直接使用Three.js提供的uv变量
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}