<template>
  <div ref="mainContainer" class="main-container">
    <div ref="container" class="three-container"></div>
    <div ref="paneOverlay" class="tweakpane-overlay"></div>
    <div v-if="!supportedWebGL2" class="overlay-mask">
      <div class="mask-message">抱歉，您的浏览器不支持 WebGL2。</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import * as THREE from "three";
import { ApplicationBuilder } from "./application";
import { Pane } from "tweakpane";
import { isWebGL2Supported, loadShader } from "./utility";

const mainContainer = ref(null);
const container = ref(null);
const paneOverlay = ref(null);
const supportedWebGL2 = ref(false);

const defaultLightColor = new THREE.Color(0xffffff);
const defaultSurfaceColor = new THREE.Color(0xd7d7d7);

onMounted(async () => {
  supportedWebGL2.value = isWebGL2Supported();
  if (supportedWebGL2 == false) {
    return;
  }
  const builder = new ApplicationBuilder(container.value);
  const app = builder.orbitControls(true).transformControls(true).build();
  const geometry = new THREE.BoxGeometry();

  const shaderSource = await import("../shaders/chapter5/lambertian.glsl?raw").then(
    (m) => m.default
  );
  const shader = loadShader(shaderSource);
  const material = new THREE.ShaderMaterial({
    glslVersion: THREE.GLSL3,
    defines: {
      USE_UV: false,
      USE_COLOR: false,
    },
    vertexShader: shader.vertexShader,
    fragmentShader: shader.fragmentShader,
    uniforms: {
      uResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) },
      lightDirection: { value: new THREE.Vector3(1.0, 1.0, 1.0) },
      lightColor: { value: new THREE.Color(defaultLightColor) },
      surfaceColor: { value: new THREE.Color(defaultSurfaceColor) },
    },
  });

  const PARAMS = {
    lightColor: "#" + defaultLightColor.getHexString(),
    surfaceColor: "#" + defaultSurfaceColor.getHexString(),
    speed: 0.001,
  };

  const pane = new Pane({
    container: paneOverlay.value,
    title: "Lambertian Shader Parameters",
  });

  pane.element.style.width = "300px";

  pane.addBinding(PARAMS, "lightColor");
  pane.addBinding(PARAMS, "surfaceColor");
  pane.addBinding(PARAMS, "speed");

  const btn = pane.addButton({
    title: "Reset",
  });

  btn.on("click", () => {
    PARAMS.lightColor = "#" + defaultLightColor.getHexString();
    PARAMS.surfaceColor = "#" + defaultSurfaceColor.getHexString();
    PARAMS.speed = 0.001;
    pane.refresh();
    // reset geometry transform
    app.reset();
    lightCube.position.set(2, 2, 2);
  });

  pane.on("change", () => {
    material.uniforms.lightColor.value.set(PARAMS.lightColor);
    material.uniforms.surfaceColor.value.set(PARAMS.surfaceColor);
  });

  const cube = new THREE.Mesh(geometry, material);

  const lightGeometry = new THREE.BoxGeometry();

  const lightCube = new THREE.Mesh(lightGeometry);
  lightCube.position.set(2, 2, 2);
  app.addMesh(lightCube);
  app.addMesh(cube);

  let theta = 0.0;
  const r = 2;
  app.run(() => {
    theta += PARAMS.speed;
    let x = Math.cos(theta) * r;
    let y = Math.sin(theta) * r;
    lightCube.position.set(x, r, y);
    material.uniforms.lightDirection.value.copy(lightCube.position);
  });

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

.overlay-mask {
  position: absolute;
  inset: 0;
  background-color: rgba(0, 0, 0, 0.75);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  font-size: 1.2em;
}

.mask-message {
  padding: 1em 2em;
  background: rgba(0, 0, 0, 0.85);
  border-radius: 8px;
  border: 1px solid #fff;
}
</style>
