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
	
	var audioSession: AVAudioSession?
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
		
		//Setup the AVAudioSession
		configureAudioSession()
		
		//Setup the audioPlayer to be used upon button click
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
		} catch {
			print("couldn't play audio")
		}
	}
	
	func configureAudioSession() {
		audioSession = AVAudioSession.sharedInstance()
		
		do {
			// Set the audio session category and mode to make earpiece as the default audio source
			try audioSession?.setCategory(.playAndRecord, mode: .voiceChat)
			checkConnectedDevices()
		} catch {
			print("Failed to set the audio session configuration")
		}
	}
	
	func checkConnectedDevices() {
		if let currentRoute = audioSession?.currentRoute {
			for output in currentRoute.outputs {
				let portName = output.portName
				let portType = output.portType
				
				print("Output Port Name: \(portName)")
				print("Output Port Type: \(portType)")
			}
		}
		
	}

	@IBAction func playButtonTapped(_ sender: UIButton) {

		if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
			audioPlayer.pause()
			try? audioSession?.setActive(false)
			playPauseButton.setTitle("Play", for: .normal)
			
		} else {
			try? audioSession?.setActive(true)
			audioPlayer?.play()
			playPauseButton.setTitle("Pause", for: .normal)
		}
	}
	
}

