using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamControl : MonoBehaviour {
    public float MinRotation = -50;
    public float MaxRotation = 50;

	void Update () {
        // float horz = Input.GetAxis("Horizontal");
        // float vert = Input.GetAxis("Vertical");
        transform.Rotate(Vector3.forward * Mathf.Lerp(this.MinRotation, this.MaxRotation, this.Direction) * Time.deltaTime);
        // transform.Rotate(Vector3.up * horz);

    }

    public float Direction { get; set; }
}
