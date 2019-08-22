using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System.Linq;

public class FlowController : MonoBehaviour {
	public GameObject WormholeContainer;
	public GameObject Video;
	public MeshRenderer Fader;
	public float FadeDuration = 2f;
	// public int MaxExperienceDuration = 300;
	// public Reaktion.Reaktor CameraRotation;
	public float IntroDuration = 20;
	public AudioSource IntroAudio;
	public AudioSource[] ControllableAudio;

	private OscJack.OscClient _client;
	private bool _running;
	// private Coroutine _killRoutine;

	private float[] _spectrum = new float[1024];
	private float[] _spectrum3 = new float[1024];
	private float[] _spectrum2 = new float[64];
	private float[] _spectrum4 = new float[128];

	public void Begin() {
		if (this.State != FlowState.Title) return;

		Debug.Log("Begin");
		StartCoroutine(BeginCo());
	}

	public void End() {
		if (this.State != FlowState.Play) return;

		StartCoroutine(EndCo());
	}

	protected void Start() {
		StartCoroutine(ShowTitleCo());
	}

	protected void Awake() {
		this.Fader.sharedMaterial.color = Color.black;
		_client = OscGlobal.Instance.Client;
	}

	protected void Update() {
		// if (Input.GetKeyDown(KeyCode.Return)) {
		// 	if (_killRoutine == null) {
		// 		Begin();
		// 	}
		// }

		switch (this.State) {
			case FlowState.Title:
				_client.Send("/title");
				break;
			case FlowState.Intro:
				this.IntroAudio.GetSpectrumData(_spectrum, 0, FFTWindow.Rectangular);

				System.Array.Copy(_spectrum, _spectrum4, _spectrum4.Length);

				for (var i = 0; i < _spectrum2.Length; i++) {
					var total = 0f;
					for (var j = 0; j < _spectrum4.Length / _spectrum2.Length; j++) {
						var val = _spectrum4[(i * _spectrum4.Length / _spectrum2.Length) + j];
						total = Mathf.Max(val, total);
					}
					_spectrum2[i] = total * 2;
				}
				
				_client.Send("/intro");
				_client.Send("/intro/analyzer", _spectrum2);

				break;
			case FlowState.Play:
				_client.Send("/main");
				break;
		}
	}

	private IEnumerator ShowTitleCo() {
		this.State = FlowState.Title;

		Camera.main.GetComponent<UnityEngine.PostProcessing.PostProcessingBehaviour>().enabled = false;
		this.WormholeContainer.SetActive(false);
		// this.MidiControls.SetActive(false);
		this.Video.SetActive(true);
		yield return SetFaderAlpha(0f);
	}

	private IEnumerator BeginCo() {
		this.State = FlowState.Intro;
		UpdateTimer(0, "/intro/timer");
		_client.Send("/intro");

		yield return SetFaderAlpha(1f);
		Camera.main.GetComponent<UnityEngine.PostProcessing.PostProcessingBehaviour>().enabled = true;
		this.Video.SetActive(false);
		this.WormholeContainer.SetActive(true);
		Camera.main.transform.localEulerAngles = Vector3.zero;
		// this.CameraRotation.offset.Reset(0.5f);
		// this.CameraRotation.Reset();
		yield return SetFaderAlpha(0f);

		this.IntroAudio.Play();
		foreach (var source in this.ControllableAudio) {
			source.Play();
		}

		var timerAudio = this.ControllableAudio[0];

		while (this.IntroAudio.isPlaying) {
			// GetTimeLeftForAudioSource(timerAudio);
			UpdateTimer(GetTimeLeftForAudioSource(this.IntroAudio), "/intro/timer");
			yield return null;
		}

		this.State = FlowState.Play;
		// _client.Send("/main");

		// yield return null;

		while (timerAudio.isPlaying) {
			// GetTimeLeftForAudioSource(timerAudio);
			UpdateTimer(GetTimeLeftForAudioSource(timerAudio), "/main/timer");
			yield return null;
		}

		UpdateTimer(0, "/main/timer");

		End();
	}

	private int GetTimeLeftForAudioSource(AudioSource source) {
		var left = (1f - (float)source.timeSamples / source.clip.samples) * source.clip.length;

		return Mathf.FloorToInt(Mathf.Max((float)left, 0f));
	}

	private void UpdateTimer(int seconds, string address) {
		var timeString = "";

		if (seconds > 0) {
			var t = System.TimeSpan.FromSeconds(seconds);		
			timeString = string.Format("{0:D2}:{1:D2}", t.Minutes, t.Seconds);
		}

		_client.Send(address, timeString);
	}

	private IEnumerator EndCo() {
		// if (_killRoutine != null) {
		// 	StopCoroutine(_killRoutine);
		// 	_killRoutine = null;
		// }

		yield return SetFaderAlpha(1f);

		UnityEngine.SceneManagement.SceneManager.LoadScene("main_tunnel_build");

		// this.Video.SetActive(true);
		// this.WormholeContainer.SetActive(false);
		// yield return SetFaderAlpha(0f);
	}

	private YieldInstruction SetFaderAlpha(float alpha) {
		Tweener t = DOTween.ToAlpha(() => this.Fader.sharedMaterial.color, (x) => this.Fader.sharedMaterial.color = x, alpha, this.FadeDuration);
		t.SetUpdate(true);

		return t.WaitForCompletion();
	}

	// private IEnumerator KillCo() {
	// 	yield return new WaitForSecondsRealtime(this.MaxExperienceDuration);
	// 	End();
	// }

	public enum FlowState {
		None,
		Title,
		Intro,
		Play
	}

	public FlowState State { get; private set; }
}
