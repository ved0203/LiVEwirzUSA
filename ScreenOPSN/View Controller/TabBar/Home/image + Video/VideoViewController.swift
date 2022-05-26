//
//  VideoViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    
    var timer = Timer()
    var count : Int = 23
    
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // var activeInput: AVCaptureDeviceInput!
    var outputURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if setupSession() {
            setupPreview()
        }
        
        lblTimer.text = String(format: "00:%02d", count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
        self.stopSession()
        self.videoButton.setImage(#imageLiteral(resourceName: "videoplay"), for: .normal)
        count = 23
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let screenSize:CGRect = UIScreen.main.bounds
        
        previewLayer.frame =  CGRect(x: 0, y: 0, width: screenSize.size.width, height: screenSize.size.height)
        //previewLayer.frame = camPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
    }
    
    @IBAction func recordandstopVideo(_ sender: UIButton) {
        
        if sender.isSelected == false {
            self.videoButton.isSelected = true
            self.videoButton.setImage(#imageLiteral(resourceName: "videostop"), for: .normal)
        } else {
            self.videoButton.isSelected = false
            self.videoButton.setImage(#imageLiteral(resourceName: "videoplay"), for: .normal)
        }
        startRecording()
    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Setup Camera
    
    func setupSession() -> Bool {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
        
        // Setup Camera
        let camera = AVCaptureDevice.default(for: AVMediaType.video)!
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                //activeInput = input
            }
        } catch {
            return false
        }
        
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
        
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            return false
        }
        
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        captureSession.startRunning()

        captureSession.commitConfiguration()
        
        return true
    }
    
    //MARK:- Camera Session
    func startSession() {
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.portrait
        }
        
        return orientation
    }
    
    //EDIT 1: I FORGOT THIS AT FIRST
    
    func tempURL() -> URL? {
        let fileName = NSUUID().uuidString
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(".mov")
        return URL(fileURLWithPath: fileURL.path)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! VideoPlaybackViewController
        vc.videoURL = sender as? URL
    }
    
    func startRecording() {
        
        if movieOutput.isRecording == false {
            let connection = movieOutput.connection(with: AVMediaType.video)
            
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
                        
            //EDIT2: And I forgot this
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
            lblTimer.text = String(format: "00:%02d", count)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
        } else {
            movieOutput.stopRecording()
        }
    }
    
    @objc func updateCounting(){
        
        count = count - 1
        lblTimer.text = String(format: "00:%02d", count)
        
       if count == 0 {
            self.count = 23
            self.timer.invalidate()
            DispatchQueue.main.async {
              // your code here
                self.lblTimer.text = String(format: "00:%02d", self.count)
                self.recordandstopVideo(self.videoButton!)
            }
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if (error == nil) {
            // Runs after 1 second on the main queue.
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) ) {
                self.navigate(outputFileURL)
            }
        }
    }

    func navigate(_ url : URL)  {
        performSegue(withIdentifier: "showVideo", sender: url)
    }
}
