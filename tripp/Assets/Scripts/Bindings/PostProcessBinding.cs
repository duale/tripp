using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PostProcessBinding : MonoBehaviour {
	private Bloom _b;
	private ChromaticAberration _ca;

	protected void Awake() {
		_b = GetComponent<Bloom>();
	}

	public float BloomIntensity {
		get {
			return _b == null ? 0 : _b.intensity.value;
		}
		set {
			if (_b != null) {
				_b.intensity.value = value;
			}
		}
	}

	public float ChromaticAberrationIntensity {
		get {
			return _ca == null ? 0 : _ca.intensity.value;
		}
		set {
			if (_ca != null) {
				_ca.intensity.value = value;
			}
		}
	}
}
