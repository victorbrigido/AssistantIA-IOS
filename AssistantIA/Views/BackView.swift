//
//  BackView.swift
//  AssistantIA
//
//  Created by Victor Brigido on 25/02/24.
//

import SwiftUI
import AVKit

struct BackView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let player = AVPlayer(url: Bundle.main.url(forResource: "backvideo.mp4", withExtension: "mp4")!) // Substitua "your_video_file" pelo nome do seu vídeo
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.videoGravity = .resizeAspectFill
        playerController.showsPlaybackControls = false
        playerController.view.frame = UIScreen.main.bounds
        player.play()

        let viewController = UIViewController()
        viewController.addChild(playerController)
        viewController.view.addSubview(playerController.view)
        playerController.didMove(toParent: viewController)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct BackView_Previews: PreviewProvider {
    static var previews: some View {
        BackView()
    }
}

