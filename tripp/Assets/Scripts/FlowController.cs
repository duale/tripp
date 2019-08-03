using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class FlowController : MonoBehaviour {
	public GameObject WormholeContainer;
	public GameObject Video;
	public MeshRenderer Fader;
	public float FadeDuration = 2f;
	public int MaxExperienceDuration = 300;
	public Reaktion.Reaktor CameraRotation;
	public float IntroDuration = 20;
	public GameObject MidiControls;

	private bool _running;
	private Coroutine _killRoutine;

	public void Begin() {
		if (_killRoutine != null) return;

		Debug.Log("Begin");
		StartCoroutine(BeginCo());
	}

	public void End() {
		if (_killRoutine == null) return;

		Debug.Log("End");
		StartCoroutine(EndCo());
	}

	protected void Start() {
		Begin();
		// StartCoroutine(IntroCo());
	}

	protected void Awake() {
		this.Fader.sharedMaterial.color = Color.black;
	}

	protected void Update() {
		if (Input.GetKeyDown(KeyCode.Return)) {
			if (_killRoutine == null) {
				Begin();
			}
		}
	}

	private IEnumerator IntroCo() {
		Camera.main.GetComponent<UnityEngine.PostProcessing.PostProcessingBehaviour>().enabled = false;
		this.WormholeContainer.SetActive(false);
		this.MidiControls.SetActive(false);
		this.Video.SetActive(true);
		yield return SetFaderAlpha(0f);
	}

	private IEnumerator BeginCo() {
		yield return SetFaderAlpha(1f);
		Camera.main.GetComponent<UnityEngine.PostProcessing.PostProcessingBehaviour>().enabled = true;
		this.Video.SetActive(false);
		this.WormholeContainer.SetActive(true);
		Camera.main.transform.localEulerAngles = Vector3.zero;
		this.CameraRotation.offset.Reset(0.5f);
		this.CameraRotation.Reset();
		yield return SetFaderAlpha(0f);

		_killRoutine = StartCoroutine(KillCo());

		yield return new WaitForSeconds(this.IntroDuration);

		// this.MidiControls.SetActive(true);
	}

	private IEnumerator EndCo() {
		if (_killRoutine != null) {
			StopCoroutine(_killRoutine);
			_killRoutine = null;
		}

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

	private IEnumerator KillCo() {
		yield return new WaitForSecondsRealtime(this.MaxExperienceDuration);
		End();
	}
}
