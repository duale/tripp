using System;
using System.Collections.Generic;
using UnityEngine;

public class OscStaticValues : MonoBehaviour
{
    public List<OscStaticFloatValue> Values;
    public bool SendOnStart;

    public void Send() {
        var client = OscGlobal.Instance.Client;
        if (client == null) return;

        foreach (var staticValue in this.Values) {
            client.Send(staticValue.Path, staticValue.Value);
        }
    }

    protected void Start() {
        if (this.SendOnStart) {
            Send();
        }
    }

    [Serializable]
    public abstract class OscStaticValue<T> {
        public string Path;
        public T Value;
    }

    [Serializable]
    public class OscStaticFloatValue : OscStaticValue<float> { }
}
