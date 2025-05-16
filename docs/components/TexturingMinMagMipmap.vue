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
import { isWebGL2Supported, loadShader } from "./utility";
import { Pane } from "tweakpane";

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
  const app = builder.orbitControls(true).transformControls(false).build();
  const geometry = new THREE.PlaneGeometry();

  const shaderSource = await import(
    "../shaders/chapter6/texture_min_mag_mipmap.glsl?raw"
  ).then((m) => m.default);
  const shader = loadShader(shaderSource);

  const loader = new THREE.TextureLoader();
  const textureLinear = loader.load("textures/chess.png", (texture) => {
    texture.minFilter = THREE.LinearFilter;
    texture.magFilter = THREE.LinearFilter;
    texture.generateMipmaps = false;
    // 同步设置 material 后再添加到场景中
  });
  const textureNearest = loader.load("textures/chess.png", (texture) => {
    texture.minFilter = THREE.NearestFilter;
    texture.magFilter = THREE.NearestFilter;
    texture.generateMipmaps = false;

    // 同步设置 material 后再添加到场景中
  });

  // textureLinear.generateMipmaps = false;
  // textureLinear.minFilter = THREE.LinearFilter;
  // textureLinear.magFilter = THREE.LinearFilter;
  textureLinear.wrapS = THREE.RepeatWrapping;
  textureLinear.wrapT = THREE.RepeatWrapping;

  // textureNearest.generateMipmaps = false;
  // textureNearest.minFilter = THREE.NearestFilter;
  // textureNearest.magFilter = THREE.NearestFilter;
  textureNearest.wrapS = THREE.RepeatWrapping;
  textureNearest.wrapT = THREE.RepeatWrapping;

  const material = new THREE.ShaderMaterial({
    glslVersion: THREE.GLSL3,
    defines: {
      USE_UV: true,
      USE_COLOR: false,
    },
    vertexShader: shader.vertexShader,
    fragmentShader: shader.fragmentShader,
    uniforms: {
      textureLinear: { value: textureLinear },
      textureNearest: { value: textureNearest },
    },
  });

  const plane = new THREE.Mesh(geometry, material);
  app.addMesh(plane);

  app.camera.position.z = 1;
  app.camera.position.y = 0;
  app.camera.position.x = 0;

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
