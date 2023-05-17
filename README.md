# -ObjectDetectApp
![Frame 51](https://github.com/importantsgit/ObjectDetectApp/assets/118325810/c033836e-2890-4737-9f63-6b490f7ed25a)

YoloV8과 CoreML을 이용한 객체 탐지 앱입니다.

1. Yolov8을 활용한 강아지 종 분류(object Detection) / 헹동(Classification) 모델 제작

   a. roboflow를 활용하여 데이터셋 제작
      - Object Detection
        골든 리트리버, 비글, 치와와 등 9가지 종의 이미지 (5000장)를 활용하여 데이터셋 제작
      - classification
        sit, stand, lie 이미지를 황용하여 데이터셋 제작
        (문제점: 2차원 이미지 분석이기 때문에 3차원인 개의 행동을 정확하게 분석 못함)

   b. colab을 이용하여 모델 제작 (640 * 640)
      - 모델 제작, 탐지 시 gpu를 활용해야 함

   c. yolov8 object detection, classification 모델 -> mlmodel 변환 (export시 nms 적용시켜야 함)

2. OpenCV를 활용한 motion Detection 제작
   - mm 파일로 변환 후 사용해야 함 (C++ 활용)
   - 겹치는 영역을 하나로 합치지 위해 groupRectangles 사용 (detect된 rect들을 한번 복사한 후 사용해야 함 - 주의)
   
   
- 시안
https://youtu.be/7UCXDW3cC_w

