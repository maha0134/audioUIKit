//
//  ViewController.swift
//  audio
//
//  Created by AKSHAY MAHAJAN on 2023-06-25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var earpieceIcon: UIButton!
	@IBOutlet weak var speakerIcon: UIButton!
	
	@IBOutlet var tableView: UITableView!
	
	var audioSession: AVAudioSession?
	var audioPlayer: AVAudioPlayer?
	var devices = [AVAudioSessionPortDescription]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Check if the audio exists
		guard let audioPath = Bundle.main.url(forResource: "sampleAudio", withExtension: "mp3") else {
			print("Failed to find the audio file")
			return
		}
		
		//Audio has been found
		print("Audio found!")
		speakerIcon.setTitle("", for: .normal)
		earpieceIcon.setTitle("", for: .normal)
		
		//Setup the AVAudioSession
		configureAudioSession()
		
		//Setup the audioPlayer to be used upon button click
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
		} catch {
			print("couldn't play audio")
		}
		
		//Setup the connected devices in a tableView
		
		tableView.dataSource = self
		tableView.delegate = self
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
			self.devices = currentRoute.outputs
			self.devices.removeAll { $0.portName == "Speaker" }
			//TODO: Comment these out
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
	
	@IBAction func earpieceTapped(_ sender: UIButton) {
		do {
			try audioSession?.setCategory(.playAndRecord, mode: .voiceChat)
			earpieceIcon.setImage(UIImage(systemName: "phone.fill"), for: .normal)
			speakerIcon.setImage(UIImage(systemName: "speaker"), for: .normal)
		} catch {
			print("Earpiece mode could not be selected")
		}
	}
	
	@IBAction func speakerTapped(_ sender: UIButton) {
		do {
			try audioSession?.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
			earpieceIcon.setImage(UIImage(systemName: "phone"), for: .normal)
			speakerIcon.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
		} catch {
			print("Speaker mode could not be selected")
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return devices.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Device", for: indexPath)
		cell.textLabel?.text = devices[indexPath.row].portName
		return cell
	}
}

