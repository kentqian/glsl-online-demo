precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // View vector (eye to fragment)

uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
// HINT: Use the environment map as the ambient color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform vec3 lightPos; // Light position

uniform samplerCube envTexSampler; // A GLSL sampler represents a single texture. A samplerCube can be used to sample a cubemap texture.

void main() {
  // Your solution should go here.
  // Only the ambient colour calculations have been provided as an example.

  vec4 N = normalize(vec4(normalInterp, 0.0));
  vec4 L_dir = normalize(vec4(lightPos, 1.0) - vec4(vertPos,1.0));  
  float I_diffuse = max(dot(N, L_dir), 0.0);

  vec4 eye_vec = normalize(vec4(-vertPos,0.0));
  vec4 H = normalize(L_dir + eye_vec);

  vec3 reflect_2_sky = reflect(viewVec, vec3(N));
  vec4 environment = textureCube(envTexSampler,reflect_2_sky);

  float intSpec = max(dot(N,H), 0.0);
  float I_specular = pow(intSpec, shininessVal);
  gl_FragColor = Ka * environment + I_diffuse * Kd * vec4(diffuseColor, 1.0) + Ks * vec4(specularColor, 1.0) * I_specular;
}
