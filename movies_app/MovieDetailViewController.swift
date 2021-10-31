//
//  MovieDetailViewController.swift
//  movies_app
//
//  Created by Uno qualunque on 03/10/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    let scrollView: UIScrollView! = UIScrollView()
    let contentView: UIView! = UIView()
    let movieTitleLabel: UILabel! = UILabel()
    let movieOriginalTitleLabel: UILabel! = UILabel()
    let movieImageView: UIImageView! = UIImageView()
    let movieOverviewTextView: UITextView! = UITextView()
    let moviePopularityLabel: UILabel! = UILabel()
    let movieOriginalLanguageLabel: UILabel! = UILabel()
    let movieReleaseDateLabel: UILabel! = UILabel()
    
    var movie: Movie?
    var url: URL = URL(string: "https://www.auro-3d.com/wp-content/uploads/2016/08/no-poster-available.jpg")!
    
    override func viewDidAppear(_ animated: Bool) {
        var contentRect = CGRect.zero
        
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        var finalSizes = contentRect.size
        finalSizes.width = finalSizes.width - UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        
        scrollView.contentSize = finalSizes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTheFilm))
        title = movie?.title
        view.backgroundColor = .white
        
        movieTitleLabel.text = movie?.title
        
        movieOriginalTitleLabel.text = movie?.original_title
        movieOriginalTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        movieOriginalTitleLabel.numberOfLines = 0
        
        if movie!.original_language == "en" {
            movieOriginalTitleLabel.text = movie?.original_title
        } else {
            movieOriginalTitleLabel.text = "\(movie!.title) / \(movie!.original_title)"
        }
        
        if let imagePath = movie!.backdrop_path {
            url = URL(string: "https://image.tmdb.org/t/p/original\(imagePath)")!
        } else {
            url = URL(string: "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/3/3/2/7/237233-6-eng-GB/Cosmoprof-Asia-Ltd-SIC-Cosmetics-20132_news_large.jpg")!
        }
        
        let data = try? Data(contentsOf: url)
        movieImageView.image = UIImage(data: data!)
        
        movieOverviewTextView.text = movie!.overview
        movieOverviewTextView.font = UIFont.systemFont(ofSize: 16)
        movieOverviewTextView.isUserInteractionEnabled = false
        movieOverviewTextView.isScrollEnabled = false
        
        moviePopularityLabel.text = "Popularity: \(movie!.popularity)"
        
        movieOriginalLanguageLabel.text = movie!.original_language.uppercased()
        
        movieReleaseDateLabel.text = movie!.release_date.replacingOccurrences(of: "-", with: "/")
        
        tamicFalse()
        
        addSubViews()
        
        addConstraints()
    }
    
    func tamicFalse() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieOriginalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieOverviewTextView.translatesAutoresizingMaskIntoConstraints = false
        moviePopularityLabel.translatesAutoresizingMaskIntoConstraints = false
        movieOriginalLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(movieOriginalTitleLabel)
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieOverviewTextView)
        contentView.addSubview(moviePopularityLabel)
        contentView.addSubview(movieOriginalLanguageLabel)
        contentView.addSubview(movieReleaseDateLabel)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            movieImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            movieImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            movieImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 270),
            
            movieOriginalTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            movieOriginalTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            movieOriginalTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            movieOverviewTextView.topAnchor.constraint(equalTo: movieOriginalTitleLabel.bottomAnchor),
            movieOverviewTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            movieOverviewTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            moviePopularityLabel.topAnchor.constraint(equalTo: movieOverviewTextView.bottomAnchor, constant: -4),
            moviePopularityLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 7),
            
            movieOriginalLanguageLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -10),
            movieOriginalLanguageLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            
            movieReleaseDateLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -10),
            movieReleaseDateLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor)
        ])
    }
    
    @objc func shareTheFilm() {
        let text = "I suggest you to watch this movie: \(movie!.title)"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true)
    }
}
