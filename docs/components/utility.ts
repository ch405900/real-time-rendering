export function isWebGL2Supported() {
  try {
    const canvas = document.createElement("canvas");
    return !!(window.WebGLRenderingContext && canvas.getContext("webgl2"));
  } catch (e) {
    return false;
  }
}
