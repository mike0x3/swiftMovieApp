//
//  ViewController.swift
//  movies_app
//
//  Created by Uno qualunque on 28/09/21.
//

import UIKit

class MovieCell: UITableViewCell {
    
    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var rating: UILabel!
}

class ViewController: UITableViewController {

    var moviesArray = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appTitle: String
        
        tabBarItem.title = "Top Rated"
        tabBarItem.image = UIImage(systemName: "item")
        
        let link: String
        
        if navigationController?.tabBarItem.tag == 0 {
            link = "https://api.themoviedb.org/3/movie/top_rated?api_key=a8a5402443a2727ed998fe88344895b4"
            self.title = "Top Movies"
        } else {
            link = "https://api.themoviedb.org/3/movie/upcoming?api_key=a8a5402443a2727ed998fe88344895b4"
            self.title = "Upcoming Movies"
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: link) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                }
            }
        }
        
        tableView.showsVerticalScrollIndicator = false
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        let infoBarButton = UIBarButtonItem(customView: infoButton)
        
        navigationItem.rightBarButtonItem = infoBarButton
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        cell.title.text = moviesArray[indexPath.row].title
        let url = URL(string: "https://image.tmdb.org/t/p/original\(moviesArray[indexPath.row].poster_path)")
        let imageData = try? Data(contentsOf: url!)
        cell.movieImage.image = UIImage(data: imageData!)
        cell.rating.text = "\(moviesArray[indexPath.row].vote_average)/10"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPage = MovieDetailViewController()
        detailPage.movie = moviesArray[indexPath.row]
        
        
        navigationController?.pushViewController(detailPage, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let moviesData = try? decoder.decode(Movies.self, from: json) {
            moviesArray = moviesData.results
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func showInfo() {
        let ac = UIAlertController(title: "Info source", message: "The info used in this application is taken from the TheMovieDB api", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Visit Website", style: .default, handler: {_ in
            //UIApplication.shared.open(URL(string: "http://themoviedb.org")!, options: [:], completionHandler: nil))
            let url = URL(string: "http://themoviedb.org")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }))
        ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func showError() {
        let uc = UIAlertController(title: "Data error", message: "There was an error loading the data", preferredStyle: .alert)
        uc.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(uc, animated: true)
    }


}

