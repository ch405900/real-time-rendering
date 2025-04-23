// #version 300 es 不需要添加此行，因为Three.js会自动处理版本号和上下文创建
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
  vec3 kCool = coolColor + surfaceColor * 0.25;
  vec3 kWarm = warmColor + surfaceColor * 0.25;
  vec3 highlight = vec3(1.0,1.0,1.0);
  float t = (NL + 1.0)/2.0;
  vec3 r = 2.0 * NL * N - L;
  float s = max(dot(r, vViewPosition), 0.0);
  vec3 gooch = s * highlight + (1.0 - s) * (t*kWarm + (1.0-t)*kCool);
  fragColor = vec4(gooch, 1.0);
}