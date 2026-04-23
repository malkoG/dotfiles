// --- CONFIGURATION ---
vec4 TRAIL_COLOR = iCurrentCursorColor; // can change to eg: vec4(0.2, 0.6, 1.0, 0.5);
const float DURATION = 0.2; // total animation time
const float TRAIL_SIZE = 0.8; // 0.0 = all corners move together. 1.0 = max smear (leading corners jump instantly)
const float THRESHOLD_MIN_DISTANCE = 1.5; // min distance to show trail (units of cursor height)
const float BLUR = 1.0; // blur size in pixels (for antialiasing)
const float TRAIL_THICKNESS = 1.0;  // 1.0 = full cursor height, 0.0 = zero height, >1.0 = funky aah
const float TRAIL_THICKNESS_X = 0.9;

const float FADE_ENABLED = 0.0; // 1.0 to enable fade gradient along the trail, 0.0 to disable
const float FADE_EXPONENT = 5.0; // exponent for fade gradient along the trail

// --- CONSTANTS for easing functions ---
const float PI = 3.14159265359;
const float C1_BACK = 1.70158;
const float C2_BACK = C1_BACK * 1.525;
const float C3_BACK = C1_BACK + 1.0;
const float C4_ELASTIC = (2.0 * PI) / 3.0;
const float C5_ELASTIC = (2.0 * PI) / 4.5;
const float SPRING_STIFFNESS = 9.0;
const float SPRING_DAMPING = 0.9;

// --- EASING FUNCTIONS ---

// // Linear
// float ease(float x) {
//     return x;
// }

// // EaseOutQuad
// float ease(float x) {
//     return 1.0 - (1.0 - x) * (1.0 - x);
// }

// // EaseOutCubic
// float ease(float x) {
//     return 1.0 - pow(1.0 - x, 3.0);
// }

// // EaseOutQuart
// float ease(float x) {
//     return 1.0 - pow(1.0 - x, 4.0);
// }

// // EaseOutQuint
// float ease(float x) {
//     return 1.0 - pow(1.0 - x, 5.0);
// }

// // EaseOutSine
// float ease(float x) {
//     return sin((x * PI) / 2.0);
// }

// // EaseOutExpo
// float ease(float x) {
//     return x == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * x);
// }

// EaseOutCirc
float ease(float x) {
    return sqrt(1.0 - pow(x - 1.0, 2.0));
}

// // EaseOutBack
// float ease(float x) {
//     return 1.0 + C3_BACK * pow(x - 1.0, 3.0) + C1_BACK * pow(x - 1.0, 2.0);
// }

// // EaseOutElastic
// float ease(float x) {
//     return x == 0.0 ? 0.0
//          : x == 1.0 ? 1.0
//                     : pow(2.0, -10.0 * x) * sin((x * 10.0 - 0.75) * C4_ELASTIC) + 1.0;
// }

// // Parametric Spring
// float ease(float x) {
//     x = clamp(x, 0.0, 1.0);
//     float decay = exp(-SPRING_DAMPING * SPRING_STIFFNESS * x);
//     float freq = sqrt(SPRING_STIFFNESS * (1.0 - SPRING_DAMPING * SPRING_DAMPING));
//     float osc = cos(freq * 6.283185 * x) + (SPRING_DAMPING * sqrt(SPRING_STIFFNESS) / freq) * sin(freq * 6.283185 * x);
//     return 1.0 - decay * osc;
// }

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfConvexQuad(in vec2 p, in vec2 v1, in vec2 v2, in vec2 v3, in vec2 v4) {
    float s = 1.0;
    float d = dot(p - v1, p - v1);

    d = seg(p, v1, v2, s, d);
    d = seg(p, v2, v3, s, d);
    d = seg(p, v3, v4, s, d);
    d = seg(p, v4, v1, s, d);

    return s * sqrt(d);
}

