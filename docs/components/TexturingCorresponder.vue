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
    "../shaders/chapter6/texture_uv_corresponder_func.glsl?raw"
  ).then((m) => m.default);
  const shader = loadShader(shaderSource);

  const loader = new THREE.TextureLoader();
  const diffuseMap = loader.load("textures/checker-map_tho.png");
  diffuseMap.minFilter = THREE.LinearFilter;
  diffuseMap.magFilter = THREE.LinearFilter;

  // 或者更锐利的视觉：
  diffuseMap.minFilter = THREE.NearestFilter;
  diffuseMap.magFilter = THREE.NearestFilter;

  // 边界处理方式（决定纹理采样超出 [0,1] 时的行为）
  diffuseMap.wrapS = THREE.RepeatWrapping;
  diffuseMap.wrapT = THREE.RepeatWrapping;
  diffuseMap.needsUpdate = true;

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
      useBorder: { value: false },
    },
  });

  const pane = new Pane({
    container: paneOverlay.value,
    title: "Texturing Wrapping Mode",
  });

  pane.element.style.width = "300px";

  pane
    .addBlade({
      view: "list",
      label: "Mode",
      options: [
        { text: "wrap,repeat,tile", value: 0 },
        { text: "mirror", value: 1 },
        { text: "clamp", value: 2 },
        { text: "border", value: 3 },
      ],
      value: 0,
    })
    .on("change", (mode) => {
      console.log(mode.value);
      let diffuseMap = material.uniforms.diffuseMap.value;
      let useBorder = 0.0;

      switch (mode.value) {
        case 0:
          {
            diffuseMap.wrapS = THREE.RepeatWrapping;
            diffuseMap.wrapT = THREE.RepeatWrapping;
          }
          break;
        case 1:
          {
            diffuseMap.wrapS = THREE.MirroredRepeatWrapping;
            diffuseMap.wrapT = THREE.MirroredRepeatWrapping;
          }
          break;
        case 2:
          {
            diffuseMap.wrapS = THREE.ClampToEdgeWrapping;
            diffuseMap.wrapT = THREE.ClampToEdgeWrapping;
          }
          break;
        case 3:
          {
            useBorder = 1.0;
          }
          break;
      }
      diffuseMap.needsUpdate = true;
      material.uniforms.useBorder.value = useBorder;
      material.uniforms.diffuseMap.value = diffuseMap;
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
