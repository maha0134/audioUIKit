//
//  ViewController.swift
//  audio
//
//  Created by AKSHAY MAHAJAN on 2023-06-25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	
	@IBOutlet weak var playPauseButton: UIButton!
	var audioPlayer: AVAudioPlayer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Check if the audio exists
		guard let audioPath = Bundle.main.url(forResource: "sampleAudio", withExtension: "mp3") else {
			print("Failed to find the audio file")
			return
		}
		//Audio has been found
		print("Audio found!")
		
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
		} catch {
			print("couldn't play audio")
		}
	}

	@IBAction func playButtonTapped(_ sender: UIButton) {

		if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
			audioPlayer.pause()
			playPauseButton.setTitle("Play", for: .normal)
		} else {
			audioPlayer?.play()
			playPauseButton.setTitle("Pause", for: .normal)
		}
	}
	
}

