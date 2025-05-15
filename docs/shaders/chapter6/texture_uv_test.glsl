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

uniform sampler2D diffuseMap;

in vec2 vUv;
out vec4 fragColor;

void main() {
  vec4 color;
  color = texture(diffuseMap, vUv);
  fragColor = vec4(color.rgb, 1.0);
}