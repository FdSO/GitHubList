//
//  GitHubListTests.swift
//  GitHubListTests
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import Alamofire

import XCTest
@testable import GitHubList

class GitHubListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    // teste para paginação, execute este teste duas vezes para visualizar o sucesso e o erro
    func testPagination() {
        
        func getRepositories(page: Int) {
            
            group.enter()
            
            let viewModel = RepositoriesViewModel(perPage: 1, inicialPage: page)
            
            viewModel.getRepositories { (error) in
                                     
                XCTAssertNil(error)
                
                viewModel.model.forEach { (repositoryModel) in
                    print("💚💚💚 " + (repositoryModel.fullName ?? "sem nome"))
                }
                
                group.leave()
            }
        }
        
        // quantidade de páginas para teste
        let fakeMaxPage = 9 //acima deste valor, podemos conferir o limite da api
        
        let expectation = XCTestExpectation(description: "PAGINATION")
        
        // fila de requisições
        let group = DispatchGroup()
        
        // criação da quantidade de requisições de acordo com a quantidade de página
        for page in 1...fakeMaxPage {
            getRepositories(page: page)
        }
        
        // aguardamos o grupo de requisições para finalizarmos o teste
        group.notify(queue: .main) {
            expectation.fulfill()
        }

        // tempo suficiente para as requições de acordo com timeout do Alamofire
        wait(for: [expectation], timeout: AF.sessionConfiguration.timeoutIntervalForRequest * Double(fakeMaxPage))
    }
}
