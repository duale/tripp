﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleSystemBinding : MonoBehaviour {
	public float EmissionMultiplier = 500;

	private ParticleSystem _ps;

	protected void Awake() {
		_ps = GetComponent<ParticleSystem>();
	}

	public float Emission {
		get {
			return _ps.emission.rateOverTime.constant;
		}
		set {
			var emission = _ps.emission;
			emission.rateOverTime = value * this.EmissionMultiplier;
		}
	}

	public float SizeMultiplier {
		get {
			return _ps.main.startSizeMultiplier;
		}
		set {
			var main = _ps.main;
			main.startSizeMultiplier = value;
		}
	}

	public Color StartColor {
		get {
			return _ps.main.startColor.colorMin;
		}
		set {
			var main = _ps.main;
			// value = Utils.ColorWithAlpha(value, this.EmissionAlpha);
			main.startColor = new ParticleSystem.MinMaxGradient(value, main.startColor.colorMax);
		}
	}

	public Color EndColor {
		get {
			return _ps.main.startColor.colorMin;
		}
		set {
			var main = _ps.main;
			// value = Utils.ColorWithAlpha(value, this.EmissionAlpha);
			main.startColor = new ParticleSystem.MinMaxGradient(main.startColor.colorMin, value);
		}
	}

	// public float EmissionAlpha { get; set; }

	public float EmissionSpeed {
		get {
			return _ps.main.startSpeed.constant;
		} 
		set {
			var main = _ps.main;
			main.startSpeed = value;
		}
	}
}
