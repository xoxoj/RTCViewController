precision highp float;
uniform lowp sampler2D texY, texU, texV;

varying vec2 uv;

void main(void) {
    float y, u, v, r, g, b;
    
    y = texture2D(texY, uv).r;
    u = texture2D(texU, uv).r;
    v = texture2D(texV, uv).r;
    
    u = u - 0.5;
    v = v - 0.5;
    
    r = y + 1.403 * v;
    g = y - 0.344 * u - 0.714 * v;
    b = y + 1.770 * u;
    
    if (g > 0.52 && g < 0.53 && r < -0.70 && r > -0.71 && b < -0.88 && b > -0.89) {
        r = 0.2; g = 0.2; b = 0.2;
    }
    
    gl_FragColor = vec4(r, g, b, 1.0);
}