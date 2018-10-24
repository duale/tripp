using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UVScrollBinding : MonoBehaviour {
	public float SpeedMultiplier = 1;

	private Material _m;

	protected void Awake() {
		_m = GetComponent<MeshRenderer>().sharedMaterial;
	}

	protected void Update() {
		Vector2 offset = _m.GetTextureOffset("_MainTex");
		offset.x = (offset.x + this.ScrollSppedX * Time.deltaTime * this.SpeedMultiplier) % 1;
		offset.y = (offset.y + this.ScrollSppedY * Time.deltaTime * this.SpeedMultiplier) % 1;

		_m.SetTextureOffset("_MainTex", offset);
	}

	public float ScrollSppedX { get; set; }
	public float ScrollSppedY { get; set; }
}
