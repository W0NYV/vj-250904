using Unity.Cinemachine;
using Unity.Mathematics;
using UnityEngine;

namespace W0NYV.vj250904
{
    public class DollyCamera : MonoBehaviour
    {
        [SerializeField] private CinemachineSplineDolly _cinemachineSplineDolly;
        [SerializeField] private float _speed;
        
        private void Update()
        {
            _cinemachineSplineDolly.CameraPosition = math.frac(Time.time * _speed);
        }
    }
}