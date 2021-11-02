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
    
    let infoBoxView: UIView! = UIView()
    
    let movieTitleView: UIView! = UIView()
    
    let movieOriginalTitleLabel: UILabel! = UILabel()
    
    let movieImageParentView: UIView! = UIView()
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
        //Test for git to the changes
        
        
        var finalSizes = contentRect.size
        finalSizes.height = finalSizes.height - UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTheFilm))
        title = movie?.title
        view.backgroundColor = .white
        
        infoBoxView.layer.cornerRadius = 15
        infoBoxView.backgroundColor = .white
        infoBoxView.layer.shadowColor = UIColor.black.cgColor
        infoBoxView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        infoBoxView.layer.shadowOpacity = 0.5
        infoBoxView.layer.shadowRadius = 8
        
        movieTitleView.layer.cornerRadius = 15
        movieTitleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        movieTitleView.backgroundColor = UIColor.init(cgColor: CGColor.init(red: CGFloat(103.0/255.0), green: CGFloat(183.0/255.0), blue: CGFloat(209.0/255.0), alpha: CGFloat(0.9)))
        
        movieOriginalTitleLabel.text = movie?.original_title
        movieOriginalTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        movieOriginalTitleLabel.numberOfLines = 0
        movieOriginalTitleLabel.textColor = .white
        
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
        
        movieImageParentView.layer.shadowColor = UIColor.black.cgColor
        movieImageParentView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        movieImageParentView.layer.shadowOpacity = 0.5
        movieImageParentView.layer.shadowRadius = 8
        movieImageParentView.layer.cornerRadius = 15
        
        movieImageView.layer.cornerRadius = 15
        movieImageView.clipsToBounds = true
        
        movieOverviewTextView.text = movie!.overview
        movieOverviewTextView.font = UIFont.systemFont(ofSize: 16)
        movieOverviewTextView.isUserInteractionEnabled = false
        movieOverviewTextView.isScrollEnabled = false
        
        moviePopularityLabel.text = "Popularity: \(movie!.popularity)"
        
        movieOriginalLanguageLabel.text = "🌐\(movie!.original_language.uppercased())"
        
        movieReleaseDateLabel.text = "🗓\(movie!.release_date.replacingOccurrences(of: "-", with: "/"))"
        
        tamicFalse()
        
        addSubViews()
        
        addConstraints()
    }
    
    func tamicFalse() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        infoBoxView.translatesAutoresizingMaskIntoConstraints = false
        
        movieTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        movieOriginalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieImageParentView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        
        movieOverviewTextView.translatesAutoresizingMaskIntoConstraints = false
        moviePopularityLabel.translatesAutoresizingMaskIntoConstraints = false
        movieOriginalLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(movieImageParentView)
        movieImageParentView.addSubview(movieImageView)
        
        contentView.addSubview(infoBoxView)
    
        infoBoxView.addSubview(movieTitleView)
        
        movieTitleView.addSubview(movieOriginalTitleLabel)
        
        infoBoxView.addSubview(movieOverviewTextView)
        infoBoxView.addSubview(moviePopularityLabel)
        infoBoxView.addSubview(movieOriginalLanguageLabel)
        infoBoxView.addSubview(movieReleaseDateLabel)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            movieImageParentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            movieImageParentView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            movieImageParentView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            movieImageParentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3.7),
            
            movieImageView.topAnchor.constraint(equalTo: movieImageParentView.topAnchor),
            movieImageView.leftAnchor.constraint(equalTo: movieImageParentView.leftAnchor),
            movieImageView.rightAnchor.constraint(equalTo: movieImageParentView.rightAnchor),
            movieImageView.heightAnchor.constraint(equalTo: movieImageParentView.heightAnchor),
            
            infoBoxView.topAnchor.constraint(equalTo: movieImageParentView.bottomAnchor, constant: 15),
            infoBoxView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            infoBoxView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            infoBoxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            movieTitleView.topAnchor.constraint(equalTo: infoBoxView.topAnchor),
            movieTitleView.leftAnchor.constraint(equalTo: infoBoxView.leftAnchor),
            movieTitleView.rightAnchor.constraint(equalTo: infoBoxView.rightAnchor),
            movieTitleView.heightAnchor.constraint(equalTo: infoBoxView.heightAnchor, multiplier: 0.12),
            
            movieOriginalTitleLabel.centerXAnchor.constraint(equalTo: movieTitleView.centerXAnchor),
            movieOriginalTitleLabel.centerYAnchor.constraint(equalTo: movieTitleView.centerYAnchor),
            movieOriginalTitleLabel.leftAnchor.constraint(equalTo: movieTitleView.leftAnchor, constant: 10),
            movieOriginalTitleLabel.rightAnchor.constraint(equalTo: movieTitleView.rightAnchor, constant: -10),
            
            movieOverviewTextView.topAnchor.constraint(equalTo: movieTitleView.bottomAnchor),
            movieOverviewTextView.leftAnchor.constraint(equalTo: infoBoxView.leftAnchor, constant: 10),
            movieOverviewTextView.rightAnchor.constraint(equalTo: infoBoxView.rightAnchor, constant: -10),
            
            moviePopularityLabel.topAnchor.constraint(equalTo: movieOverviewTextView.bottomAnchor, constant: -4),
            moviePopularityLabel.leftAnchor.constraint(equalTo: infoBoxView.layoutMarginsGuide.leftAnchor, constant: 7),
            
            movieOriginalLanguageLabel.bottomAnchor.constraint(equalTo: infoBoxView.layoutMarginsGuide.bottomAnchor, constant: -10),
            movieOriginalLanguageLabel.leftAnchor.constraint(equalTo: infoBoxView.layoutMarginsGuide.leftAnchor, constant: 1),
            
            movieReleaseDateLabel.bottomAnchor.constraint(equalTo: infoBoxView.layoutMarginsGuide.bottomAnchor, constant: -10),
            movieReleaseDateLabel.rightAnchor.constraint(equalTo: infoBoxView.layoutMarginsGuide.rightAnchor, constant: -3)
        ])
    }
    
    @objc func shareTheFilm() {
        let text = "I suggest you to watch this movie: \(movie!.title)"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true)
    }
}
