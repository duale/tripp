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
				// _client.Send("/intro");
				this.IntroAudio.GetSpectrumData(_spectrum, 0, FFTWindow.Rectangular);
				// for (var i = 0; i < _spectrum3.Length; i++) {
				// 	_spectrum3[i] += _spectrum[i];
				// }

				System.Array.Copy(_spectrum, _spectrum4, _spectrum4.Length);

				for (var i = 0; i < _spectrum2.Length; i++) {
					var total = 0f;
					for (var j = 0; j < _spectrum4.Length / _spectrum2.Length; j++) {
						var val = _spectrum4[(i * _spectrum4.Length / _spectrum2.Length) + j];
						total = Mathf.Max(val, total);
					}
					_spectrum2[i] = total * 2;
				}
				// string data = string.Join(" ", _spectrum2);

				// Debug.Log(data);
				_client.Send("/intro/analyzer", _spectrum2);
				break;
			// case FlowState.Play:
			// 	System.Text.StringBuilder sb = new System.Text.StringBuilder();
			// 	for (var i = 0; i < _spectrum3.Length; i++) {
			// 		if (_spectrum3[i] > 1) {
			// 			sb.Append(i.ToString());
			// 			sb.Append(":");
			// 			sb.Append(_spectrum3[i].ToString());
			// 			sb.Append(" ");
			// 		}
			// 	}
			// 	Debug.Log(sb.ToString());
			// 	break;
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

		while (this.IntroAudio.isPlaying) yield return null;

		// _killRoutine = StartCoroutine(KillCo());

		this.State = FlowState.Play;
		_client.Send("/main");

		while (this.ControllableAudio[0].isPlaying) yield return null;
		End();
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
