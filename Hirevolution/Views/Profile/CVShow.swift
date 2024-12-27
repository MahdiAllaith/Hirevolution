import UIKit
import WebKit

class CVShow: UIViewController {

    var webView: WKWebView!
    var cv: CVForm.CV?

    // A custom initializer to pass the CV object
    init(cv: CVForm.CV?) {
        self.cv = cv
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

    	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize WKWebView with configuration
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        
        // Add webView to the view hierarchy
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)

        // Center webView on screen and set its size
        NSLayoutConstraint.activate([
            webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            webView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            webView.widthAnchor.constraint(equalToConstant: 300),
            webView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        // Load HTML content
        loadHTMLContent()
    }

    // Function to generate the HTML content and load it into the WKWebView
    func loadHTMLContent() {
        guard let filePath = Bundle.main.path(forResource: "cvtemplate", ofType: "html") else {
            print("HTML template file not found.")
            return
        }
        
        do {
            var htmlContent = try String(contentsOfFile: filePath, encoding: .utf8)

            // Use CV data passed to this view controller
            if let cv = cv {
                htmlContent = htmlContent.replacingOccurrences(of: "[firstname]", with: cv.firstname)
                htmlContent = htmlContent.replacingOccurrences(of: "[lastname]", with: cv.lastname)
                htmlContent = htmlContent.replacingOccurrences(of: "[email]", with: cv.email)
                htmlContent = htmlContent.replacingOccurrences(of: "[phone]", with: cv.phone)
                htmlContent = htmlContent.replacingOccurrences(of: "[website]", with: cv.website)
                htmlContent = htmlContent.replacingOccurrences(of: "[currentjob]", with: cv.currentjob)
                htmlContent = htmlContent.replacingOccurrences(of: "[brief]", with: cv.brief)

                // Add Experience
                var experienceHTML = ""
                for experience in cv.experiences {
                    experienceHTML += """
                    <div class="experience-item">
                        <h3>\(experience.companyname)</h3>
                        <p class="dates">\(experience.startdate) - \(experience.enddate)</p>
                        <p class="content">\(experience.jobbrief)</p>
                    </div>
                    """
                }
                htmlContent = htmlContent.replacingOccurrences(of: "[experience]", with: experienceHTML)
                
                // Add Skills
                var skillsHTML = ""
                for skill in cv.skills {
                    skillsHTML += """
                    <div class="skill-item">
                        <h3>\(skill.name)</h3>
                        <p class="content">\(skill.description)</p>
                    </div>
                    """
                }
                htmlContent = htmlContent.replacingOccurrences(of: "[skills]", with: skillsHTML)
            }
            
            // Load the modified HTML into the WKWebView
            webView.loadHTMLString(htmlContent, baseURL: nil)
            
        } catch {
            print("Error loading HTML file: \(error)")
        }
    }

    // Action triggered when the download button is pressed
    @IBAction func download(_ sender: Any) {
        let alertController = UIAlertController(title: "Download CV", message: "Choose the file format", preferredStyle: .actionSheet)
        
        let htmlAction = UIAlertAction(title: "Download as HTML", style: .default) { _ in
            self.downloadHTML()
        }
        
        let pdfAction = UIAlertAction(title: "Download as PDF", style: .default) { _ in
            self.downloadPDF()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(htmlAction)
        alertController.addAction(pdfAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    // Function to download the CV as an HTML file
    func downloadHTML() {
        guard let filePath = Bundle.main.path(forResource: "cvtemplate", ofType: "html") else {
            print("HTML template file not found.")
            return
        }
        
        do {
            var htmlContent = try String(contentsOfFile: filePath, encoding: .utf8)

            // Use CV data passed to this view controller
            if let cv = cv {
                htmlContent = htmlContent.replacingOccurrences(of: "[firstname]", with: cv.firstname)
                htmlContent = htmlContent.replacingOccurrences(of: "[lastname]", with: cv.lastname)
                htmlContent = htmlContent.replacingOccurrences(of: "[email]", with: cv.email)
                htmlContent = htmlContent.replacingOccurrences(of: "[phone]", with: cv.phone)
                htmlContent = htmlContent.replacingOccurrences(of: "[website]", with: cv.website)
                htmlContent = htmlContent.replacingOccurrences(of: "[currentjob]", with: cv.currentjob)
                htmlContent = htmlContent.replacingOccurrences(of: "[brief]", with: cv.brief)

                // Add Experience
                var experienceHTML = ""
                for experience in cv.experiences {
                    experienceHTML += """
                    <div class="experience-item">
                        <h3>\(experience.companyname)</h3>
                        <p class="dates">\(experience.startdate) - \(experience.enddate)</p>
                        <p class="content">\(experience.jobbrief)</p>
                    </div>
                    """
                }
                htmlContent = htmlContent.replacingOccurrences(of: "[experience]", with: experienceHTML)
                
                // Add Skills
                var skillsHTML = ""
                for skill in cv.skills {
                    skillsHTML += """
                    <div class="skill-item">
                        <h3>\(skill.name)</h3>
                        <p class="content">\(skill.description)</p>
                    </div>
                    """
                }
                htmlContent = htmlContent.replacingOccurrences(of: "[skills]", with: skillsHTML)
            }

            // Save the HTML content to a file
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("CVDownload.html")
            
            try htmlContent.write(to: fileURL, atomically: true, encoding: .utf8)
            
            // Share sheet to let user download the file
            let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            
        } catch {
            print("Error generating HTML file: \(error)")
        }
    }


    // Function to download the CV as a PDF
    func downloadPDF() {
        // Wait until the webView finishes rendering the content before creating the PDF
        webView.createPDF { [weak self] result in
            switch result {
            case .success(let pdfData):
                // Save the PDF data to a file
                let fileManager = FileManager.default
                let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent("CVDownload.pdf")
                
                do {
                    try pdfData.write(to: fileURL)  // Write the generated PDF to the file
                    // Present the share sheet for downloading the PDF
                    let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                    self?.present(activityController, animated: true, completion: nil)
                    
                } catch {
                    print("Error saving PDF: \(error)")
                }
                
            case .failure(let error):
                print("Error creating PDF: \(error)")
            }
        }
    }

}
