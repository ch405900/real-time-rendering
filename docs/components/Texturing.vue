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
import { EXRLoader } from "three/examples/jsm/loaders/EXRLoader.js";

const mainContainer = ref(null);
const container = ref(null);
const paneOverlay = ref(null);
const supportedWebGL2 = ref(false);

onMounted(async () => {
  supportedWebGL2.value = isWebGL2Supported();
  if (supportedWebGL2 == false) {
    return;
  }
  const builder = new ApplicationBuilder(container.value);
  const app = builder.orbitControls(true).transformControls(true).build();
  const geometry = new THREE.BoxGeometry();

  const shaderSource = await import("../shaders/chapter6/texture.glsl?raw").then(
    (m) => m.default
  );
  const shader = loadShader(shaderSource);

  const exrLoader = new EXRLoader();
  const loader = new THREE.TextureLoader();
  const diffuseMap = loader.load("textures/medieval_red_brick_diff_1k.jpg");
  diffuseMap.minFilter = THREE.LinearFilter;
  diffuseMap.magFilter = THREE.LinearFilter;

  // 或者更锐利的视觉：
  diffuseMap.minFilter = THREE.NearestFilter;
  diffuseMap.magFilter = THREE.NearestFilter;

  // 边界处理方式（决定纹理采样超出 [0,1] 时的行为）
  diffuseMap.wrapS = THREE.RepeatWrapping;
  diffuseMap.wrapT = THREE.RepeatWrapping;
  diffuseMap.needsUpdate = true;

  const heightMap = loader.load("textures/medieval_red_brick_disp_1k.png");
  heightMap.minFilter = THREE.LinearFilter;
  heightMap.magFilter = THREE.LinearFilter;

  // 或者更锐利的视觉：
  heightMap.minFilter = THREE.NearestFilter;
  heightMap.magFilter = THREE.NearestFilter;

  // 边界处理方式（决定纹理采样超出 [0,1] 时的行为）
  heightMap.wrapS = THREE.RepeatWrapping;
  heightMap.wrapT = THREE.RepeatWrapping;
  heightMap.needsUpdate = true;

  const normapMap = await exrLoader.loadAsync(
    "textures/medieval_red_brick_nor_gl_1k.exr?raw"
  );
  const material = new THREE.ShaderMaterial({
    glslVersion: THREE.GLSL3,
    defines: {
      USE_UV: true,
      USE_COLOR: false,
    },
    vertexShader: shader.vertexShader,
    fragmentShader: shader.fragmentShader,
    uniforms: {
      diffuseMap: { value: diffuseMap },
      normalMap: { value: normapMap },
      heightMap: { value: heightMap },
      heightScale: { value: 0.1 },
    },
  });

  const PARAMS = {
    useheightMap: false,
    heightScale: 0.1,
  };

  const pane = new Pane({
    container: paneOverlay.value,
    title: "Texturing Shader Parameters",
  });

  pane.element.style.width = "300px";

  pane.addBinding(PARAMS, "useheightMap");
  pane.addBinding(PARAMS, "heightScale");

  const btn = pane.addButton({
    title: "Reset",
  });

  btn.on("click", () => {
    PARAMS.useheightMap = false;
    PARAMS.heightScale = 0.1;

    pane.refresh();
    // reset geometry transform
    app.reset();
  });

  pane.on("change", () => {
    material.uniforms.heightScale.value = PARAMS.heightScale;
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
