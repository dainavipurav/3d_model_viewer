let scene, camera, renderer, controls, velocity;

velocity = new THREE.Vector3();

// Initialize the scene, camera, and renderer
init();
loadfile("models/city.glb", null, "glb");

function init() {
  // Scene setup
  scene = new THREE.Scene();
  renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setClearColor(0x1e1e1e);
  document.body.appendChild(renderer.domElement);
  document.body.style.overflow = "hidden";
  document.documentElement.style.overflow = "hidden";

  // Camera setup
  camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    5000
  );
  camera.position.set(0, 1.5, 5);

  // Orbit Controls
  controls = new THREE.OrbitControls(camera, renderer.domElement);

  // Smooth dampening for rotation
  controls.enableDamping = true;
  controls.dampingFactor = 0.2;

  // Adjust rotation sensitivity
  controls.rotateSpeed = 1;

  // Limit vertical rotation
  controls.minPolarAngle = Math.PI / 4; // Minimum tilt (e.g., 45 degrees)
  controls.maxPolarAngle = Math.PI / 1.5; // Maximum tilt (e.g., 120 degrees)

  // Adjust zoom speed
  controls.zoomSpeed = 1;

  // Adjust pan speed
  controls.panSpeed = 0.5;

  // Zoom limits
  controls.minDistance = 1;
  // controls.maxDistance = 2000; // Adjust based on model size

  // Ensure the scene re-renders on control updates
  controls.addEventListener("change", () => renderer.render(scene, camera));

  // Handle window resizing
  window.addEventListener("resize", onWindowResize, false);

  // Add keyboard controls
  document.addEventListener("keydown", onKeyDown);
  document.addEventListener("keyup", onKeyUp);

  animate();
}

function onWindowResize() {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.render(scene, camera);
}

function addGridBackground() {
  const gridSize = 1000;
  const gridDivisions = 100;
  const centerLineColor = 0x2a3335;
  const gridLineColor = 0x2a3335;
  const gridHelper = new THREE.GridHelper(
    gridSize,
    gridDivisions,
    centerLineColor,
    gridLineColor
  );
  gridHelper.position.y = -1;
  scene.add(gridHelper);
}

function addGridPlane() {
  const size = 50;
  const divisions = 50;
  const gridHelper = new THREE.GridHelper(size, divisions, 0x444444, 0x888888);

  gridHelper.rotation.x = Math.PI / 2;

  scene.add(gridHelper);
}

function onKeyDown(event) {
  switch (event.code) {
    case "Space": // Move forward
      velocity.z = -0.1;
      break;
    case "ArrowUp": // Move up
      velocity.y = 0.1;
      break;
    case "ArrowDown": // Move down
      velocity.y = -0.1;
      break;
    case "ArrowLeft": // Move left
      velocity.x = -0.1;
      break;
    case "ArrowRight": // Move right
      velocity.x = 0.1;
      break;
  }
}

function onKeyUp(event) {
  switch (event.code) {
    case "Space":
    case "ArrowUp":
    case "ArrowDown":
    case "ArrowLeft":
    case "ArrowRight":
      velocity.set(0, 0, 0); // Stop movement
      break;
  }
}

function animate() {
  requestAnimationFrame(animate);

  // Apply velocity to camera position
  camera.position.add(velocity);

  controls.update();
  renderer.render(scene, camera);
}

function loadfile(filePath, materilaPath, fileType) {
  jsShowLoader();

  addLights();

  addGridBackground();

  loadModelByFileType(filePath, materilaPath, fileType);

  jsHideLoader();
}

function addLights() {
  // Ambient light
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
  scene.add(ambientLight);

  // Point light
  const pointLight = new THREE.PointLight(0xffffff, 1);
  pointLight.position.set(50, 50, 50);
  scene.add(pointLight);

  // Directional light
  const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
  directionalLight.position.set(-50, 100, 50);
  directionalLight.castShadow = true;
  scene.add(directionalLight);
}

function loadFileFromDevice(modelByteArray, materialByteArray, fileType) {
  jsShowLoader();
  const modelBlob = new Blob([modelByteArray], {
    type: "application/octet-stream",
  });
  const modelUrl = URL.createObjectURL(modelBlob);

  const materialBlobl = new Blob([materialByteArray], {
    type: "application/octet-stream",
  });
  const materialurl = URL.createObjectURL(materialBlobl);

  scene.clear();
  loadfile(modelUrl, materialurl, fileType);
  jsHideLoader();
}

function loadModelByFileType(filePath, materilaPath, fileType) {
  if (fileType === "obj") {
    loadObjModel(filePath, materilaPath);
  } else if (fileType === "glb") {
    loadGlbModel(filePath);
  } else if (fileType === "stl") {
    loadStlModel(filePath);
  } else {
    console.error("Unsupported file type:", fileType);
  }
}

function loadGlbModel(filePath) {
  const gltfLoader = new THREE.GLTFLoader();
  gltfLoader.load(
    filePath,
    (gltf) => {
      scene.add(gltf.scene);

      centerModel(gltf.scene);
    },
    undefined,
    (error) => {
      console.error("Error loading GLTF model:", error);
    }
  );
}

function loadObjModel(modelByteArray, materialByteArray) {
  var mtlLoader = new THREE.MTLLoader();

  mtlLoader.load(
    materialByteArray,
    function (materials) {
      materials.preload();

      var objLoader = new THREE.OBJLoader();

      objLoader.setMaterials(materials);
      objLoader.load(
        modelByteArray,
        function (object) {
          mesh = object;
          scene.add(mesh);
          centerModel(mesh);
        },
        undefined,
        function (error) {
          console.error("Error loading OBJ model:", error);
        }
      );
    },
    undefined,
    function (error) {
      console.error("Error loading MTL material:", error);
    }
  );
}

function loadStlModel(modelByteArray) {
  var stlLoader = new THREE.STLLoader();

  stlLoader.load(
    modelByteArray,
    (geometry) => {
      const material = new THREE.MeshStandardMaterial();

      // Create mesh
      const mesh = new THREE.Mesh(geometry, material);
      mesh.castShadow = true;
      mesh.receiveShadow = true;

      // Center the geometry
      geometry.center();

      scene.add(mesh);
      centerModel(mesh);
    },
    undefined,
    (error) => {
      console.error("Error loading STL model:", error);
    }
  );
}

// Helper function to center the model and adjust camera position
function centerModel(model) {
  const box = new THREE.Box3().setFromObject(model);
  const size = box.getSize(new THREE.Vector3());
  const center = box.getCenter(new THREE.Vector3());

  // Adjust controls target to the center of the model
  controls.target.copy(center);

  // Dynamically adjust far clipping plane
  const cameraDistance = size.length() * 2; // Distance for model visibility
  camera.far = cameraDistance * 3; // Ensure the entire model fits
  camera.updateProjectionMatrix(); // Apply changes

  camera.position.set(center.x, center.y + size.y, center.z + cameraDistance);

  // Ensure the camera remains focused on the model
  controls.update();
  renderer.render(scene, camera);
}
