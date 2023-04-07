//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by 김준혁 on 2023/03/31.
//
import UIKit

class AccountSummaryViewController: UIViewController {
    
    //MARK: - Properties
    
    // Request Models
    var profile: Profile?
    var accounts: [Account] = []
    
    // view Models
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "hehe", date: Date())
    var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
    
    // Componenets
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero) // set where the header will be! (location)
    let refreshControl = UIRefreshControl()
    var isLoaded = false
    
    // It will be instanciated when it is actually called.
    lazy var logoutBarButtonItem : UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped) )
        btn.tintColor = .label // That's gonna make sure it is sycned light and dark mode
        return btn
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
}

extension AccountSummaryViewController {
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor // hmm... Under the safe area and the header line..
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Register
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    
    private func setupTableHeaderView() {
        // -> height gonna be 144
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) // Needs more explanation
        size.width = UIScreen.main.bounds.width
        // let the width size fit its device's width
        
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10) // fake data
        configureTableCells(with: accounts)
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        let account = accountCellViewModels[indexPath.row]
        
        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID) as! AccountSummaryCell
            cell.configure(with: account) // cell is the type of AccountSummaryCell.
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        
        let userId = String(Int.random(in: 1..<4))
        
        fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                let title : String
                let message : String
                
                print(error.localizedDescription)
                switch error {
                case .serverError:
                    title = "Server Error"
                    message = "Ensure you are connected to the internet. Please try again."
                case .decodingError:
                    title = "Decoding Error"
                    message = "We could not process your request. Please try again."
                }
                self.showErrorAlert(title: title, message: message)
                
            }
            group.leave()
        }
        
        group.enter()
        fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
            case .failure(let error):
                self.dispalyError(error)
            }
            group.leave()
        }
        
        // This code will only be run when the group work are all done
        group.notify(queue: .main) {
            
            guard let profile = self.profile else { return }
            
            self.isLoaded = true
            self.configureTableHeaderView(with: profile)
            self.configureTableCells(with: self.accounts)
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing() // end refresh if it's possible
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(accountType: $0.type,
                                         accountName: $0.name,
                                         balance: $0.amount)
        }
    }
    
    private func dispalyError(_ error : NetworkError) {
        let title : String
        let message : String
        
        print(error.localizedDescription)
        switch error {
        case .serverError:
            title = "Server Error"
            message = "Ensure you are connected to the internet. Please try again."
        case .decodingError:
            title = "Decoding Error"
            message = "We could not process your request. Please try again."
        }
        self.showErrorAlert(title: title, message: message)
    }
    
    private func showErrorAlert(title : String, message : String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Actions
extension AccountSummaryViewController {
    @objc
    func logoutTapped(sender : UIButton) {
        NotificationCenter.default.post(name: .Logout, object: nil)
    }
    
    @objc
    func refreshContent() {
        reset()
        fetchData()
        tableView.reloadData()
    }
    
    private func reset() {
        profile = nil
        accounts = []
        isLoaded = false
    }
}
