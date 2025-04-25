// -- vertex
precision highp float;

out vec2 vUv;
out vec3 vWorldPosition;
out vec3 vWorldNormal;

void main() {
    vUv = uv;

    // 变换法线到世界空间
    vWorldNormal = normalize(mat3(modelMatrix) * normal);

    // 顶点坐标 → 世界空间
    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vWorldPosition = worldPos.xyz;

    gl_Position = projectionMatrix * viewMatrix * worldPos;
}

// -- fragment
precision highp float;

#define MAXLIGHTS 3

in vec2 vUv; // 纹理坐标
in vec3 vWorldPosition;
in vec3 vWorldNormal;

uniform vec3 uEyePosition; // 摄像机在世界坐标中的位置

uniform vec3 warmColor;
uniform vec3 uFUnlit;

struct Light {
    vec4 position;
    vec4 color;
};
uniform Light uLights[MAXLIGHTS];
uniform uint uLightCount;

out vec4 fragColor;

vec3 lit(vec3 l, vec3 n, vec3 v) {
    vec3 r_l = reflect(-l, n);
    float s = clamp(100.0 * dot(r_l, v) - 97.0, 0.0, 1.0);
    vec3 highlightColor = vec3(1, 1, 1);
    return mix(warmColor, highlightColor, s);
}

void main() {
    vec3 n = normalize(vWorldNormal);
    vec3 v = normalize(uEyePosition - vWorldPosition); // 从点指向摄像机

    fragColor = vec4(uFUnlit, 1.0);

    for(uint i = 0u; i < uLightCount; i++) {
        vec3 l = normalize(uLights[i].position.xyz - vWorldPosition);
        float NdL = max(dot(n, l), 0.0);
        fragColor.xzy += NdL * uLights[i].color.rgb * lit(l, n, v);
    }

}