//
//  WorldMapView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-04-10.
//

// WorldMapView.swift
import SwiftUI
import MapKit
import CoreData
import UIKit

private struct FaerunMapView: UIViewRepresentable {
    var pins: [PinEntity]
    var zoomLevel: Double
    var center: CLLocationCoordinate2D?
    var onTap: (CLLocationCoordinate2D) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.backgroundColor = .black
        mapView.mapType = .mutedStandard

        let mapLimit = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
        )
        let overlay = MapManager(urlTemplate: nil)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveLabels)

        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: mapLimit),
            animated: false
        )

        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        mapView.addGestureRecognizer(tap)

        return mapView
    }

    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if mapView.camera.altitude != zoomLevel {
            let resolvedCenter = center ?? mapView.camera.centerCoordinate
            let camera = MKMapCamera(
                lookingAtCenter: resolvedCenter,
                fromDistance: zoomLevel,
                pitch: 0,
                heading: 0
            )
            mapView.setCamera(camera, animated: true)
        }

        let currentPins = mapView.annotations.compactMap { $0 as? MKPointAnnotation }
        if currentPins.count != pins.count {
            mapView.removeAnnotations(mapView.annotations)
            for pin in pins {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                mapView.addAnnotation(annotation)
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: FaerunMapView

        init(_ parent: FaerunMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tile = overlay as? MKTileOverlay {
                return MKTileOverlayRenderer(tileOverlay: tile)
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { return nil }
            let id = "QuestPin"
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: id)
                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
            let image = UIImage(systemName: "exclamationmark.bubble.fill", withConfiguration: config)?
                .withRenderingMode(.alwaysOriginal)
            view.image = image?.withTintColor(.systemYellow)
            view.centerOffset = CGPoint(x: 0, y: -18)
            return view
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            parent.onTap(coordinate)
        }
    }
}


struct WorldMapView: View {
    @Environment(\.managedObjectContext) private var context
    let campaign: Campaign
    @State private var pins: [PinEntity] = []
    @State private var zoomLevel: Double = 50000000
    @State private var currentCenter: CLLocationCoordinate2D? = nil

    var body: some View {
        ZStack {
            FaerunMapView(
                pins: pins,
                zoomLevel: zoomLevel,
                center: currentCenter
            ) { _ in  }
            .ignoresSafeArea()

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Button(action: zoomIn) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }

                        Button(action: zoomOut) {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear { loadPins() }
    }

    private func loadPins() {
        let request: NSFetchRequest<PinEntity> = PinEntity.fetchRequest()
        request.predicate = NSPredicate(format: "campaign == %@", campaign)
        pins = (try? context.fetch(request)) ?? []
    }

    private func zoomIn() {
        zoomLevel = max(zoomLevel * 0.5, 500000)
    }

    private func zoomOut() {
        zoomLevel = min(zoomLevel * 2.0, 50000000)
    }
}

//#Preview {
//    WorldMapView()
//}
