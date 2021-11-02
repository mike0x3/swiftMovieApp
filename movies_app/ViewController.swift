//
//  ViewController.swift
//  movies_app
//
//  Created by Uno qualunque on 28/09/21.
//

import UIKit
import SkeletonView

class MovieCell: UITableViewCell {
    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var rating: UILabel!
}

class ViewController: UITableViewController {
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 130, height: 30))
    var moviesArray = [Movie]()
    
//    var topRatedMovies = [Movie]()
//    var mostRecentMovies = [Movie]()
//    var nowPlayingMovies = [Movie]()
//    var resultsArray = [Movie]()
    
    var link: String = ""
    var url: URL = URL(string: "https://www.auro-3d.com/wp-content/uploads/2016/08/no-poster-available.jpg")!
    let searchLabel = UILabel()
    let searchImage = UIImageView(image: UIImage(ciImage: (CIImage(image: UIImage(named: "search")!)?.applyingFilter("CIColorControls", parameters: [ kCIInputSaturationKey: 0.0 ]))!))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the info button
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        let infoBarButton = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButton
        
        tableView.showsVerticalScrollIndicator = false
        
        showDataLoading()
        
        if navigationController?.tabBarItem.tag == 0 {
            link = "https://api.themoviedb.org/3/movie/top_rated?api_key=a8a5402443a2727ed998fe88344895b4"
            self.title = "Top Movies"
            performSelector(inBackground: #selector(showData), with: nil)
        } else if navigationController?.tabBarItem.tag == 1 {
            link = "https://api.themoviedb.org/3/movie/upcoming?api_key=a8a5402443a2727ed998fe88344895b4"
            self.title = "Upcoming Movies"
            performSelector(inBackground: #selector(showData), with: nil)
        } else if navigationController?.tabBarItem.tag == 2 {
            link = "https://api.themoviedb.org/3/movie/now_playing?api_key=a8a5402443a2727ed998fe88344895b4"
            self.title = "Now Playing"
            performSelector(inBackground: #selector(showData), with: nil)
        } else if navigationController?.tabBarItem.tag == 3 {
            
            searchBar.placeholder = "Star Wars"
            searchBar.searchTextField.clearButtonMode = .never
            
            let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchMovie))
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(clearArray))
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)
            navigationItem.rightBarButtonItems = [searchButton, cancelButton]
            
            tableView.isHidden = true
            
            showEmptySearchScreen()
        }
    }
    
    func showEmptySearchScreen() {
        let localView = self.navigationController?.view
        localView!.backgroundColor = .white
        
        searchLabel.text = "Search for your movie!"
        searchLabel.textColor = .lightGray
        
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        
        searchImage.contentMode = .scaleAspectFit
        
        localView?.addSubview(searchImage)
        localView?.addSubview(searchLabel)
        
        NSLayoutConstraint.activate([
            searchImage.centerXAnchor.constraint(equalTo: localView!.centerXAnchor),
            searchImage.centerYAnchor.constraint(equalTo: localView!.centerYAnchor, constant: 15),
            searchImage.widthAnchor.constraint(equalTo: localView!.widthAnchor, multiplier: 0.8),
            
            searchLabel.centerXAnchor.constraint(equalTo: localView!.centerXAnchor),
            searchLabel.centerYAnchor.constraint(equalTo: localView!.centerYAnchor, constant: -110)
        ])
    }
    
    @objc func showInfo() {
        let ac = UIAlertController(title: "Info source", message: "The info used in this application is taken from the TheMovieDB api", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Visit Website", style: .default, handler: {_ in
            let url = URL(string: "http://themoviedb.org")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }))
        ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading feed, check your connection adn try again!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    @objc func clearArray() {
        self.searchBar.text = ""
        self.moviesArray = []
        self.tableView.reloadData()
        searchLabel.isHidden = false
        searchImage.isHidden = false
        tableView.isHidden = true
    }
}

//Data loading/showing methods
extension ViewController {
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let moviesData = try? decoder.decode(Movies.self, from: json) {
            moviesArray = moviesData.results
            if moviesArray.count > 0 {
                DispatchQueue.main.async { [weak self] in
                    //self?.movieClickable = true
                    self?.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    self?.tableView.reloadData()
                }
            } else {
                moviesArray.append(.init(title: "No movies found", vote_average: 10, original_language: "en", release_date: "No release date", poster_path: nil, backdrop_path: nil, overview: "", original_title: "", popularity: 1000))
                DispatchQueue.main.async { [weak self] in
                    //self?.movieClickable = true
                    self?.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func searchMovie() {
        self.showDataLoading()
        searchLabel.isHidden = true
        searchImage.isHidden = true
        tableView.isHidden = false
        
        if searchBar.text != "" {
            let searchData = self.searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=a8a5402443a2727ed998fe88344895b4&query=\(searchData!)&page=1") {
                    if let data = try? Data(contentsOf: url) {
                        self?.parse(json: data)
                        return
                    }
                }
                self?.showError()
            }
        } else {
            let ac = UIAlertController(title: "Invalid research", message: "Digit the text to search", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @objc func showData() {
        if let url = URL(string: link) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func showDataLoading() {
        moviesArray.append(contentsOf: [
            .init(title: "a", vote_average: 1, original_language: "", release_date: "", poster_path: nil, backdrop_path: nil, overview: "", original_title: "", popularity: 10),
            .init(title: "a", vote_average: 1, original_language: "", release_date: "", poster_path: nil, backdrop_path: nil, overview: "", original_title: "", popularity: 10),
            .init(title: "a", vote_average: 1, original_language: "", release_date: "", poster_path: nil, backdrop_path: nil, overview: "", original_title: "", popularity: 10),
            .init(title: "a", vote_average: 1, original_language: "", release_date: "", poster_path: nil, backdrop_path: nil, overview: "", original_title: "", popularity: 10),
            .init(title: "a", vote_average: 1, original_language: "", release_date: "", poster_path: nil, backdrop_path: nil, overview: "", original_title: "", popularity: 10),
            .init(title: "a", vote_average: 1, original_language: "", release_date: "", poster_path: nil, backdrop_path: nil, overview: "", original_title: "", popularity: 10),
        ])
        
        tableView.showAnimatedGradientSkeleton()
        tableView.reloadData()
    }
}

//Table view methods
extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if moviesArray[indexPath.row].title == "No movies found" {
            return
        }
        let detailPage = MovieDetailViewController()
        detailPage.movie = moviesArray[indexPath.row]
        navigationController?.pushViewController(detailPage, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        
        if let moviePath = moviesArray[indexPath.row].poster_path {
            url = URL(string: "https://image.tmdb.org/t/p/original\(moviePath)")!
        } else {
            url = URL(string: "https://www.auro-3d.com/wp-content/uploads/2016/08/no-poster-available.jpg")!
        }
        
        print(url)
        let imageData = try? Data(contentsOf: url)
        
        
        cell.title.text = moviesArray[indexPath.row].title
        cell.movieImage.image = UIImage(data: imageData!)
        cell.rating.text = "\(moviesArray[indexPath.row].vote_average)/10"
        
        return cell
    }
}

//Skeleton library methods (blur loading data)
extension ViewController: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, prepareCellForSkeleton cell: UITableViewCell, at indexPath: IndexPath) {
        return
    }
    
}
