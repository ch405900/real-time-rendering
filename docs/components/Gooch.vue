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
  const builder = new ApplicationBuilder(container.value);
  builder.orbitControls().transformControls();
  const app = builder.build();
  const geometry = new THREE.BoxGeometry();

  const vertexShader = await import("../shaders/chapter5/gooch_vertex.glsl?raw").then(
    (m) => m.default
  );
  const fragmentShader = await import("../shaders/chapter5/gooch_fragment.glsl?raw").then(
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
      uResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) },
      lightDirection: { value: new THREE.Vector3(0.0, 0.0, 1.0) },
      coolColor: { value: new THREE.Color(0x0000ff) },
      warmColor: { value: new THREE.Color(0xff0000) },
      surfaceColor: { value: new THREE.Color(0x000000) },
    },
  });

  const PARAMS = {
    warmColor: "#ff0000",
    coolColor: "#0000ff",
    surfaceColor: "#000000",
  };

  const pane = new Pane({
    container: paneOverlay.value,
    title: "Gooch Shader Parameters",
  });

  pane.element.style.width = "300px";

  pane.addBinding(PARAMS, "warmColor");
  pane.addBinding(PARAMS, "coolColor");
  pane.addBinding(PARAMS, "surfaceColor");

  const btn = pane.addButton({
    title: "Reset",
  });

  btn.on("click", () => {
    PARAMS.warmColor = "#ff5252";
    PARAMS.coolColor = "#0000ff";
    PARAMS.surfaceColor = "#000000";
    pane.refresh();
    // reset geometry transform
    app.reset();
  });

  pane.on("change", () => {
    material.uniforms.coolColor.value.set(PARAMS.coolColor);
    material.uniforms.warmColor.value.set(PARAMS.warmColor);
    material.uniforms.surfaceColor.value.set(PARAMS.surfaceColor);
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
