//
//  AddNewTaskViewModelTests.swift
//  SawitPro
//
//  Created by Rakka Purnama on 08/01/25.
//

import XCTest
import CoreData
import Firebase
@testable import SawitPro

final class AddNewTaskViewModelTests: XCTestCase {
    var addNewTaskViewModel: AddNewTaskViewModel!
    var mockContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        
        // Setup Core Data stack dan context mock
        let persistentContainer = NSPersistentContainer(name: "TaskEntity") // Ganti dengan nama model Core Data Anda
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        mockContext = persistentContainer.viewContext
        
        // Inisialisasi ViewModel
        addNewTaskViewModel = AddNewTaskViewModel()
    }
    override func tearDown() {
            addNewTaskViewModel = nil
            mockContext = nil
            super.tearDown()
    }
        
        // Unit Test untuk saveDataTask
    func testSaveDataTask() async {
            // Siapkan data input
            let title = "Test Task"
            let description = "This is a test task."
            let dueDate = Date()
            let priority = "1"
            let colorName = "Red"
            let assign = "John Doe"
          
            // Panggil metode yang ingin diuji
            await addNewTaskViewModel.saveDataTask(title: title, description: description, dueDate: dueDate, priority: priority, colorName: colorName, assignName: assign, context: mockContext)
            
            // Ambil entitas Task dari context setelah disimpan
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            do {
                let tasks = try mockContext.fetch(fetchRequest)
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, yyyy-MM-dd HH:mm:ss"
                let dueDateConvert = formatter.string(from: dueDate)
                // Asumsikan hanya ada satu tugas setelah menyimpan
                XCTAssertEqual(tasks.count, 1, "There should be exactly one task saved in Core Data.")
                let savedTask = tasks.first!
                XCTAssertEqual(savedTask.title, title, "The title should be saved correctly.")
                XCTAssertEqual(savedTask.descriptions, description, "The description should be saved correctly.")
                XCTAssertEqual(savedTask.duedate, dueDateConvert, "The due date should be saved correctly.")
                XCTAssertEqual(savedTask.priority, priority, "The priority should be saved correctly.")
                XCTAssertEqual(savedTask.colorName, colorName, "The color name should be saved correctly.")
                XCTAssertEqual(savedTask.assignName, assign, "The assigned name should be saved correctly.")
            } catch {
                XCTFail("Failed to fetch tasks: \(error)")
            }
        }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
