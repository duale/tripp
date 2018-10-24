using System;
using UnityEngine;

public class Utils {
	public static Color ColorWithAlpha(Color c, float alpha) {
		return new Color(c.r, c.g, c.b, alpha);
	}
}
