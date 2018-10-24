using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class ShaderBinding : MonoBehaviour {
	private Material _m;

	protected void Awake() {
		_m = GetComponent<MeshRenderer>().material;
	}

	public void SetFloat(string param, float value) {
		_m.SetFloat(param, value);
	}

	public void SetColor(string param, Color value) {
		_m.SetColor(param, value);
	}
}
