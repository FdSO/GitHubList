//
//  GitHubListUITests.swift
//  GitHubListUITests
//
//  Created by Filipe Oliveira on 02/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import XCTest

class GitHubListUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // teste para visulizar ação de salvar e remover para o estado de UI atual, qualquer alteração pode surtir efeito no teste
    func testCoreDataPath() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        // índice para célula aleatória
        let indexCell: Int = .random(in: 0...5)
        
        // verifica se a célula existe e se é clickavel - propriedade lazy
        if app.tables.cells.element(boundBy: indexCell).waitForExistence(timeout: 30.0) &&
            app.tables.cells.element(boundBy: indexCell).exists &&
            app.tables.cells.element(boundBy: indexCell).isHittable {
            
            app.tables.cells.element(boundBy: indexCell).tap()
            
            // se já estiver salvo, remove
            if app.navigationBars.buttons.element(boundBy: 1).label.uppercased() == "REMOVE" {
                app.navigationBars.buttons.element(boundBy: 1).tap()
            }
            
            app.swipeUp()

            app.swipeDown()
            
            app.navigationBars.buttons.element(boundBy: 1).tap()
            
            app.navigationBars.buttons.element(boundBy: 0).tap()
            
            app.buttons.element(boundBy: 1).tap()
            
            app.buttons.element(boundBy: 0).tap()
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
