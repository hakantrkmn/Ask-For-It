//
//  CreateQuestionViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import Foundation
import UIKit

enum QuestionCreateError : Error
{
    case optionCannotBeEmpty
}

class CreateQuestionViewModel
{
    var options : [TableOption] = [TableOption(title: "")]
    
    var dataSource : UITableViewDiffableDataSource<Section,TableOption>!
    
    var questionId : String?
    
    func createQuestion(with table : UITableView , question : String) async throws
    {
        if question == ""
        {
            throw QuestionCreateError.optionCannotBeEmpty
        }
        var opList : [String] = []
        for section in await 0..<table.numberOfSections
        {
            for row in await 0..<table.numberOfRows(inSection: section)
            {
                let indexPath = IndexPath(row: row, section: section)
                
                if let cell = await table.cellForRow(at: indexPath) as? OptionsTableCell
                {
                    if await cell.option.text?.count != 0 , await cell.option.text != " "
                    {
                        await  opList.append(cell.option.text!)
                    }
                    else
                    {
                        throw QuestionCreateError.optionCannotBeEmpty
                    }
                }
            }
        }
        self.questionId = try await NetworkService.shared.createQuestion(questionString: question, with: opList)
    }
    
    func addNewRow()
    {
        options.append(TableOption(title: ""))
        
        appendItemToDataSource()
    }
    
    func appendItemToDataSource()
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section,TableOption>()
        snapshot.appendSections([.first])
        snapshot.appendItems(options)
        dataSource.apply(snapshot,animatingDifferences: .random())
        
        
    }
    
    func deleteItemFromDataSource(at indexPath : IndexPath)
    {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return}

        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
        dataSource.apply(snapshot,animatingDifferences: true)
        options.removeAll(where: {$0.id == item.id})
    }
}


enum Section
{
    case first
}

struct TableOption : Hashable
{
    var id = UUID()
    var title : String
}
