// #version 300 es 不需要添加此行，因为Three.js会自动处理版本号和上下文创建
precision highp float;

in vec3 vNormal; // 法线

uniform vec3 lightDirection;
uniform vec3 lightColor;
uniform vec3 surfaceColor;

out vec4 fragColor;

void main() {
  vec3 N = normalize(vNormal);
  vec3 L = normalize(lightDirection);

  float NL = max(dot(N, L), 0.0);
  if (NL <= 0.0) discard; // 背面不显示
  // Lambertian shading
  vec3 lambert = NL * lightColor * surfaceColor;
  fragColor = vec4(lambert, 1.0);
}