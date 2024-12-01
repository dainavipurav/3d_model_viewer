let scene, camera, renderer;

scene = new THREE.Scene();
camera = new THREE.PerspectiveCamera(
  75,
  window.innerWidth / window.innerHeight,
  0.1,
  1000
);
renderer = new THREE.WebGLRenderer();
document.body.appendChild(renderer.domElement);

const controls = new THREE.OrbitControls(camera, renderer.domElement);
controls.addEventListener("change", () => renderer.render(scene, camera));

setDefaultView();

function setDefaultView() {
  camera.position.set(0, 1.5, 5);
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setClearColor(0xffffff);
}

loadGlbModel("assets/html/models/city.glb", "glb");

// Function to load a GLTF model (for .glb files)
function loadGlbModel(filePath) {
  const gltfLoader = new THREE.GLTFLoader();
  gltfLoader.load(
    filePath,
    function (gltf) {
      scene.add(gltf.scene);
    },
    undefined,
    function (error) {
      console.error("Error loading GLTF model:", error);
    }
  );
}

// Function to load an OBJ model (for .obj files)
function loadObjModel(filePath) {
  const objLoader = new THREE.OBJLoader();
  objLoader.load(
    filePath,
    function (object) {
      scene.add(object);
    },
    undefined,
    function (error) {
      console.error("Error loading OBJ model:", error);
    }
  );
}

function loadFileFromDevice(byteArray, fileType) {
  try {
    jsShowLoader();
    setDefaultView();

    // Ambient Light: Provides overall light to illuminate the model
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5); // Color: White, Intensity: 0.5
    scene.add(ambientLight);

    // Point Light: Acts as a light source from a specific position (like a bulb)
    const pointLight = new THREE.PointLight(0xffffff, 1, 1000); // Color: White, Intensity: 1, Distance: 1000
    pointLight.position.set(50, 50, 50); // Position the light
    scene.add(pointLight);

    // Directional Light: Simulates sunlight, casting parallel rays
    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8); // Color: White, Intensity: 0.8
    directionalLight.position.set(-50, 100, 50); // Position the light
    directionalLight.castShadow = true; // Enable shadows if needed
    scene.add(directionalLight);

    console.log("byteArray", byteArray);

    let mimeType = "application/octet-stream";
    if (fileType === "obj") {
      mimeType = "text/plain";
    } else if (fileType === "glb") {
      mimeType = "model/gltf+json";
    }

    const blob = new Blob([byteArray], { type: mimeType });
    console.log("blob", blob);
    const url = URL.createObjectURL(blob);
    console.log("url", url);

    scene.clear();

    if (fileType === "obj") {
      loadObjModel(url);
    } else if (fileType === "glb") {
      loadGlbModel(url);
    } else {
      console.error("Unsupported file type:", fileType);
    }
  } catch (error) {
    console.error("Error loading file:", error);
  } finally {
    jsHideLoader();
  }
}
