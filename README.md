# ObjectDetectApp
![Frame 51](https://github.com/importantsgit/ObjectDetectApp/assets/118325810/c033836e-2890-4737-9f63-6b490f7ed25a)

![](https://youtu.be/7UCXDW3cC_w?si=nZt4Xhs2RqmcvdE0)

YoloV8과 CoreML을 이용한 객체 탐지 앱입니다.

## 사용 기술 및 라이브러리

- Swift, iOS
- Yolov5, Yolov8, CoreML, Vision, MLModel, openCV
- NSLayerConstraint, snapKit

## 프로젝트 목적

반려동물 감시 카메라 앱 개발 프로젝트를 통해 제작한

커스텀 Vision 모델(Yolo v8, ML Model)을 앱에 적용해보고자 개발했습니다.

## 사용한 Vision Model

- Object Detection
    - 이미지나 비디오에서 관심 있는 객체를 감지하고 찾는 모델 (위치 / 분류-라벨링)
- Classification
    - 주어진 입력 데이터의 올바른 레이블을 예측하려는 모델 (분류-라벨링)

## 프로젝트 특징

- 직접 커스터마이징한 Yolo v8 모델과 MLModel을 앱에 적용하여 동작시켰습니다.
- OpenCV를 활용하여 객체의 움직임을 판단하는 로직을 추가했습니다
- 이를 통해 반려동물 감시 카메라 앱에서 반려동물이 움직이고 있는지, 어떤 행동을 하고 있는지 실시간으로 감지하고 분석할 수 있도록 하였습니다

## 프로젝트 경험

회사에서 사내 프로젝트에 참여하면서 Vision AI 모델 제작 업무를 맡았습니다.

당시 Vision AI에 대해 잘 몰랐지만, 맡은 일에 최선을 다하자는 생각으로 열심히 공부했습니다.

먼저, 개체를 구분할 수 있는 Object Detection과 행동을 구분할 수 있는 Classification에 대해 조사했습니다.

그 다음, 반려동물 이미지 4000장을 사용해 데이터셋을 만들고, 모델 선정을 거쳐 Yolo v8과 MLModel을 커스터마이징하여 생성했습니다.

또한, OpenCV 라이브러리를 활용해 화면 상 움직이는 영역의 크기만큼 자르는 로직을 설계했습니다.

비록 프로젝트는 실패로 끝났지만, 이 경험을 통해 배우지 않은 영역이라도 맡은 일에 관심을 가지고 최선을 다하는 마인드를 가지게 되었습니다.
