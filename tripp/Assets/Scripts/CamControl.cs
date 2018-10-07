using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamControl : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        float horz = Input.GetAxis("Horizontal");
        float vert = Input.GetAxis("Vertical");
        transform.Rotate(Vector3.right * vert);
        transform.Rotate(Vector3.up * horz);

    }
}
