using UnityEngine;

public class MixerSender : MonoBehaviour {
    public UnityEngine.Audio.AudioMixer Mixer;
    public string ParamName;
    public Reaktion.Modifier ValueMap;

    public void SendValue(float value) {
        if (this.ValueMap != null) {
            value = this.ValueMap.Evaluate(value);
        }
        
        this.Mixer.SetFloat(this.ParamName, value);
    }
}
