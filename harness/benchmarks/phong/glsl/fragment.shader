precision mediump float;

uniform vec3 uPosition;
uniform mat4 uModel;
uniform mat4 uView;
varying vec3 vNormal;
uniform vec3 uLight;
varying vec3 vPosition;

void main() {
    mat4 v4_v3 = mat4(1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 0.);
    mat4 v3_v4 = mat4(1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 1., 0., 0., 0., 0., 0.);
    vec3 color = vec3(0.9, 0.8, 0.9);
    vec3 lightColor = vec3(0.4, 0.3, 0.9);
    float ambientStrength = 0.5;
    vec3 ambient = (ambientStrength * lightColor);
    vec3 worldPos = (vec3(v4_v3 * (uModel * (((v3_v4 * vec4(vPosition, 0.)) + vec4(0., 0., 0., 1.))))));
    vec3 worldNorm = normalize(((vec3(v4_v3 * (uModel * ((v3_v4 * vec4(vNormal, 0.))))))));
    vec3 lightDir = normalize(((uLight - worldPos)));
    float diff = dot(worldNorm, lightDir);
    bool diff_is_neg = (diff <= 0.);
    if (diff_is_neg){ diff = 0.;
    }{  }vec3 diffuse = (diff * lightColor);
    float specularStrength = 3.;
    vec3 viewDir = normalize(((vec3(0., 0., 0.) - (vec3(v4_v3 * (uView * (((v3_v4 * vec4(worldPos, 0.)) + vec4(0., 0., 0., 1.)))))))));
    mat3 neg = mat3(-(1.), 0., 0., 0., -(1.), 0., 0., 0., -(1.));
    vec3 reflectDir = ((neg * lightDir) - (((2. * dot(((neg * lightDir)), worldNorm))) * worldNorm));
    vec3 cameraReflect = (vec3(v4_v3 * (uView * ((v3_v4 * vec4(reflectDir, 0.))))));
    float spec = dot(viewDir, cameraReflect);
    bool spec_is_neg = (spec <= 0.);
    if (spec_is_neg){ spec = 0.;
    }{  }spec = (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((spec * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec)) * spec);
    vec3 specular = (((specularStrength * spec)) * vec3(1., 1., 1.));
    vec3 result = (color * ((ambient + diffuse) + specular));
    gl_FragColor = ((v3_v4 * vec4(result, 0.)) + vec4(0., 0., 0., 1.));
}