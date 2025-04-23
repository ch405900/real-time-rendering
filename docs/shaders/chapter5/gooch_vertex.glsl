// #version 300 es 不需要添加此行，因为Three.js会自动处理版本号和上下文创建
// 内置了uv(纹理坐标)和normal(法线)变量
// projectionMatrix(相机到裁剪空间)
// modelViewMatrix(模型到相机空间)
// position(顶点坐标)
// normalMatrix(仅旋转+缩放部分的逆转置)
precision highp float;

out vec2 vUv; // 纹理坐标
out vec3 vNormal; // 法线
out vec3 vViewPosition; // 视图空间中的位置

void main() {
  vUv = uv;
  vNormal = normalize(normalMatrix * normal);
  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
  vViewPosition = -mvPosition.xyz;
  gl_Position = projectionMatrix * mvPosition;
}