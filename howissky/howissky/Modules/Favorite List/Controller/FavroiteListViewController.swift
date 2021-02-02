//
//  FavroiteListViewController.swift
//  howissky
//
//  Created by Kamal Sharma on 02/02/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//

import UIKit

// MARK: - Call class can implement this protocol for Favroite selection
protocol FavroiteListDelegate: class {
    func favoriteSelected(cityName: String)
}

// MARK: - User can browse favorites list and also can delete favorites city
class FavroiteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel = FavroiteViewModel()
    weak var delegate: FavroiteListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
}

extension FavroiteListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.uiRenderDataList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getFavoriteCell(tableView, indexPath)
    }
}

extension FavroiteListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteFavoriteFromTableAt(indexPath, editingStyle)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFavoriteAt(indexPath)
    }
}
extension FavroiteListViewController {
    // MARK: - Fetch City All Favorite List
    private func fetchData() {
        viewModel.fetchFavroiteList { (isSuccess) in
            if isSuccess {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Delete Specific Favorite from list
    private func deleteFavoriteFromTableAt(_ indexPath: IndexPath, _ editingStyle: UITableViewCell.EditingStyle) {
        guard let id = viewModel.uiRenderDataList?[indexPath.row].1 else { return }
        if editingStyle == .delete {
            viewModel.uiRenderDataList?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        viewModel.deleteThisFavroite(id) { (_ ) in }
    }
    // MARK: - Move to Weather Page afte favorite selected by user
    private func selectedFavoriteAt(_ indexPath: IndexPath) {
        guard let city = viewModel.uiRenderDataList?[indexPath.row].0 else { return }
        DispatchQueue.main.async {
            // MARK: - Dismiss the cntrlr after selection
            self.dismiss(animated: true) {
                self.delegate?.favoriteSelected(cityName: city)
            }
        }
    }
    // MARK: - get favorites tabelview cell
    private func getFavoriteCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = viewModel.uiRenderDataList?[indexPath.row].0
        cell.selectionStyle = .default
        return cell
    }
}

extension UIStoryboard {
    class func load(_ storyboard: ControllerID) -> UIViewController{
        return UIStoryboard(name: StoryBoardName.main.rawValue, bundle: nil).instantiateViewController(withIdentifier: storyboard.rawValue)
    }
}
