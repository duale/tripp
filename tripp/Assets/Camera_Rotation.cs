using UnityEngine;

public class Camera_Rotation : MonoBehaviour {
   

	
	// Update is called once per frame
	void Update () {

        transform.Rotate(Vector3.forward * Time.deltaTime * 10);



    }
}
