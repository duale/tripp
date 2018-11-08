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
		StartCoroutine(IntroCo());
	}

	protected void Awake() {
		this.Fader.sharedMaterial.color = Color.black;
	}

	private IEnumerator IntroCo() {
		this.Video.SetActive(true);
		yield return SetFaderAlpha(0f);
	}

	private IEnumerator BeginCo() {
		yield return SetFaderAlpha(1f);
		this.Video.SetActive(false);
		this.WormholeContainer.SetActive(true);
		Camera.main.transform.localEulerAngles = Vector3.zero;
		yield return SetFaderAlpha(0f);

		_killRoutine = StartCoroutine(KillCo());
	}

	private IEnumerator EndCo() {
		if (_killRoutine != null) {
			StopCoroutine(_killRoutine);
			_killRoutine = null;
		}

		yield return SetFaderAlpha(1f);
		this.Video.SetActive(true);
		this.WormholeContainer.SetActive(false);
		yield return SetFaderAlpha(0f);
	}

	private YieldInstruction SetFaderAlpha(float alpha) {
		return DOTween.ToAlpha(() => this.Fader.sharedMaterial.color, (x) => this.Fader.sharedMaterial.color = x, alpha, this.FadeDuration)
			.WaitForCompletion();
	}

	private IEnumerator KillCo() {
		yield return new WaitForSeconds(this.MaxExperienceDuration);
		End();
	}
}
