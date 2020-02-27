//
//  ViewController.swift
//  GYHUD
//
//  Created by 高扬 on 01/21/2020.
//  Copyright (c) 2020 高扬. All rights reserved.
//

import UIKit
import GYHUD

class GYExample: NSObject {
    var title: String?
    var selector: Selector?
    
    init(title: String?, selector: Selector) {
        super.init()
        self.title = title
        self.selector = selector
    }
    
}

class ViewController: UITableViewController {
    
    private var examples: [[GYExample]] = []
    // Atomic, because it may be canceled from main thread, flag is read on a background thread
    private var canceled = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        examples = [
            [
                GYExample(title: "loading mode", selector: #selector(indeterminateExample)),
                GYExample(title: "Loading with type mode", selector: #selector(loadingWithTypeExample)),
                GYExample(title: "With label", selector: #selector(labelExample)),
                GYExample(title: "With details label", selector: #selector(detailsLabelExample))
            ],
            [
                GYExample(title: "Determinate mode", selector: #selector(determinateExample)),
                GYExample(title: "Annular determinate mode", selector: #selector(annularDeterminateExample)),
                GYExample(title: "Bar determinate mode", selector: #selector(barDeterminateExample))
            ],
            [
                GYExample(title: "Text only", selector: #selector(textExample)),
                GYExample(title: "Custom view", selector: #selector(customViewExample)),
                GYExample(title: "Success view", selector: #selector(successExample)),
                GYExample(title: "Error view", selector: #selector(errorExample)),
                GYExample(title: "With action button", selector: #selector(cancelationExample)),
                GYExample(title: "Mode switching", selector: #selector(modeSwitchingExample))
            ],
            [
                GYExample(title: "On window", selector: #selector(windowExample)),
                GYExample(title: "NSURLSession", selector: #selector(networkingExample)),
                GYExample(title: "Determinate with NSProgress", selector: #selector(determinateNSProgressExample)),
                GYExample(title: "Dim background", selector: #selector(dimBackgroundExample)),
                GYExample(title: "Colored", selector: #selector(colorExample))
            ]
        ]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Examples
extension ViewController {
    
    @objc func indeterminateExample() {
        // Show the HUD on the root view (self.view is a scrollable table view and thus not suitable,
        // as the HUD would move with the content as we scroll).
        GYHUD.show(.loading, onView: navigationController?.view)
        
        // Fire off an asynchronous task, giving UIKit the opportunity to redraw wit the HUD added to the
        // view hierarchy.
        DispatchQueue.global(qos: .default).async(execute: {
            
            // Do something useful in the background
            self.doSomeWork()
            
            // IMPORTANT - Dispatch back to the main thread. Always access UI
            // classes (including GYHUD) on the main thread.
            DispatchQueue.main.async(execute: {
                GYHUD.hide()
            })
        })
    }

    @objc func loadingWithTypeExample() {
        // Show the HUD on the root view (self.view is a scrollable table view and thus not suitable,
        // as the HUD would move with the content as we scroll).
        GYHUD.show(.loadingWith(type: .ballRotateChase), onView: navigationController?.view)
        
        // Fire off an asynchronous task, giving UIKit the opportunity to redraw wit the HUD added to the
        // view hierarchy.
        DispatchQueue.global(qos: .default).async(execute: {
            
            // Do something useful in the background
            self.doSomeWork()
            
            // IMPORTANT - Dispatch back to the main thread. Always access UI
            // classes (including GYHUD) on the main thread.
            DispatchQueue.main.async(execute: {
                GYHUD.hide()
            })
        })
    }

    @objc func labelExample() {
        // Set the label text.
        GYHUD.show(.loading, title: NSLocalizedString("Loading...", comment: "HUD loading title"), onView: navigationController?.view)
        
        // You can also adjust other label properties if needed.
        // hud.label.font = [UIFont italicSystemFontOfSize:16.f]
        
        DispatchQueue.global(qos: .default).async(execute: {
            self.doSomeWork()
            DispatchQueue.main.async(execute: {
                GYHUD.hide(animated: true)
            })
        })
    }
    
    @objc func detailsLabelExample() {
        // Set the label text.
        // Set the details label text. Let's make it multiline this time.
        GYHUD.show(.loading, title: NSLocalizedString("Loading...", comment: "HUD loading title"), subtitle: NSLocalizedString("Parsing data\n(1/1)", comment: "HUD title"), onView: navigationController?.view)
        
        DispatchQueue.global(qos: .default).async(execute: {
            self.doSomeWork()
            DispatchQueue.main.async(execute: {
                GYHUD.hide(animated: true)
            })
        })
    }
    
    @objc func windowExample() {
        // Covers the entire screen. Similar to using the root view controller view.
        GYHUD.show(.loading)
        
        DispatchQueue.global(qos: .default).async(execute: {
            self.doSomeWork()
            DispatchQueue.main.async(execute: {
                GYHUD.hide()
            })
        })
    }
    
    @objc func determinateExample() {
        GYHUD.show(title: NSLocalizedString("Loading...", comment: "HUD loading title"), onView: navigationController?.view)
        
        // Set the determinate mode to show task progress.
        GYHUD.shared?.mode = .determinate
        
        DispatchQueue.global(qos: .default).async(execute: {
            // Do something useful in the background and update the HUD periodically.
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async(execute: {
                GYHUD.shared?.hide(animated: true)
            })
        })
    }
    
    @objc func determinateNSProgressExample() {
        GYHUD.show(title: NSLocalizedString("Loading...", comment: "HUD loading title"), onView: navigationController?.view)
        
        // Set the determinate mode to show task progress.
        GYHUD.shared?.mode = .determinate
        
        // Set up NSProgress
        let progressObject = Progress(totalUnitCount: 100)
        GYHUD.shared?.progressObject = progressObject
        
        // Configure a cancel button.
        GYHUD.shared?.button.setTitle(NSLocalizedString("Cancel", comment: "HUD cancel button title"), for: .normal)
        GYHUD.shared?.button.addTarget(progressObject, action: #selector(cancelWork), for: .touchUpInside)
        
        DispatchQueue.global(qos: .default).async(execute: {
            // Do something useful in the background and update the HUD periodically.
            self.doSomeWork(with: progressObject)
            DispatchQueue.main.async(execute: {
                GYHUD.hide()
            })
        })
    }
    
    @objc func annularDeterminateExample() {
        GYHUD.show(title: NSLocalizedString("Loading...", comment: "HUD loading title"), onView: navigationController?.view)
        
        // Set the annular determinate mode to show task progress.
        GYHUD.shared?.mode = .annularDeterminate
        
        DispatchQueue.global(qos: .default).async(execute: {
            // Do something useful in the background and update the HUD periodically.
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async(execute: {
                GYHUD.shared?.hide(animated: true)
            })
        })
    }
    
    @objc func barDeterminateExample() {
        GYHUD.show(title: NSLocalizedString("Loading...", comment: "HUD loading title"), onView: navigationController?.view)
        
        // Set the bar determinate mode to show task progress.
        GYHUD.shared?.mode = .determinateHorizontalBar
        
        DispatchQueue.global(qos: .default).async(execute: {
            // Do something useful in the background and update the HUD periodically.
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async(execute: {
                GYHUD.shared?.hide(animated: true)
            })
        })
    }
    
    @objc func customViewExample() {
        // Optional label text.
        GYHUD.show(title: NSLocalizedString("Done", comment: "HUD done title"), onView: navigationController?.view)
        
        // Set the custom view mode to show any view.
        GYHUD.shared?.mode = .customView
        // Set an image view with a checkmark.
        let image = UIImage(named: "Checkmark")?.withRenderingMode(.alwaysTemplate)
        GYHUD.shared?.customView = UIImageView(image: image)
        // Looks a bit nicer if we make it square.
        GYHUD.shared?.isSquare = true
        
        GYHUD.hide(afterDelay: 3)
    }
    
    @objc func successExample() {
        // Optional label text.
        GYHUD.flash(.success, title: nil)
    }
    
    @objc func errorExample() {
        // Optional label text.
        GYHUD.flash(.error, title: nil)
    }
    
    @objc func textExample() {
        // Set the text mode to show only text.
        GYHUD.flash(.label, title: NSLocalizedString("Message here!", comment: "HUD message title"), onView: navigationController?.view, delay: 3)
        
        // Move to bottm center.
        GYHUD.shared?.offset = CGPoint(x: 0.0, y: 2000)
    }
    
    @objc func cancelationExample() {
        
        GYHUD.show(title: NSLocalizedString("Loading...", comment: "HUD loading title"), onView: navigationController?.view)
        
        // Set the determinate mode to show task progress.
        GYHUD.shared?.mode = .determinate
        
        // Configure the button.
        GYHUD.shared?.button.setTitle(NSLocalizedString("Cancel", comment: "HUD cancel button title"), for: .normal)
        GYHUD.shared?.button.addTarget(self, action: #selector(cancelWork), for: .touchUpInside)
        
        DispatchQueue.global(qos: .default).async(execute: {
            // Do something useful in the background and update the HUD periodically.
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async(execute: {
                GYHUD.shared?.hide(animated: true)
            })
        })
    }
    
    @objc func modeSwitchingExample() {
        // Set some text to show the initial status.
        GYHUD.show(title: NSLocalizedString("Preparing...", comment: "HUD preparing title"), onView: navigationController?.view)
        
        // Will look best, if we set a minimum size.
        GYHUD.shared?.minSize = CGSize(width: 150.0, height: 100.0)
        
        DispatchQueue.global(qos: .default).async(execute: {
            // Do something useful in the background and update the HUD periodically.
            self.doSomeWorkWithMixedProgress()
            DispatchQueue.main.async(execute: {
                GYHUD.hide()
            })
        })
    }
    
    @objc func networkingExample() {
        // Set some text to show the initial status.
        GYHUD.show(title: NSLocalizedString("Preparing...", comment: "HUD preparing title"), onView: navigationController?.view)
        
        // Will look best, if we set a minimum size.
        GYHUD.shared?.minSize = CGSize(width: 150.0, height: 100.0)
        
        self.doSomeNetworkWorkWithProgress()
    }
    
    @objc func dimBackgroundExample() {
        GYHUD.show(onView: navigationController?.view)
        
        // Change the background view style and color.
        GYHUD.dimsBackground = true
        
        DispatchQueue.global(qos: .default).async(execute: {
            self.doSomeWork()
            DispatchQueue.main.async(execute: {
                GYHUD.hide()
            })
        })
        
    }
    
    @objc func colorExample() {
        // Set the label text.
        GYHUD.show(title: NSLocalizedString("Loading...", comment: "HUD loading title"), onView: navigationController?.view)
        
        GYHUD.shared?.contentColor = UIColor(red: 0, green: 0.6, blue: 0.7, alpha: 1)
        
        DispatchQueue.global(qos: .default).async(execute: {
            self.doSomeWork()
            DispatchQueue.main.async(execute: {
                GYHUD.hide()
            })
        })
    }
    
}

extension ViewController {
    // MARK: - Tasks
    
    func doSomeWork() {
        // Simulate by just waiting.
        sleep(3)
    }
    
    func doSomeWork(with progressObject: Progress) {
        // This just increases the progress indicator in a loop.
        while (progressObject.fractionCompleted < 1.0) {
            if progressObject.isCancelled { break }
            progressObject.becomeCurrent(withPendingUnitCount: 1)
            progressObject.resignCurrent()
            usleep(50000);
        }
    }
    
    func doSomeWorkWithProgress() {
        self.canceled = false
        // This just increases the progress indicator in a loop.
        var progress: Float = 0.0
        while (progress < 1.0) {
            if self.canceled {
                break
            }
            progress += 0.01
            DispatchQueue.main.async {
                // Instead we could have also passed a reference to the HUD
                // to the HUD to myProgressTask as a method parameter.
                GYHUD.shared?.progress = progress
            }
            usleep(50000);
        }
    }
    
    func doSomeWorkWithMixedProgress() {
        // Indeterminate mode
        sleep(2)
        // Switch to determinate mode
        DispatchQueue.main.async {
            GYHUD.shared?.mode = .determinate
            GYHUD.shared?.label.text = NSLocalizedString("Loading...", comment: "HUD loading title")
        }
        var progress: Float = 0.0
        while (progress < 1.0) {
            progress += 0.01
            DispatchQueue.main.async {
                GYHUD.shared?.progress = progress
            }
            usleep(50000)
        }
        // Back to indeterminate mode
        DispatchQueue.main.async {
            GYHUD.shared?.mode = .indeterminate
            GYHUD.shared?.label.text = NSLocalizedString("Cleaning up...", comment: "HUD cleanining up title")
        }
        sleep(2)
        DispatchQueue.main.async {
            let image = UIImage(named: "Checkmark")?.withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: image)
            GYHUD.shared?.customView = imageView
            GYHUD.shared?.mode = .customView
            GYHUD.shared?.label.text = NSLocalizedString("Completed", comment: "HUD completed title")
        }
        sleep(2)
    }
    
    func doSomeNetworkWorkWithProgress() {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        if let url = URL(string: "https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip") {
            let task = session.downloadTask(with: url)
            task.resume()
        } else {
            GYHUD.flash(.loading, title: NSLocalizedString("Download Error", comment: "HUD download error title"), delay: 1)
        }
    }
    
    @objc func cancelWork() {
        self.canceled = true
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.examples.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.examples[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let example = self.examples[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GYExampleCell", for: indexPath)
        cell.textLabel?.text = example.title
        cell.textLabel?.textColor = self.view.tintColor
        cell.textLabel?.textAlignment = .center
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = cell.textLabel?.textColor.withAlphaComponent(0.1)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = self.examples[indexPath.section][indexPath.row]
        // #pragma clang diagnostic push
        // #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        self.perform(example.selector)
        // #pragma clang diagnostic pop
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}


// MARK: - NSURLSessionDelegate
extension ViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Do something with the data at location...
        
        // Update the UI on the main thread
        DispatchQueue.main.async(execute: { [weak self] in
            GYHUD.flash(.success, title: NSLocalizedString("Completed", comment: "HUD completed title"), onView: self?.navigationController?.view, delay: 3)
        })
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        // Update the UI on the main thread
        DispatchQueue.main.async(execute: {
            if !GYHUD.isVisible {
                GYHUD.show()
            }
            GYHUD.shared?.mode = .determinate
            GYHUD.shared?.progress = progress
        })
    }
    
}
