//
//  DetailViewController.swift
//  movies_app
//
//  Created by Uno qualunque on 03/10/21.
//

import UIKit

class DetailViewController: UIViewController {

    var movieObject: Movie?
    
    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieOverview: UITextView!
    @IBOutlet var movieOriginalLanguage: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let url = URL(string: "https://image.tmdb.org/t/p/original\(movieObject!.backdrop_path)") {
//            if let imageData = try? Data(contentsOf: url) {
//                
//                movieImage.image = UIImage(data: imageData)
//            } else {
//                print("Not valid data")
//            }
//        } else {
//            print("Error with the link")
//        }
        
        movieOverview.text = movieObject!.overview
        movieOriginalLanguage.text = movieObject!.original_language.uppercased()
        movieReleaseDate.text = movieObject!.release_date
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
