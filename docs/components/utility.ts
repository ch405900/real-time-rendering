/**
 * Check if the browser supports WebGL2
 * @returns true if the browser supports WebGL2, false otherwise
 */
export function isWebGL2Supported() {
  try {
    const canvas = document.createElement("canvas");
    return !!(window.WebGLRenderingContext && canvas.getContext("webgl2"));
  } catch (e) {
    return false;
  }
}

/**
 * Check if browser supports WebGL
 * @returns true if the browser supports WebGL, false otherwise
 */
export function isWebGLSupported() {
  try {
    const canvas = document.createElement("canvas");
    return !!canvas.getContext("webgl");
  } catch (e) {
    return false;
  }
}

export function loadShader(shaderSource: string) {
  const [vertexRaw, fragmentRaw] = shaderSource.split("// -- fragment");
  const vertex = vertexRaw.replace("// -- vertex", "").trim();
  const fragment = fragmentRaw.trim();
  return { vertexShader: vertex, fragmentShader: fragment };
}
