<template>
  <div ref="mainContainer" class="main-container">
    <!-- 你的 three.js 内容或 canvas 保持不变 -->
    <div ref="container" class="three-container"></div>

    <!-- 新增的浮动层 -->
    <div ref="paneOverlay" class="tweakpane-overlay"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import * as THREE from "three";
import { ApplicationBuilder } from "./application";
import { Pane } from "tweakpane";

const mainContainer = ref(null);
const container = ref(null);
const paneOverlay = ref(null);

onMounted(async () => {
  const PARAMS = {
    factor: 123,
    title: "hello",
    color: "#ff0055",
  };

  const pane = new Pane({
    container: paneOverlay.value,
    title: "Shader Parameters",
  });
  pane.element.style.width = "300px";

  pane.addBinding(PARAMS, "factor");
  pane.addBinding(PARAMS, "title");
  pane.addBinding(PARAMS, "color");

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

  app.run();

  onUnmounted(() => {
    app.dispose();
  });
});
</script>

<style scoped>
.main-container {
  width: 100%;
  height: 400px;
  position: relative;
}

.three-container {
  width: 100%;
  height: 400px;
  border: 1px solid #eee;
  margin: 1rem 0;
}

.tweakpane-overlay {
  /* position: fixed; */
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 100;
  pointer-events: auto;
}
</style>
