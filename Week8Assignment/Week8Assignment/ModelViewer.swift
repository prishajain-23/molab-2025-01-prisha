//
//  Model3DView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/28/25.
//

import SwiftUI
import RealityKit

struct ModelViewer: UIViewRepresentable {
    let modelName: String
    @Binding var resetRequested: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: .zero)
        
        setupCameraAndLighting(for: view)
        
        Task {
            await loadModel(named: modelName, into: view, context: context)
        }
        
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        view.addGestureRecognizer(pinchGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if resetRequested {
            context.coordinator.resetModel()
            DispatchQueue.main.async {
                self.resetRequested = false
            }
        }
    }
    
    private func setupCameraAndLighting(for view: ARView) {
        let cameraPos = SIMD3<Float>(0, 20, 0) // Top-down camera height
        let cameraAnchor = AnchorEntity(world: cameraPos)
        cameraAnchor.look(at: .zero, from: cameraPos, relativeTo: nil)
        
        let camera = PerspectiveCamera()
        cameraAnchor.addChild(camera)
        
        let light = DirectionalLight()
        light.light.intensity = 25000
        light.look(at: .zero, from: SIMD3<Float>(0, 3, 0), relativeTo: nil)
        cameraAnchor.addChild(light)
        
        view.scene.anchors.append(cameraAnchor)
    }
    
    private func loadModel(named name: String, into view: ARView, context: Context) async {
        do {
            let model = try await ModelEntity(named: name, in: .main)
            model.generateCollisionShapes(recursive: true)
            
            // Fit-to-frame for top-down view: scale based on horizontal size (X or Z)
            let bounds = model.visualBounds(relativeTo: nil)
            let maxHorizontalDimension = max(bounds.extents.x, bounds.extents.z)
            let targetHorizontalSize: Float = 0.6 // meters across, adjust for screen size

            let initialScale = targetHorizontalSize / maxHorizontalDimension
            model.scale = SIMD3<Float>(repeating: initialScale)
            context.coordinator.currentScale = initialScale

            // Flip 180 on Z-axis if needed
            let flipZ = simd_quatf(angle: .pi, axis: [0, 0, 1])
            model.transform.rotation = flipZ

            // Center the model
            let centerOffset = bounds.center * initialScale
            model.position = -centerOffset
            
            // 🔩 Add to anchor + scene
            let anchor = AnchorEntity()
            anchor.addChild(model)
            view.scene.anchors.append(anchor)
            
            context.coordinator.model = model
        } catch {
            print("❌ Failed to load model: \(error)")
        }
    }
    
    
    // MARK: - Gesture Coordinator
    class Coordinator: NSObject {
        var model: ModelEntity?
        var lastRotation = SIMD3<Float>(0, 0, 0)
        var currentScale: Float = 1.0
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let model = model else { return }
            
            let translation = gesture.translation(in: gesture.view)
            let width = gesture.view?.bounds.width ?? 1
            let height = gesture.view?.bounds.height ?? 1
            
            let deltaX = Float(translation.x / width) * .pi
            let deltaY = Float(translation.y / height) * .pi
            
            let newRotation = SIMD3<Float>(
                lastRotation.x + deltaY,
                lastRotation.y + deltaX,
                lastRotation.z
            )
            
            model.transform.rotation = simd_quatf(angle: newRotation.x, axis: [1, 0, 0]) *
            simd_quatf(angle: newRotation.y, axis: [0, 1, 0]) *
            simd_quatf(angle: newRotation.z, axis: [0, 0, 1])
            
            if gesture.state == .ended {
                lastRotation = newRotation
            }
        }
        
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let model = model else { return }
            
            if gesture.state == .changed || gesture.state == .ended {
                let scaleChange = Float(gesture.scale)
                let newScale = currentScale * scaleChange
                
                // Clamp scale between reasonable min/max
                let clamped = max(0.1, min(newScale, 5.0))
                model.scale = SIMD3<Float>(repeating: clamped)
                
                if gesture.state == .ended {
                    currentScale = clamped
                }
            }
        }
        func resetModel() {
            guard let model = model else { return }

            // Reset rotation
            lastRotation = SIMD3<Float>(0, 0, 0)
            model.transform.rotation = simd_quatf(angle: .pi, axis: [0, 0, 1]) // reapply z-axis flip

            // Reset scale
            model.scale = SIMD3<Float>(repeating: currentScale)

            // Reset position
            let bounds = model.visualBounds(relativeTo: nil)
            let centerOffset = bounds.center * currentScale
            model.position = -centerOffset
        }
    }
}
