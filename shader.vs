precision mediump float;

attribute vec4 pos;
attribute vec2 uv_coord;

uniform mat4 modelView;
uniform mat4 projection;

varying vec2 uv;

void main(void) {
    vec4 p = modelView * pos;
    gl_Position = projection * p;
    uv = uv_coord;
}