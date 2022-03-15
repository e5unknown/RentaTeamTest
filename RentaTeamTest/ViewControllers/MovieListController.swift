//
//  MovieListController.swift
//  RentaTeam Test
//
//  Created by Azat Battalov on 14.03.2022.
//

import UIKit

class MovieListController: UICollectionViewController {

    @IBOutlet var alertView: UIView!
    private let manager = CoreDataManager.sharedInstance
    private let moviesPerPage = 20
    private let cellIdentifier = "MovieCell"
    private let movieSegueId = "goToMovie"
    
    var moviesObserver: NSObjectProtocol?
    var failObserver: NSObjectProtocol?
    
    var movies: [Movie] = []
    var loadedPages = 0
    var selectedMovie: Movie?
    var isUpdating = false {
        willSet{
            if newValue{
                let indicator = UIActivityIndicatorView(style: .gray)
                indicator.startAnimating()
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)
            }else{
                navigationItem.rightBarButtonItems?.removeAll()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
    }
    
    func getMovies(){
        if movies.isEmpty{
            //Если есть сохраненные постеры с прошлой сессии, устанавливаем перед обновления
            setMovies()
            setMoviesUpdatelistener()
        }
        
        let nextPage = loadedPages + 1
        if !isUpdating{
            isUpdating = true
            manager.fetchAndSaveMoviesFromDB(page: nextPage)
        }
    }
    
    func setMoviesUpdatelistener(){
        guard moviesObserver == nil else { return }

        moviesObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name("moviesFromDBUpdated"), object: nil, queue: OperationQueue.main) { _ in
            if self.loadedPages == 0{
                self.movies = []
            }
            self.setMovies()
            self.loadedPages += 1
            self.connectionAlert(isOn: false)
        }
        
        failObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name("failedToUpdateMovies"), object: nil, queue: OperationQueue.main, using: { _ in
            self.isUpdating = false
            self.connectionAlert(isOn: true)
        })
        //обсерверы можно деаллоцировать, но это MainVC, поэтому пока не за чем
    }
    
    func setMovies(){
        let oldMoviesCount = movies.count
        movies = manager.getLocalMovies()
        let newMoviesCount = movies.count
        if !movies.isEmpty{
            let cellsToReload = oldMoviesCount ... newMoviesCount - 1
            
            collectionView.insertItems(at: cellsToReload.map({IndexPath(item: $0, section: 0)}))
            isUpdating = false
        }
    }
    
    
    //MARK: - SHOW CONNECTION ALERT
    func connectionAlert(isOn: Bool){
        if isOn{
            self.view.addSubview(alertView)
            alertView.layer.cornerRadius = 10
            alertView.translatesAutoresizingMaskIntoConstraints = false
            let toolbarHeight = (UIApplication.shared.statusBarFrame.height) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            alertView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: toolbarHeight + 10.0).isActive = true
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        }else{
            alertView.removeFromSuperview()
        }

    }
    
    //MARK: - PREPARE_FOR_SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == movieSegueId{
            (segue.destination as! MovieController).movie = selectedMovie!
        }
    }
    
    
    //MARK: - COLLECTION DATASOURCE
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Подгрузка фильмов при достижении низа экрана
        if indexPath.row == movies.count - 1{
            getMovies()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.initCell(movie: movie)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: movieSegueId, sender: nil)
    }
    

}

    //MARK: - COLLECTION FLOW LAYOUT
extension MovieListController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sumPaddings = 30.0
        let width = (view.frame.width - sumPaddings) / 2
        let height = width / 2 * 3
        return CGSize(width: width, height: height)
    }
}

