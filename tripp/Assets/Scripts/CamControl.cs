using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamControl : MonoBehaviour {
    public float MinRotation = -50;
    public float MaxRotation = 50;
    public float DefaultDirection = 0.5f;

    protected void Awake() {
        this.Direction = this.DefaultDirection;
    }

	protected void Update () {
        transform.Rotate(Vector3.forward * Mathf.Lerp(this.MinRotation, this.MaxRotation, this.Direction) * Time.deltaTime);
    }

    public float Direction { get; set; }
}
