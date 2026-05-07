shader_type spatial;

uniform bool alliance = true;
uniform bool selected = false;
uniform float healthPercent = 1.0;

const vec3 allyColor = vec3(0.4,0.15,0.05);
const vec3 enemyColor = vec3(0.0, 0.1, 0.4);
const vec3 selectedColor = vec3(0.0,0.7,0.2);
const vec3 healthColor = vec3(0.9,0.1,0.0);



void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec3 alignmentColor;
	if(alliance) alignmentColor = allyColor;
	else alignmentColor = enemyColor;

	float threshold = (1.0 - dot(VIEW, NORMAL)); //var represents how close the view is to the normal
	float extent = 0.3 + 0.3*threshold + 0.4 * pow(threshold,2); //polynomial function for colour of the edges

	ALBEDO = mix(ALBEDO,alignmentColor, extent);
	ALBEDO = mix(healthColor, ALBEDO, (0.66 +healthPercent/3.0));
	if(selected) ALBEDO = mix(ALBEDO, selectedColor, 0.6);

	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
