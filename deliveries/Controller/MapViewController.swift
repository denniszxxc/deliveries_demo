//
//  MapViewController.swift
//  deliveries
//
//  Created by Dennis Li on 28/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {
    weak var navigation: DeliveryNavigation?

    var viewModel =  MapViewModel()
    var disposeBag = DisposeBag()

    weak var mapView: MKMapView?

    override func loadView() {
        self.view = UIView()

        let blurEffect = UIBlurEffect(style: .regular)
        let statusBarMaskView = UIVisualEffectView(effect: blurEffect)
        statusBarMaskView.translatesAutoresizingMaskIntoConstraints = false

        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(mapView)
        self.view.addSubview(statusBarMaskView)

        self.view.addConstraints([
            statusBarMaskView.topAnchor.constraint(equalTo: self.view.topAnchor),
            statusBarMaskView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            statusBarMaskView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            statusBarMaskView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
        self.mapView = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView?.delegate = self
        self.mapView?.register(DeliveryAnnotationView.self,
                               forAnnotationViewWithReuseIdentifier: DeliveryAnnotationView.ReuseID)

        viewModel.annotationObservable?
            .subscribe(onNext: { [weak self] (annotations) in
                if let lastAnnotationList = self?.mapView?.annotations {
                    self?.mapView?.removeAnnotations(lastAnnotationList)
                }

                self?.mapView?.addAnnotations(annotations)
            })
            .disposed(by: disposeBag)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapViewModel.DeliveryAnnotation else { return nil }
        return DeliveryAnnotationView(annotation: annotation, reuseIdentifier: DeliveryAnnotationView.ReuseID)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let clusterAnnotation = view.annotation as? MKClusterAnnotation {
            let deliveryIdList = clusterAnnotation.memberAnnotations.compactMap { (annotation) -> Int? in
                if let deliveryAnnotation = annotation as? MapViewModel.DeliveryAnnotation {
                    return deliveryAnnotation.id
                }
                return nil
            }
            // TODO: Show selected Delivery List
            print("deliveryIdList \(deliveryIdList) ")
        } else if let deliveryAnnotation = view.annotation as? MapViewModel.DeliveryAnnotation {
            navigation?.showDeliveryDetail(deliveryId: deliveryAnnotation.id)
        }

    }
}
