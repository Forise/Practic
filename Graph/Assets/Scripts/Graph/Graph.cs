using System.Collections.Generic;
using UnityEngine;

public class Graph : MonoBehaviour 
{
    public Transform prefab;
    [Range(10, 100)]
    public int resolution;
    public Type type;
    private List<Transform> points = new List<Transform>();
    
    private void Awake() 
    {
        float step = 2f / resolution;
        Vector3 scale = Vector3.one * step;
        Vector3 pos = Vector3.zero;
        for(int i = 0; i < resolution; i++)
        {
            Transform point = Instantiate(prefab);
            pos.x = (i + 0.5f) * step - 1;
            point.transform.localPosition = pos;
            point.transform.localScale = scale;
            point.SetParent(transform, false);
            points.Add(point);
        }     
    }

    private void Update() 
    {
        for (int i = 0; i < points.Count; i++) {
			Transform point = points[i];
			Vector3 position = point.localPosition;
			//position.y = position.x * position.x * position.x;
            var sin = Mathf.Sin(Mathf.PI * (position.x + Time.time));
            position.y = type == Type.Positive ? sin : -sin;
			point.localPosition = position;
		}
    }

    public enum Type
    {
        Positive,
        Negative
    }
}