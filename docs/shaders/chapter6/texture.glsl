// -- vertex
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

// -- fragment
precision highp float;

in vec2 vUv;
in vec3 vViewPosition;
uniform sampler2D diffuseMap;
uniform sampler2D normalMap;
uniform sampler2D heightMap;
uniform float heightScale;

out vec4 fragColor;

void main() {
// 获取当前高度值
  float height = texture(heightMap, vUv.yx).r;

  // 从 vViewPosition 估算观察方向（片元 → 摄像机方向）
  vec3 viewDir = normalize(vViewPosition);

  // 使用 viewDir 的 xy 分量（这是个近似）
  vec2 offset = viewDir.xy * (height * heightScale);

  // 对 UV 进行偏移
  vec2 displacedUv = vUv - offset.xy;

  // 采样颜色贴图
  vec4 color;
   if(vUv.x > 0.5) color = texture(diffuseMap, displacedUv); else color = texture(heightMap, vUv);
color = texture(diffuseMap, displacedUv);
  fragColor = vec4(color.rgb, 1.0);
}