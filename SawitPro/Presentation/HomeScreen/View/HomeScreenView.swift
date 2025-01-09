//
//  HomeScreenView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 03/01/25.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject private var homeScreenViewModel = HomeScreenViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @State private var searchText: String = ""
    @State private var isBottomSheetPresented = false
    @State private var isSheetPresented = false
    @State private var isSheetPresentedDelete = false
    @State private var isBottomSheetPresentedDelete = false
    @State private var id = UUID()
    @State private var idFirestore = ""
    @State private var isBottom: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment: .leading, spacing: 1) {
                        VStack{
                            
                            Text("Welcome")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14))
                            
                            
                            Text("Sudah Update kerjaan kan kamu")
                                .font(.headline)
                                .font(.system(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }.padding(.horizontal,12)
                        FilterView(filterItem: homeScreenViewModel.filters) {title, status in
                            Task {
                                if networkMonitor.isConnected {
                                    print("Connectet")
                                    await homeScreenViewModel.getDataTaskFireStore(filter: status,searchName: "")
                                }else{
                                    print("Is NOt Connectet")
                                    await homeScreenViewModel.getDataTask(filter: status,searchName: "", context: viewContext)
                                }
                            }
                        }
                        searchHomeScreenView
                        if homeScreenViewModel.items.isEmpty {
                            EmptyStateView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            
                        } else {
                            CardTaskView(id: $id,idFirestore: $idFirestore, isSheetPresented: $isSheetPresented, taskItem: $homeScreenViewModel.items,iSDetail: .constant(false), isSheetPresentedDelete: $isSheetPresentedDelete)
                        }
                        
                    }.sheet(isPresented: $isSheetPresented) {
                        BottomSheetView(isPresented: $isSheetPresented) {
                            BootomSheetChoice(isPresented : $isBottomSheetPresented,filterItem: homeScreenViewModel.filters, id: $id, action: {title,status in
                                Task {
                                    async let updateTaskEntity: () = homeScreenViewModel.updateTask(id: id, status: status, context: viewContext)
                                    async let updateTaskEntityFireStore: () = homeScreenViewModel.updateTaskFireStore(idTask: id, idFireStore: idFirestore, status: Int(status))
                                    
                                    // Waiing task finish
                                    await updateTaskEntity
                                    await updateTaskEntityFireStore
                                    
                                    
                                    
                                    if networkMonitor.isConnected {
                                        await homeScreenViewModel.getDataTaskFireStore(filter: 0,searchName: "")
                                    }else{
                                        await homeScreenViewModel.getDataTask(filter: 0,searchName: "", context: viewContext)
                                    }
                                    
                                }
                                isSheetPresented = false
                            })
                            
                        }
                    }
                    .sheet(isPresented: $isSheetPresentedDelete) {
                        BottomSheetView(isPresented: $isSheetPresentedDelete) {
                            BootomSheetConfirmationDelete(id:$id,fireStoreId: $idFirestore) { id,fireStoreId in
                                Task{
                                    async let deleteTaskEntity: () = homeScreenViewModel.deleteTaskEntity(taskId: UUID(uuidString: id) ?? UUID(), context: viewContext)
                                    async let deleteTaskHistoryEntity: () = homeScreenViewModel.deleteTaskHistoryEntity(taskId: UUID(uuidString: id) ?? UUID(), context: viewContext)
                                    async let deleteTaskEntityFireStore: () = homeScreenViewModel.deleteTaskEntityFireStore(documentID: fireStoreId)
                                    async let deleteHistoryTaskEntityFireStore: () = homeScreenViewModel.deleteHistoryTaskEntityFireStore(taskId: id)
                                    
                                    // Waiing task finish
                                    await deleteTaskEntity
                                    await deleteTaskHistoryEntity
                                    await deleteTaskEntityFireStore
                                    await deleteHistoryTaskEntityFireStore
                                    
                                    
                                    if networkMonitor.isConnected {
                                        await homeScreenViewModel.getDataTaskFireStore(filter: 0,searchName: "")
                                    }else{
                                        await homeScreenViewModel.getDataTask(filter: 0,searchName: "", context: viewContext)
                                    }
                                }
                                isSheetPresentedDelete = false
                            } actionCancel: {
                                isSheetPresentedDelete = false
                            }
                        }
                    }
                }
                if homeScreenViewModel.isLoading{
                    LoadingPopupView(message: $homeScreenViewModel.successMessage)
                }
                VStack{
                    Spacer()
                    
                    SuccessPopupView(
                        isVisible: $homeScreenViewModel.isCompleted,
                        message: homeScreenViewModel.successMessage,
                        duration: 3.0,
                        backgroundColor: .black,
                        textColor: .white
                    )
                    floatingActionBottom
                }
            }
            .navigationTitle("Main Screen") // Correct placement
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    if networkMonitor.isConnected {
                        await homeScreenViewModel.getDataTaskFireStore(filter: 0,searchName: "")
                    }else{
                        await homeScreenViewModel.getDataTask(filter: 0,searchName: "", context: viewContext)
                    }
                }
                
            }
            
        }
        
        
        
    }
    
    var floatingActionBottom: some View{
        VStack {
            HStack {
                
                HStack {
                    
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    NavigationLink(destination: AddNewTaskView()) {
                        Text("Add Task")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                } .padding()  // Apply padding inside the HStack
                    .background(Color("bgsawitprocolor")) // Set background color
                    .cornerRadius(15)  // Apply rounded corners
                    .shadow(radius: 5)  // Optional: Apply shadow for
                
            }
            
        }
    }
    
    var searchHomeScreenView: some  View{
        HStack {
            // TextField untuk input pencarian
            TextField("Search...", text: $homeScreenViewModel.searchQuery)
                .padding(3)
                .background(Color.white)
                .cornerRadius(8)
                .foregroundColor(.black)
                .onChange(of: homeScreenViewModel.searchQuery) { _ in
                    Task {
                        if networkMonitor.isConnected {
                            await homeScreenViewModel.getDataTaskFireStore(filter: 0,searchName: homeScreenViewModel.searchQuery)
                        }else{
                            await homeScreenViewModel.getDataTask(filter: 0,searchName: homeScreenViewModel.searchQuery, context: viewContext)
                        }
                    }
                }
            Button(action: performSearch) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.bgsawitprocolor)
                    .cornerRadius(8)
            }
        }
        .padding(4) // Padding di sekitar komponen
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.bgsawitprocolor, lineWidth: 2)
        )
        .background(Color.white) // Latar belakang dalam border
        .cornerRadius(10)
        .padding(.vertical,12)
        .padding(.horizontal,12)
    }
    
    private func performSearch() {
        print("Searching for: \(searchText)")
    }
    
}


#Preview {
    HomeScreenView()
}
