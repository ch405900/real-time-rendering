<template>
  <div ref="container" class="three-container"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import * as THREE from "three";
import { ApplicationBuilder } from "./application";

const container = ref(null);

onMounted(async () => {
  const builder = new ApplicationBuilder(container.value);
  builder.orbitControls().transformControls();
  const app = builder.build();
  const geometry = new THREE.BoxGeometry();

  const vertexShader = await import("../shaders/vertex.glsl?raw").then((m) => m.default);
  const fragmentShader = await import("../shaders/fragment.glsl?raw").then(
    (m) => m.default
  );

  const material = new THREE.ShaderMaterial({
    glslVersion: app.isWebGL2() ? THREE.GLSL3 : THREE.GLSL1,
    defines: {
      USE_UV: false,
      USE_COLOR: false,
    },
    vertexShader,
    fragmentShader,
    uniforms: {
      lightDir: { value: [0.0, 0.0, 0.0] },
      uResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) },
    },
  });

  const cube = new THREE.Mesh(geometry, material);
  app.addMesh(cube);

  function animate() {
    requestAnimationFrame(() => animate());
    app.update();
  }

  animate(app);

  onUnmounted(() => {
    app.dispose();
  });
});
</script>

<style scoped>
.three-container {
  width: 100%;
  height: 400px;
  border: 1px solid #eee;
  margin: 1rem 0;
}
</style>
