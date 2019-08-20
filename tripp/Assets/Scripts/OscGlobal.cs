using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OscGlobal : MonoBehaviour
{
    public string Host;
    public int Port;

    private OscJack.OscClient _client;
    public OscJack.OscClient Client {
        get {
            if (_client == null) {
                _client = OscJack.OscMaster.GetSharedClient(this.Host, this.Port);
            }

            return _client;
        }
    }

    private static OscGlobal _instance;
    public static OscGlobal Instance {
        get {
            if (_instance == null) {
                _instance = FindObjectOfType<OscGlobal>();
            }

            return _instance;
        }
    }
}
