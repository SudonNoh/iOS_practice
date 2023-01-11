//
//  MapAlertViewController.swift
//  Chapter03-Alert
//
//  Created by Sudon Noh on 2023/01/11.
//

import UIKit
import MapKit

class MapKitAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapkitView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view = mapkitView
        self.preferredContentSize.height = 200
        
        // 위치 정보를 설정, 위/경도
        let pos = CLLocationCoordinate2D(latitude: 37.514322, longitude: 126.894623)
        
        // 지도에서 보여줄 넓이, 일종의 축척. 숫자가 작을수록 좁은 범위를 자세히 확대시켜 보여준다.
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        // 지도 영역을 정의
        let region = MKCoordinateRegion(center: pos, span: span)
        
        // 지도 뷰에 표시
        mapkitView.region = region
        mapkitView.regionThatFits(region)
        
        // 위치를 핀으로 표시
        let point = MKPointAnnotation()
        point.coordinate = pos
        mapkitView.addAnnotation(point)
    }
}
