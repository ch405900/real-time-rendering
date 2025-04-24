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
 * Check if browser supports WebGL2
 * @returns true if the browser supports WebGL2, false otherwise
 */
export function isWebG2LSupported() {
  try {
    const canvas = document.createElement('canvas');
    return !!(canvas.getContext('webgl2'));
  } catch (e) {
    return false;
  }
}