vec2 toGhosttyUv(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance, float blurAmount) {
  return 1. - smoothstep(0., toGhosttyUv(vec2(blurAmount, blurAmount), 0.).x, distance);
}

// Determines animation duration based on a corner's alignment with the move direction(dot product)
// dot_val will be in [-2, 2]
// > 0.5 (1 or 2) = Leading
// > -0.5 (0)     = Side
// <= -0.5 (-1 or -2) = Trailing
float getDurationFromDot(float dot_val, float DURATION_LEAD, float DURATION_SIDE, float DURATION_TRAIL) {
    float isLead = step(0.5, dot_val);
    float isSide = step(-0.5, dot_val) * (1.0 - isLead);

    // Start with trailing duration
    float duration = mix(DURATION_TRAIL, DURATION_SIDE, isSide);
    // Mix in leading duration
    duration = mix(duration, DURATION_LEAD, isLead);
    return duration;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    // normalization & setup(-1, 1 coords)
    vec2 vu = toGhosttyUv(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor = vec4(toGhosttyUv(iCurrentCursor.xy, 1.), toGhosttyUv(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(toGhosttyUv(iPreviousCursor.xy, 1.), toGhosttyUv(iPreviousCursor.zw, 0.));

    vec2 centerCC = currentCursor.xy - (currentCursor.zw * offsetFactor);
    vec2 halfSizeCC = currentCursor.zw * 0.5;
    vec2 centerCP = previousCursor.xy - (previousCursor.zw * offsetFactor);
    vec2 halfSizeCP = previousCursor.zw * 0.5;

    float sdfCurrentCursor = getSdfRectangle(vu, centerCC, halfSizeCC);

    float lineLength = distance(centerCC, centerCP);
    float minDist = currentCursor.w * THRESHOLD_MIN_DISTANCE;

    float baseProgress = iTime - iTimeCursorChange;
    float sparkAlpha = 0.0;
    float sparkCoreAlpha = 0.0;
    float sparkParticleAlpha = 0.0;
    vec3 sparkColor = iCurrentCursorColor.rgb;
    vec3 sparkParticleColor = vec3(0.0);
    vec2 sparkDelta = centerCC - centerCP;
    float sparkActive = step(0.0, sparkDelta.x);
    sparkActive *= 1.0 - step(0.18, baseProgress);
    sparkActive *= step(currentCursor.w * 0.02, sparkDelta.x);
    sparkActive *= 1.0 - step(currentCursor.w * 1.80, sparkDelta.x);
    sparkActive *= 1.0 - step(currentCursor.w * 0.55, abs(sparkDelta.y));

    if (sparkActive > 0.5) {
        float sparkProgress = clamp(baseProgress / 0.18, 0.0, 1.0);
        float sparkFade = pow(1.0 - sparkProgress, 1.18);
        vec2 sparkCenter = centerCC + vec2(currentCursor.z * 0.10, 0.0);
        vec2 sparkUpper = sparkCenter + vec2(0.0, currentCursor.w * 0.24);
        vec2 sparkLower = sparkCenter - vec2(0.0, currentCursor.w * 0.24);
        vec2 streakDir = normalize(vec2(1.0, -0.32));
        vec2 streakDir2 = normalize(vec2(1.0, 0.24));
        vec2 streakDir3 = normalize(vec2(1.0, -0.04));
        vec2 streakStart = sparkCenter + vec2(currentCursor.w * 0.05, 0.0);
        vec2 streakStart2 = sparkCenter + vec2(currentCursor.w * 0.02, currentCursor.w * 0.04);
        vec2 streakStart3 = sparkCenter + vec2(currentCursor.w * 0.08, -currentCursor.w * 0.03);
        vec2 streakVec = vu - streakStart;
        vec2 streakVec2 = vu - streakStart2;
        vec2 streakVec3 = vu - streakStart3;
        float streakAlong = clamp(dot(streakVec, streakDir), 0.0, currentCursor.w * mix(0.8, 2.4, sparkProgress));
        float streakAlong2 = clamp(dot(streakVec2, streakDir2), 0.0, currentCursor.w * mix(0.5, 1.8, sparkProgress));
        float streakAlong3 = clamp(dot(streakVec3, streakDir3), 0.0, currentCursor.w * mix(0.7, 2.1, sparkProgress));
        vec2 streakClosest = streakStart + streakDir * streakAlong;
        vec2 streakClosest2 = streakStart2 + streakDir2 * streakAlong2;
        vec2 streakClosest3 = streakStart3 + streakDir3 * streakAlong3;
        float streakDist = length(vu - streakClosest);
        float streakDist2 = length(vu - streakClosest2);
        float streakDist3 = length(vu - streakClosest3);
        vec2 particleDir1 = normalize(vec2(0.95, -0.82));
        vec2 particleDir2 = normalize(vec2(1.00, -0.22));
        vec2 particleDir3 = normalize(vec2(0.82, 0.72));
        vec2 particleDir4 = normalize(vec2(-0.88, 0.86));
        vec2 particleDir5 = normalize(vec2(-1.00, 0.12));
        vec2 particleDir6 = normalize(vec2(-0.72, -0.92));
        vec2 particleCurve1 = vec2(0.20, 0.42);
        vec2 particleCurve2 = vec2(0.12, 0.18);
        vec2 particleCurve3 = vec2(-0.18, -0.36);
        vec2 particleCurve4 = vec2(0.24, -0.34);
        vec2 particleCurve5 = vec2(0.08, -0.16);
        vec2 particleCurve6 = vec2(-0.22, 0.40);
        float particleProg1 = pow(sparkProgress, 0.70);
        float particleProg2 = pow(sparkProgress, 0.88);
        float particleProg3 = pow(sparkProgress, 1.02);
        float particleProg4 = pow(sparkProgress, 0.76);
        float particleProg5 = pow(sparkProgress, 0.94);
        float particleProg6 = pow(sparkProgress, 1.12);
        vec2 particlePos1 = sparkCenter
            + particleDir1 * (currentCursor.w * mix(0.08, 1.95, particleProg1))
            + particleCurve1 * (currentCursor.w * particleProg1 * particleProg1);
        vec2 particlePos2 = sparkCenter
            + particleDir2 * (currentCursor.w * mix(0.06, 1.62, particleProg2))
            + particleCurve2 * (currentCursor.w * particleProg2 * particleProg2);
        vec2 particlePos3 = sparkCenter
            + particleDir3 * (currentCursor.w * mix(0.08, 1.84, particleProg3))
            + particleCurve3 * (currentCursor.w * particleProg3 * particleProg3);
        vec2 particlePos4 = sparkCenter
            + particleDir4 * (currentCursor.w * mix(0.08, 1.88, particleProg4))
            + particleCurve4 * (currentCursor.w * particleProg4 * particleProg4);
        vec2 particlePos5 = sparkCenter
            + particleDir5 * (currentCursor.w * mix(0.06, 1.56, particleProg5))
            + particleCurve5 * (currentCursor.w * particleProg5 * particleProg5);
        vec2 particlePos6 = sparkCenter
            + particleDir6 * (currentCursor.w * mix(0.08, 1.92, particleProg6))
            + particleCurve6 * (currentCursor.w * particleProg6 * particleProg6);
        float particleDist1 = length(vu - particlePos1);
        float particleDist2 = length(vu - particlePos2);
        float particleDist3 = length(vu - particlePos3);
        float particleDist4 = length(vu - particlePos4);
        float particleDist5 = length(vu - particlePos5);
        float particleDist6 = length(vu - particlePos6);

        float coreRadius = currentCursor.w * mix(0.72, 0.32, sparkProgress);
        float sideRadius = currentCursor.w * mix(0.64, 0.20, sparkProgress);
        float streakRadius = currentCursor.w * mix(0.16, 0.06, sparkProgress);
        float glowRadius = currentCursor.w * mix(1.05, 0.48, sparkProgress);
        float particleRadius1 = currentCursor.w * mix(0.24, 0.08, sparkProgress);
        float particleRadius2 = currentCursor.w * mix(0.20, 0.07, sparkProgress);
        float particleRadius3 = currentCursor.w * mix(0.18, 0.06, sparkProgress);
        float particleRadius4 = currentCursor.w * mix(0.20, 0.06, sparkProgress);
        float particleRadius5 = currentCursor.w * mix(0.18, 0.05, sparkProgress);
        float particleRadius6 = currentCursor.w * mix(0.17, 0.05, sparkProgress);

        float core = 1.0 - smoothstep(coreRadius * 0.20, coreRadius, length(vu - sparkCenter));
        float upper = 1.0 - smoothstep(sideRadius * 0.18, sideRadius, length(vu - sparkUpper));
        float lower = 1.0 - smoothstep(sideRadius * 0.18, sideRadius, length(vu - sparkLower));
        float streak = 1.0 - smoothstep(streakRadius * 0.35, streakRadius, streakDist);
        float streak2 = 1.0 - smoothstep(streakRadius * 0.30, streakRadius * 0.82, streakDist2);
        float streak3 = 1.0 - smoothstep(streakRadius * 0.32, streakRadius * 0.90, streakDist3);
        float glow = 1.0 - smoothstep(glowRadius * 0.28, glowRadius, length(vu - sparkCenter));
        float particle1 = 1.0 - smoothstep(particleRadius1 * 0.25, particleRadius1, particleDist1);
        float particle2 = 1.0 - smoothstep(particleRadius2 * 0.25, particleRadius2, particleDist2);
        float particle3 = 1.0 - smoothstep(particleRadius3 * 0.25, particleRadius3, particleDist3);
        float particle4 = 1.0 - smoothstep(particleRadius4 * 0.25, particleRadius4, particleDist4);
        float particle5 = 1.0 - smoothstep(particleRadius5 * 0.25, particleRadius5, particleDist5);
        float particle6 = 1.0 - smoothstep(particleRadius6 * 0.25, particleRadius6, particleDist6);
        float particleFade1 = pow(1.0 - particleProg1, 1.05);
        float particleFade2 = pow(1.0 - particleProg2, 1.30);
        float particleFade3 = pow(1.0 - particleProg3, 1.60);
        float particleFade4 = pow(1.0 - particleProg4, 1.18);
        float particleFade5 = pow(1.0 - particleProg5, 1.75);
        float particleFade6 = pow(1.0 - particleProg6, 2.00);
        float p1 = particle1 * 0.86 * particleFade1;
        float p2 = particle2 * 0.72 * particleFade2;
        float p3 = particle3 * 0.72 * particleFade3;
        float p4 = particle4 * 0.76 * particleFade4;
        float p5 = particle5 * 0.64 * particleFade5;
        float p6 = particle6 * 0.74 * particleFade6;
        sparkCoreAlpha = (glow * 0.16 + core * 0.88 + upper * 0.54 + lower * 0.54 + streak * 0.38 + streak2 * 0.26 + streak3 * 0.18) * sparkFade;
        sparkParticleAlpha = (p1 + p2 + p3 + p4 + p5 + p6) * sparkFade;

        sparkAlpha = clamp(sparkCoreAlpha + sparkParticleAlpha, 0.0, 1.0);

        float particleMax = p1;
        sparkParticleColor = vec3(1.00, 0.18, 0.18);
        if (p2 > particleMax) {
            particleMax = p2;
            sparkParticleColor = vec3(1.00, 0.55, 0.12);
        }
        if (p3 > particleMax) {
            particleMax = p3;
            sparkParticleColor = vec3(1.00, 0.92, 0.18);
        }
        if (p4 > particleMax) {
            particleMax = p4;
            sparkParticleColor = vec3(0.18, 0.95, 0.32);
        }
        if (p5 > particleMax) {
            particleMax = p5;
            sparkParticleColor = vec3(0.20, 0.55, 1.00);
        }
        if (p6 > particleMax) {
            particleMax = p6;
            sparkParticleColor = vec3(0.78, 0.28, 1.00);
        }
        vec3 sparkCoreColor = mix(iCurrentCursorColor.rgb, vec3(1.0, 0.95, 0.78), 0.72);
        sparkParticleAlpha = particleMax * sparkFade;
        sparkColor = sparkCoreColor;
    }

    vec4 newColor = vec4(fragColor);

    if (lineLength > minDist && baseProgress < DURATION - 0.001) {
        // defining corners of cursors

        // Y (Height) with TRAIL_THICKNESS
        float cc_half_height = currentCursor.w * 0.5;
        float cc_center_y = currentCursor.y - cc_half_height;
        float cc_new_half_height = cc_half_height * TRAIL_THICKNESS;
        float cc_new_top_y = cc_center_y + cc_new_half_height;
        float cc_new_bottom_y = cc_center_y - cc_new_half_height;

        // X (Width) with TRAIL_THICKNESS
        float cc_half_width = currentCursor.z * 0.5;
        float cc_center_x = currentCursor.x + cc_half_width;
        float cc_new_half_width = cc_half_width * TRAIL_THICKNESS_X;
        float cc_new_left_x = cc_center_x - cc_new_half_width;
        float cc_new_right_x = cc_center_x + cc_new_half_width;

        vec2 cc_tl = vec2(cc_new_left_x, cc_new_top_y);
        vec2 cc_tr = vec2(cc_new_right_x, cc_new_top_y);
        vec2 cc_bl = vec2(cc_new_left_x, cc_new_bottom_y);
        vec2 cc_br = vec2(cc_new_right_x, cc_new_bottom_y);

        // same thing for previous cursor
        float cp_half_height = previousCursor.w * 0.5;
        float cp_center_y = previousCursor.y - cp_half_height;
        float cp_new_half_height = cp_half_height * TRAIL_THICKNESS;
        float cp_new_top_y = cp_center_y + cp_new_half_height;
        float cp_new_bottom_y = cp_center_y - cp_new_half_height;

        float cp_half_width = previousCursor.z * 0.5;
        float cp_center_x = previousCursor.x + cp_half_width;
        float cp_new_half_width = cp_half_width * TRAIL_THICKNESS_X;
        float cp_new_left_x = cp_center_x - cp_new_half_width;
        float cp_new_right_x = cp_center_x + cp_new_half_width;

        vec2 cp_tl = vec2(cp_new_left_x, cp_new_top_y);
        vec2 cp_tr = vec2(cp_new_right_x, cp_new_top_y);
        vec2 cp_bl = vec2(cp_new_left_x, cp_new_bottom_y);
        vec2 cp_br = vec2(cp_new_right_x, cp_new_bottom_y);

        // calculating durations for every corner
        const float DURATION_TRAIL = DURATION;
        const float DURATION_LEAD = DURATION * (1.0 - TRAIL_SIZE);
        const float DURATION_SIDE = (DURATION_LEAD + DURATION_TRAIL) / 2.0;

        vec2 moveVec = centerCC - centerCP;
        vec2 s = sign(moveVec);

        // dot products for each corner, determining alignment with movement direction
        float dot_tl = dot(vec2(-1., 1.), s);
        float dot_tr = dot(vec2( 1., 1.), s);
        float dot_bl = dot(vec2(-1.,-1.), s);
        float dot_br = dot(vec2( 1.,-1.), s);

        // assign durations based on dot products
        float dur_tl = getDurationFromDot(dot_tl, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
        float dur_tr = getDurationFromDot(dot_tr, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
        float dur_bl = getDurationFromDot(dot_bl, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
        float dur_br = getDurationFromDot(dot_br, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);

        // check direction of horizontal movement
        float isMovingRight = step(0.5, s.x);
        float isMovingLeft  = step(0.5, -s.x);

        // calculate vertical-rail durations
        float dot_right_edge = (dot_tr + dot_br) * 0.5;
        float dur_right_rail = getDurationFromDot(dot_right_edge, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);

        float dot_left_edge = (dot_tl + dot_bl) * 0.5;
        float dur_left_rail = getDurationFromDot(dot_left_edge, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);

        float final_dur_tl = mix(dur_tl, dur_left_rail, isMovingLeft);
        float final_dur_bl = mix(dur_bl, dur_left_rail, isMovingLeft);

        float final_dur_tr = mix(dur_tr, dur_right_rail, isMovingRight);
        float final_dur_br = mix(dur_br, dur_right_rail, isMovingRight);

        // calculate progress for each corner based on the duration and time since cursor change
        float prog_tl = ease(clamp(baseProgress / final_dur_tl, 0.0, 1.0));
        float prog_tr = ease(clamp(baseProgress / final_dur_tr, 0.0, 1.0));
        float prog_bl = ease(clamp(baseProgress / final_dur_bl, 0.0, 1.0));
        float prog_br = ease(clamp(baseProgress / final_dur_br, 0.0, 1.0));

        // get the trial corner positions based on progress
        vec2 v_tl = mix(cp_tl, cc_tl, prog_tl);
        vec2 v_tr = mix(cp_tr, cc_tr, prog_tr);
        vec2 v_br = mix(cp_br, cc_br, prog_br);
        vec2 v_bl = mix(cp_bl, cc_bl, prog_bl);

        // DRAWING THE TRAIL
        float sdfTrail = getSdfConvexQuad(vu, v_tl, v_tr, v_br, v_bl);

        // --- FADE GRADIENT CALCULATION ---
        vec2 fragVec = vu - centerCP;

        // project fragment onto movement vector, normalize to [0, 1]
        // 0.0 at tail, 1.0 at head
        // tiny epsilon to avoid division by zero if moveVec is (0,0)
        float fadeProgress = clamp(dot(fragVec, moveVec) / (dot(moveVec, moveVec) + 1e-6), 0.0, 1.0);

        vec4 trail = TRAIL_COLOR;

        float effectiveBlur = BLUR;
        if (BLUR < 2.5) {
          // no antialising on horizontal/vertical movement, fixes 'pulse' like thing on end cursor
          float isDiagonal = abs(s.x) * abs(s.y); // 1.0 if diagonal, 0.0 if H/V
          float effectiveBlur = mix(0.0, BLUR, isDiagonal);
        }
        float shapeAlpha = antialising(sdfTrail, effectiveBlur); // shape mask

        if (FADE_ENABLED > 0.5) {
            // apply fade gradient along the trail
            // float fadeStart = 0.2;
            // float easedProgress = smoothstep(fadeStart, 1.0, fadeProgress);
            // easedProgress = pow(2.0, 10.0 * (fadeProgress - 1.0));
            float easedProgress = pow(fadeProgress, FADE_EXPONENT);
            trail.a *= easedProgress;
        }

        float finalAlpha = trail.a * shapeAlpha;

        // newColor.a to preserve the background alpha.
        newColor = mix(newColor, vec4(trail.rgb, newColor.a), finalAlpha);

        // punch hole on the trail, so current cursor is drawn on top
        newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.));

    }

    if (sparkCoreAlpha > 0.0) {
        newColor = mix(newColor, vec4(sparkColor, newColor.a), clamp(sparkCoreAlpha, 0.0, 1.0));
    }
    if (sparkParticleAlpha > 0.0) {
        newColor.rgb += sparkParticleColor;
    }

    fragColor = newColor;
}
