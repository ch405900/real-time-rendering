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

in vec2 vUv; // 纹理坐标
in vec3 vNormal; // 法线
in vec3 vViewPosition; // 视图空间中的位置

uniform vec3 lightDirection;
uniform vec3 coolColor;
uniform vec3 warmColor;
uniform vec3 surfaceColor;

out vec4 fragColor;

void main() {
  vec3 N = normalize(vNormal);
  vec3 L = normalize(lightDirection);

  float NL = max(dot(N, L), 0.0);
  // Gooch shading
  vec3 cCool = coolColor + surfaceColor * 0.25;
  vec3 cWarm = warmColor + surfaceColor * 0.25;
  vec3 highlight = vec3(1.0,1.0,1.0);
  float t = (NL + 1.0)/2.0;
  vec3 r = 2.0 * NL * N - L;
  float s = max(dot(r, vViewPosition), 0.0);
  vec3 gooch = clamp(s * highlight + (1.0 - s) * (t*cWarm + (1.0-t)*cCool),0.0,1.0);
  fragColor = vec4(gooch, 1.0);
}