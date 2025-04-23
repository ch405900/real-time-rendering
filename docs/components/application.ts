import * as THREE from "three";
import { isWebGL2Supported } from "./utility";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { TransformControls } from 'three/addons/controls/TransformControls.js';


interface ApplicationConfig {
    enableOrbitControls: boolean;
    enableTransformControls: boolean;
}

export class ApplicationBuilder {

    config: ApplicationConfig;
    container: HTMLElement
    constructor(container: HTMLElement) {
        this.config = {
            enableOrbitControls: false,
            enableTransformControls: false,
        }
        this.container = container;
    }

    orbitControls() {
        this.config.enableOrbitControls = true;
        return this;
    }

    transformControls() {
        this.config.enableTransformControls = true;
        return this;
    }

    build(): Application {
        const app = new Application(this.container, this.config.enableOrbitControls, this.config.enableTransformControls);
        return app;
    }

}


export default class Application {
    public scene: THREE.Scene;
    public camera: THREE.PerspectiveCamera;
    public renderer: THREE.WebGLRenderer;
    private orbit: OrbitControls | undefined = undefined;
    private transformControl: TransformControls | undefined = undefined;
    constructor(container: HTMLElement, enableOrbitControls: boolean, enableTransformControls: boolean) {
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
        console.log(container);
        this.attachTo(container);
        if (enableOrbitControls) {
            this.orbitControls();
        }
        if (enableTransformControls) {
            this.transformControls();
        }
    }

    private attachTo(container: HTMLElement) {
        this.camera = new THREE.PerspectiveCamera(75, container.clientWidth / container.clientHeight, 0.1, 1000);
        this.renderer.setSize(container.clientWidth, container.clientHeight);
        container.appendChild(this.renderer.domElement);
    }

    private orbitControls() {
        this.orbit = new OrbitControls(this.camera, this.renderer.domElement);
        this.camera.position.z = 2;
    }

    private transformControls() {
        this.transformControl = new TransformControls(this.camera, this.renderer.domElement);
        this.transformControl.addEventListener('dragging-changed', function (event) {
            if (this.orbit) {
                this.orbit.enabled = !event.value;
            }
            console.log(this);
        }.bind(this));
        const gizmo = this.transformControl.getHelper();
        this.scene.add(gizmo);
    }


    run(cb: (() => void) | undefined = undefined) {
        const animate = () => {
            requestAnimationFrame(animate);
            this.update();
            if (cb) {
                cb();
            }
        };
        animate();
    }


    update() {
        this.orbit?.update();
        this.renderer.render(this.scene, this.camera);
    }

    addMesh(mesh: THREE.Mesh) {
        this.scene.add(mesh);
        this.transformControl?.attach(mesh)
    }

    private resetTransform(mesh) {
        mesh.position.set(0, 0, 0);
        mesh.rotation.set(0, 0, 0);
        mesh.scale.set(1, 1, 1);
        mesh.updateMatrixWorld(true);
    }

    reset() {
        this.orbit?.reset();
        this.transformControl?.reset();
        this.camera.position.set(0, 0, 2);
        this.scene.traverse(obj => {
            if ((obj as THREE.Mesh).isMesh) {
                const mesh = obj as THREE.Mesh;
                this.resetTransform(mesh);
            }
        });
    }

    dispose() {
        this.renderer.dispose();
    }

    isWebGL2() {
        return this.renderer.getContext() instanceof WebGL2RenderingContext;
    }
}
