// -- vertex
precision highp float;

out vec2 vUv; // 纹理坐标
out vec3 vNormal; // 法线
out vec3 vViewPosition; // 视图空间中的位置
out vec3 vWorldPosition;
void main() {
  vUv = uv;
  vNormal = normalize(normalMatrix * normal);
  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
  vViewPosition = -mvPosition.xyz;
  gl_Position = projectionMatrix * mvPosition;
  vWorldPosition = (modelMatrix * vec4(position, 1.0)).xyz;
}

// -- fragment
precision highp float;

in vec2 vUv;
in vec3 vNormal;
in vec3 vViewPosition;
in vec3 vWorldPosition;
out vec4 fragColor;
uniform vec3 lightPos;
uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform float shininess;
uniform float bumpScale;
uniform sampler2D bumpMap;

void main() {
  // 高度图采样
  float h = texture(bumpMap, vUv).r;
  // 计算纹理坐标的偏移,获取梯度
  vec2 texelSize = 1.0 / vec2(textureSize(bumpMap, 0));
  float hRight = texture(bumpMap, vUv + vec2(texelSize.x, 0.0)).r;
  float hUp = texture(bumpMap, vUv + vec2(0.0, texelSize.y)).r;

  // 计算法线扰动
  vec3 bumpNormal = normalize(vNormal);
  bumpNormal.xy += bumpScale * vec2(hRight - h, hUp - h);
  bumpNormal = normalize(bumpNormal);

  // 计算光照
  vec3 lightDir = normalize(lightPos - vWorldPosition);
  vec3 viewDir = normalize(-vWorldPosition);

  // Blinn-Phong光照模型
  // 漫反射
  vec3 diffuseColor = vec3(0.15, 0.6, 0.49);
  float diff = max(dot(bumpNormal, lightDir), 0.0);
  vec3 diffuse = diffuseColor * diff * lightColor;
  // 镜面反射
  vec3 halfDir = normalize(lightDir + viewDir);
  float spec = pow(max(dot(bumpNormal, halfDir), 0.0), shininess);
  vec3 specularColor = vec3(1.0, 1.0, 1.0);
  vec3 specular = specularColor * spec * lightColor;
  // 环境光
  vec3 ambient = ambientColor * diffuseColor;
  // 计算最终颜色
  vec3 color = ambient + diffuse + specular;

  fragColor = vec4(color, 1.0);
  // fragColor = texture(bumpMap, vUv);
}