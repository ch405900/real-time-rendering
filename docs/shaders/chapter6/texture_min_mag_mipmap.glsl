// -- vertex
precision highp float;

out vec2 vUv; // 纹理坐标
out vec3 vNormal; // 法线
out vec3 vViewPosition; // 视图空间中的位置

void main() {
  vUv = uv * 2.0;
  vNormal = normalize(normalMatrix * normal);
  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
  vViewPosition = -mvPosition.xyz;
  gl_Position = projectionMatrix * mvPosition;
}

// -- fragment
precision highp float;

uniform sampler2D textureLinear;
uniform sampler2D textureNearest;

in vec2 vUv;
out vec4 fragColor;

void main() {
  vec4 colorLinear = texture2D(textureLinear, vUv);
  vec4 colorNearest = texture2D(textureNearest, vUv);
  // colorNearest = vec4(1.0,0.0,0.0,1.0);
  float t = step(1.0, vUv.x);

  fragColor = mix(colorNearest,colorLinear, t);
}