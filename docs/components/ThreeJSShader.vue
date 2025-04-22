<template>
  <div ref="container" class="three-container"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import * as THREE from "three";
import "./application";
import Application from "./application";

const container = ref(null);

onMounted(async () => {
  const app = new Application();

  const geometry = new THREE.BoxGeometry();

  const vertexShader = await import("../shaders/vertex.glsl?raw").then((m) => m.default);
  const fragmentShader = await import("../shaders/fragment.glsl?raw").then(
    (m) => m.default
  );

  const material = new THREE.ShaderMaterial({
    glslVersion: THREE.GLSL3,
    vertexShader,
    fragmentShader,
  });
  const cube = new THREE.Mesh(geometry, material);
  app.attachTo(container.value);
  app.addMesh(cube);
  app.orbitControls();

  function animate() {
    requestAnimationFrame(animate);
    app.update();
  }
  animate();

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
