//
//  PinPlacementMapView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-04-11.
//

import SwiftUI
import MapKit
import CoreData

struct PinPlacementMapView: View {
    let quest: Quest

    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss

    @State private var pendingCoordinate: CLLocationCoordinate2D? = nil
    @State private var zoomLevel: Double = 10_000_000
    @State private var currentCenter = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var existingPins: [PinEntity] = []
    @State private var showConfirm = false

    var body: some View {
        ZStack {
            PinPlacementMapUIView(
                existingPins: existingPins,
                pendingCoordinate: pendingCoordinate,
                zoomLevel: zoomLevel,
                center: currentCenter,
                onTap: { coordinate in
                    pendingCoordinate = coordinate
                    showConfirm = true
                }
            )
            .ignoresSafeArea()

            // Zoom controls
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Button { zoomLevel = max(zoomLevel * 0.5, 500_000) } label: {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title2).foregroundStyle(.white)
                                .padding().background(.ultraThinMaterial).clipShape(Circle())
                        }
                        Button { zoomLevel = min(zoomLevel * 2.0, 50_000_000) } label: {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.title2).foregroundStyle(.white)
                                .padding().background(.ultraThinMaterial).clipShape(Circle())
                        }
                    }
                    .padding()
                }
            }

            // Instruction banner
            VStack {
                Text("Tap the map to place a quest marker")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.top, 12)
                Spacer()
            }
        }
        .navigationTitle("Place Pin")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadPins() }
        .confirmationDialog(
            "Place quest marker here?",
            isPresented: $showConfirm,
            titleVisibility: .visible
        ) {
            Button("Place Marker") {
                if let coord = pendingCoordinate {
                    _ = holder.createPin(
                        x: coord.latitude,
                        y: coord.longitude,
                        quest: quest,
                        isCharacter: false,
                        context
                    )
                    loadPins()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {
                pendingCoordinate = nil
            }
        }
    }

    private func loadPins() {
        let request: NSFetchRequest<PinEntity> = PinEntity.fetchRequest()
        request.predicate = NSPredicate(format: "quest == %@", quest)
        existingPins = (try? context.fetch(request)) ?? []
    }
}

// MARK: - UIViewRepresentable for placement

private struct PinPlacementMapUIView: UIViewRepresentable {
    var existingPins: [PinEntity]
    var pendingCoordinate: CLLocationCoordinate2D?
    var zoomLevel: Double
    var center: CLLocationCoordinate2D
    var onTap: (CLLocationCoordinate2D) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.backgroundColor = .black
        mapView.mapType = .mutedStandard
        mapView.register(QuestMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: "QuestPin")

        let overlay = MapManager(urlTemplate: nil)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveLabels)

        let tap = UITapGestureRecognizer(target: context.coordinator,
                                         action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tap)

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        if mapView.camera.altitude != zoomLevel {
            let camera = MKMapCamera(lookingAtCenter: mapView.camera.centerCoordinate,
                                     fromDistance: zoomLevel, pitch: 0, heading: 0)
            mapView.setCamera(camera, animated: true)
        }

        mapView.removeAnnotations(mapView.annotations)

        for pin in existingPins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            mapView.addAnnotation(annotation)
        }

        if let pending = pendingCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pending
            mapView.addAnnotation(annotation)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: PinPlacementMapUIView
        init(_ parent: PinPlacementMapUIView) { self.parent = parent }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tile = overlay as? MKTileOverlay {
                return MKTileOverlayRenderer(tileOverlay: tile)
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView,
                     viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let qa = annotation as? QuestAnnotation else { return nil }
            let view = mapView.dequeueReusableAnnotationView(
                withIdentifier: "QuestPin", for: annotation) as! QuestMarkerAnnotationView
            view.configure(isPending: qa.isPending)
            return view
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            // Don't fire if tapping an existing annotation
            let point = gesture.location(in: mapView)
            for annotation in mapView.annotations {
                if let view = mapView.view(for: annotation) {
                    if view.frame.contains(point) { return }
                }
            }
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            parent.onTap(coordinate)
        }
    }
}

// MARK: - Custom annotation model

class QuestAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let isPending: Bool
    init(coordinate: CLLocationCoordinate2D, isPending: Bool) {
        self.coordinate = coordinate
        self.isPending = isPending
    }
}

// MARK: - Custom annotation view (SF Symbol rendered via UIImageView)

class QuestMarkerAnnotationView: MKAnnotationView {
    private let imageView = UIImageView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        centerOffset = CGPoint(x: 0, y: -18)
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(isPending: Bool) {
        let symbolName = "exclamationmark.bubble.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
        imageView.image = UIImage(systemName: symbolName, withConfiguration: config)
        imageView.tintColor = isPending ? .systemOrange : .systemYellow
        // Scale pulse for pending
        if isPending {
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.0; pulse.toValue = 1.2
            pulse.duration = 0.6; pulse.autoreverses = true
            pulse.repeatCount = .infinity
            layer.add(pulse, forKey: "pulse")
        } else {
            layer.removeAnimation(forKey: "pulse")
        }
    }
}
