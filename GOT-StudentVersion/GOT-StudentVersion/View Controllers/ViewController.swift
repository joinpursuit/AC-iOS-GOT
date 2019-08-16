

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: -- Outlet & imported Variables
    @IBOutlet var gotTableView: UITableView!
    var got = GOTEpisode.allEpisodes
    var gotArrayBySeason = sortedBySeason()
    @IBOutlet var searchBar: UISearchBar!
    
    var gotSeachResults:[GOTEpisode] {
        get{
            guard let gotSearchString = gotSearchString else {
                return got
            } //this filters searches through the searchString and makes sure its not empty else returns Person.allPeople
            guard gotSearchString != "" else {
                return got
            }
            
            if let gotScoptTitles = searchBar.scopeButtonTitles {
                let currentScopeIndex = searchBar.selectedScopeButtonIndex
                
                switch gotScoptTitles[currentScopeIndex]{
                case "Season":
                    return got.filter({$0.season == Int(gotSearchString)})
                case "Episode":
                    return got.filter({$0.name.lowercased().contains(gotSearchString.lowercased())})
                default:
                    return got
                }
            }
            return got
        }
    }
    //used to store values of persons and reload the tableView each time
    
    var gotSearchString:String? = nil {
        didSet {
            self.gotTableView.reloadData()
        }
    }
    
    
    //MARK: -- Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return gotArrayBySeason.allSeasons.count
    }
    //This code goes into the [[GOTEpisode]], grabs each section starting from index 0, and grabs the classification string and returns it to be displayed in the title header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Season \(gotArrayBySeason.allSeasons [section][0].season)"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gotArrayBySeason.allSeasons[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GOTID") as! GotTableViewCell
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "GOTID2") as! GotTableViewCell
        
        let info = gotSeachResults[indexPath.row]
        
        cell.gotName.text = "\( info.name)"
        cell.gotName.font = UIFont(name: "Papyrus", size: 14)
        cell.gotName.textColor = .white
        cell.seasonAndEpisode.text = "S:\( info.season) E: \(info.number)"
        cell.seasonAndEpisode.textColor = .white
        cell.gotImageView.image = UIImage(named: info.mediumImageID)
        
        cell2.gotName.text = "\( info.name)"
        cell2.gotName.font = UIFont(name: "Papyrus", size: 14)
        cell2.gotName.textColor = .white
        cell2.seasonAndEpisode.text = "S:\( info.season) E: \(info.number)"
        cell2.seasonAndEpisode.textColor = .white
        cell2.gotImageView.image = UIImage(named: info.mediumImageID)
        
        if info.season % 2 == 1{
            return cell
        }else {
            return cell2
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
    }
    //MARK: -- Table View Delgates
    //sets the height of the sections
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
    //function to pass data from one tableView Controller to another tableView Controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let detailViewControler = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        let info = gotSeachResults[indexPath.row]
        // this line passes the model to the second view controller and allows the second view controller tro figure out what it needs to assign to its attritubes
        detailViewControler.gotEpisode = info
        
        self.navigationController?.pushViewController(detailViewControler, animated: true)
        
    }
    //TODO
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gotSearchString = searchBar.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gotTableView.delegate = self
        gotTableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

