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
import { bumpMap } from "three/tsl";

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
  const lightGometry = new THREE.SphereGeometry();

  const shaderSource = await import(
    "../shaders/chapter6/texture_heightmap.glsl?raw"
  ).then((m) => m.default);
  const shader = loadShader(shaderSource);

  const loader = new THREE.TextureLoader();
  const bumpMap = loader.load("textures/heightmap.png");
  bumpMap.minFilter = THREE.LinearFilter;
  bumpMap.magFilter = THREE.LinearFilter;

  // 边界处理方式（决定纹理采样超出 [0,1] 时的行为）
  bumpMap.wrapS = THREE.RepeatWrapping;
  bumpMap.wrapT = THREE.RepeatWrapping;
  bumpMap.needsUpdate = true;

  const material = new THREE.ShaderMaterial({
    glslVersion: THREE.GLSL3,
    defines: {
      USE_UV: true,
      USE_COLOR: false,
    },
    side: THREE.DoubleSide,
    vertexShader: shader.vertexShader,
    fragmentShader: shader.fragmentShader,
    uniforms: {
      bumpMap: { value: bumpMap },
      useBorder: { value: false },
      lightPos: { value: new THREE.Vector3(1, 1, 1) },
      lightColor: { value: new THREE.Color(0xffffff) },
      ambientColor: { value: new THREE.Color(0x666666) },
      shininess: { value: 32 },
      bumpScale: { value: 64 },
    },
  });

  const plane = new THREE.Mesh(geometry, material);
  app.addMesh(plane);
  plane.rotation.x = -Math.PI / 2;
  app.camera.position.z = 0;
  app.camera.position.y = 1;
  app.camera.position.x = 0;

  app.run(() => {
    // plane.rotation.y += 0.01;
    console.log(`lightPos: ${lightGometry.position}`);

    material.uniforms.lightPos.value.set(
      5 * Math.sin(Date.now() * 0.001),
      5 * Math.sin(Date.now() * 0.001),
      5
    );
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
