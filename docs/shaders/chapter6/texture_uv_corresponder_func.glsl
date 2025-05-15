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
uniform float useBorder;
uniform float borderWidth;
uniform vec4 borderColor;

void main() {
  // 中心区域坐标范围
  vec2 uvMin = vec2(0.25);
  vec2 uvMax = vec2(0.75);

  // 判断是否在中心区域内
  bool inCenter = all(greaterThanEqual(vUv, uvMin)) && all(lessThanEqual(vUv, uvMax));

  // inCenter将vUv限制在[0.25,0.75]
  vec2 scaledUv = (vUv - uvMin) * 2.0;
    // 此时的scaledUv则是[0,1]
  float borderReplace = (1.0 - float(inCenter)) * useBorder;
  fragColor = mix(texture2D(diffuseMap, scaledUv), borderColor, borderReplace);
}