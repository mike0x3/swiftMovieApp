//
//  MovieDetailViewController.swift
//  movies_app
//
//  Created by Uno qualunque on 03/10/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movieTitleLabel: UILabel!
    var movieOriginalTitleLabel: UILabel!
    var movieImageView: UIImageView!
    var movieOverviewTextView: UITextView!
    var moviePopularityLabel: UILabel!
    var movieOriginalLanguageLabel: UILabel!
    var movieReleaseDateLabel: UILabel!
    
    var movieTitle: String?
    var movie: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTheFilm))
        title = movie?.title
        view.backgroundColor = .white
        
        movieTitleLabel = UILabel()
        movieOriginalTitleLabel = UILabel()
        movieImageView = UIImageView()
        movieOverviewTextView = UITextView()
        moviePopularityLabel = UILabel()
        movieOriginalLanguageLabel = UILabel()
        movieReleaseDateLabel = UILabel()
        
        
        movieTitleLabel.text = movie?.title
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieOriginalTitleLabel.text = movie?.original_title
        movieOriginalTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        movieOriginalTitleLabel.numberOfLines = 0
        if movie!.original_language == "en" {
            movieOriginalTitleLabel.text = movie?.original_title
        } else {
            movieOriginalTitleLabel.text = "\(movie!.title) / \(movie!.original_title)"
        }
        
        movieOriginalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let url = URL(string: "https://image.tmdb.org/t/p/original\(movie!.backdrop_path)")!
        let data = try? Data(contentsOf: url)
        movieImageView.image = UIImage(data: data!)
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        
        movieOverviewTextView.text = movie!.overview
        movieOverviewTextView.font = UIFont.systemFont(ofSize: 16)
        movieOverviewTextView.isUserInteractionEnabled = false
        movieOverviewTextView.isScrollEnabled = false
        movieOverviewTextView.translatesAutoresizingMaskIntoConstraints = false
        
        moviePopularityLabel.text = "Popularity: \(movie!.popularity)"
        moviePopularityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieOriginalLanguageLabel.text = movie!.original_language.uppercased()
        movieOriginalLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieReleaseDateLabel.text = movie!.release_date.replacingOccurrences(of: "-", with: "/")
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubViews()
        
        addConstraints()
    }
    
    func addSubViews() {
        view.addSubview(movieOriginalTitleLabel)
        view.addSubview(movieImageView)
        view.addSubview(movieOverviewTextView)
        view.addSubview(moviePopularityLabel)
        view.addSubview(movieOriginalLanguageLabel)
        view.addSubview(movieReleaseDateLabel)
    }
    
    func addConstraints() {
        
        let layout = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: layout.topAnchor),
            movieImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            movieImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 270),
            
            movieOriginalTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            movieOriginalTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 13),
            movieOriginalTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            movieOverviewTextView.topAnchor.constraint(equalTo: movieOriginalTitleLabel.bottomAnchor),
            movieOverviewTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            movieOverviewTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            moviePopularityLabel.topAnchor.constraint(equalTo: movieOverviewTextView.bottomAnchor, constant: -4),
            moviePopularityLabel.leftAnchor.constraint(equalTo: layout.leftAnchor, constant: -5),
            
            movieOriginalLanguageLabel.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
            movieOriginalLanguageLabel.leftAnchor.constraint(equalTo: layout.leftAnchor),
            
            movieReleaseDateLabel.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
            movieReleaseDateLabel.rightAnchor.constraint(equalTo: layout.rightAnchor)
        ])
    }
    
    @objc func shareTheFilm() {
        let text = "I suggest you to watch this movie: \(movie!.title)"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true)
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
