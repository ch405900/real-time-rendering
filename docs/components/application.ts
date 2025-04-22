import * as THREE from "three";
import { isWebGL2Supported } from "./utility";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";

class Application {
    public scene: THREE.Scene;
    public camera: THREE.PerspectiveCamera;
    public renderer: THREE.WebGLRenderer;
    private controls: OrbitControls | undefined = undefined;
    constructor() {
        this.scene = new THREE.Scene();
        this.renderer = new THREE.WebGLRenderer();
        if (isWebGL2Supported()) {
            this.renderer = new THREE.WebGLRenderer({
                antialias: true,
                powerPreference: "high-performance",
            });
        } else {
            this.renderer = new THREE.WebGLRenderer({
                antialias: true,
            });
        }
        console.log(this.renderer.getContext().getParameter(this.renderer.getContext().VERSION));
    }

    attachTo(container: HTMLElement) {
        this.camera = new THREE.PerspectiveCamera(75, container.clientWidth / container.clientHeight, 0.1, 1000);
        this.renderer.setSize(container.clientWidth, container.clientHeight);
        container.appendChild(this.renderer.domElement);
    }

    orbitControls() {
        this.controls = new OrbitControls(this.camera, this.renderer.domElement);
        this.camera.position.z = 2;
    }


    update() {
        this.controls?.update();
        this.renderer.render(this.scene, this.camera);
    }

    addMesh(mesh: THREE.Mesh) {
        this.scene.add(mesh);
    }

    dispose(){
        this.renderer.dispose();
    }
}

export default Application;