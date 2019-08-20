//
// Reaktion - An audio reactive animation toolkit for Unity.
//
// Copyright (C) 2013, 2014 Keijiro Takahashi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
using UnityEngine;
using UnityEngine.Events;
using System.Collections;

namespace Reaktion {

[AddComponentMenu("Reaktion/Gear/Generic Gradient Gear")]
public class GenericGradientGear : MonoBehaviour
{
    public enum OptionType { Color, ShaderColor }

    [System.Serializable] public class ColorEvent : UnityEvent<Color> {}
    [System.Serializable] public class ShaderColorEvent : UnityEvent<string, Color> {}

    // public ReaktorLink reaktor;

    public OptionType optionType = OptionType.Color;
    public Gradient gradient;
    public string shaderParam;
    public ColorEvent colorTarget;
    public ShaderColorEvent shaderColorTarget;

    // void Awake()
    // {
    //     reaktor.Initialize(this);
    // }

    protected void Start() {
        UpdateTarget(0);
    }

    // void Update()
    // {
    //     UpdateTarget(reaktor.Output);
    // }

    public void UpdateTarget(float param)
    {
        Color c = gradient.Evaluate(param);

        if (this.optionType == OptionType.Color) {
            this.colorTarget.Invoke(c);
        } else {
            this.shaderColorTarget.Invoke(this.shaderParam, c);
        }
    }
}

} // namespace Reaktion
