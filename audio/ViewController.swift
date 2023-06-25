//
//  ViewController.swift
//  audio
//
//  Created by AKSHAY MAHAJAN on 2023-06-25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	
	var audioPlayer: AVAudioPlayer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func playButtonTapped(_ sender: UIButton) {
		print("button clicked!")
		//Check if the audio exists
		guard let audioPath = Bundle.main.url(forResource: "sampleAudio", withExtension: "mp3") else {
			print("Failed to find the audio file")
			return
		}
		//Audio has been found
		print("Audio found!")
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
			audioPlayer?.play()
		} catch {
			print("couldn't play audio")
		}
	}
	
}

