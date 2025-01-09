//
//  DetailTaskView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 04/01/25.
//

import SwiftUI

struct TimelineItem: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool = false
}


struct TaskDetailView: View {
    @StateObject private var taskDetailViewModel = TaskDetailViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var networkMonitor: NetworkMonitor

    @Binding var idTask: UUID
    @Binding var idFireStore: String
    @Environment(\.presentationMode) var presentationMode
    @State private var isSheetPresented = false
    @State private var isSheetPresentedDelete = false
    @State private var isBottomSheetPresentedDelete = false
    @State private var isBottomSheetPresented = false
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    ToolBarComponentView(title:"Task Detail",action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    
                    CardTaskView(id: $idTask, idFirestore: $idFireStore, isSheetPresented: $isSheetPresented, taskItem: $taskDetailViewModel.itemTaskEntity, iSDetail: .constant(true),  isSheetPresentedDelete: $isSheetPresentedDelete)
                    ScrollView{
                        TimlineView(taskItem: $taskDetailViewModel.historyTaskDetail,taskItemDeteail: $taskDetailViewModel.itemTaskEntity)
                    }
                }.frame(maxHeight: .infinity,alignment: .top)
                if taskDetailViewModel.isLoading{
                    LoadingPopupView(message: $taskDetailViewModel.successMessage)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
                Task {
                    if networkMonitor.isConnected {
                        await taskDetailViewModel.getDataTaskDetailFireStore(id: idTask)
                        await taskDetailViewModel.getDataTaskHistoryFireStore(id: idTask)
                    }else{
                        await taskDetailViewModel.getDataTaskDetail(idTask, context: viewContext)
                        await taskDetailViewModel.getDataTaskDetailHstory(idTask, context: viewContext)
                    }
                }
                
            }
        .sheet(isPresented: $isSheetPresented) {
            BottomSheetView(isPresented: $isSheetPresented) {
                
                BootomSheetChoice(isPresented : $isBottomSheetPresented,filterItem: taskDetailViewModel.filters, id: $idTask, action: {title,status in
                    Task {
                        async let updateTaskEntity: () = taskDetailViewModel.updateTask(idTask, status, context: viewContext)
                        async let updateTaskEntityFireStore: () =  taskDetailViewModel.updateTaskFireStore(idTask: idTask, idFireStore: idFireStore, status: Int(status))
                       
                        // Waiing task finish
                        await updateTaskEntity
                        await updateTaskEntityFireStore
                        
                        if networkMonitor.isConnected {
                            await taskDetailViewModel.getDataTaskDetailFireStore(id: idTask)
                            await taskDetailViewModel.getDataTaskHistoryFireStore(id: idTask)
                        }else{
                            await taskDetailViewModel.getDataTaskDetail(idTask, context: viewContext)
                            await taskDetailViewModel.getDataTaskDetailHstory(idTask, context: viewContext)
                        }
                        
                    }
                    isSheetPresented = false
                    
                })
                
               
            }
           

        }
        .sheet(isPresented: $isSheetPresentedDelete) {
            BottomSheetView(isPresented: $isSheetPresentedDelete) {
                BootomSheetConfirmationDelete(id:$idTask,fireStoreId: $idFireStore) { id,fireStoreId in
                    Task{
                        async let deleteTaskEntity: () = taskDetailViewModel.deleteTaskEntity(taskId: UUID(uuidString: id) ?? UUID(), context: viewContext)
                        async let deleteTaskHistoryEntity: () = taskDetailViewModel.deleteTaskHistoryEntity(taskId: UUID(uuidString: id) ?? UUID(), context: viewContext)
                        async let deleteTaskEntityFireStore: () = taskDetailViewModel.deleteTaskEntityFireStore(documentID: fireStoreId)
                        async let deleteHistoryTaskEntityFireStore: () = taskDetailViewModel.deleteHistoryTaskEntityFireStore(taskId: id)

                        // Waiing task finish
                        await deleteTaskEntity
                        await deleteTaskHistoryEntity
                        await deleteTaskEntityFireStore
                        await deleteHistoryTaskEntityFireStore

                        
                        if networkMonitor.isConnected {
                            await taskDetailViewModel.getDataTaskDetailFireStore(id: idTask)
                            await taskDetailViewModel.getDataTaskHistoryFireStore(id: idTask)
                        }else{
                            await taskDetailViewModel.getDataTaskDetail(idTask, context: viewContext)
                            await taskDetailViewModel.getDataTaskDetailHstory(idTask, context: viewContext)
                        }
                    }
                    isSheetPresentedDelete = false
                } actionCancel: {
                    isSheetPresentedDelete = false
                }
            }
        }
            
    }
}

struct TimlineView: View {
    @Binding var taskItem : [TaskHistoryModelResponse]
    @Binding var taskItemDeteail : [TaskModelResponse]
    var body: some View {
            VStack(spacing:0) {
                ForEach(taskItem){ item in
                    HStack(alignment: .top,spacing: 12){
                        VStack(alignment: .center, spacing: 0){
                            Circle()
                                .stroke(Color.bgsawitprocolor, lineWidth: 2)
                                .frame(width: 20, height: 20)
                            Rectangle()
                                .frame(width: 2,height: 30)
                                .foregroundColor(Color.bgsawitprocolor) // Menentukan warna garis
                            
                        }
                        VStack(alignment: .leading,spacing: 2){
                            Text("Update \(statusTask(item.status))").font(.caption.bold())
                                .padding(.top,4)
                            Text("\(item.updateAt)").font(.caption)
                              
                        }
                        Spacer()
                    }
                }
                ForEach(taskItemDeteail ){ itemDetail in
                    Text("Create Task \n\(String(describing: itemDetail.createAt))").font(.caption.bold())
                        .padding(.top,4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding([.horizontal, .bottom],12)
        
    }
    
    func statusTask(_ code: Int16) -> String {
        var status = "Todo" // Default status
        switch code {
        case 1:
            status = "In Progress"
        case 2:
            status = "Hold"
        case 3:
            status = "Qa Ready"
        case 4:
            status = "Completed"
        default:
            status = "Todo" // Handle kode yang tidak dikenal
        }

        return status
    }
}
#Preview {
    TaskDetailView(idTask: .constant(UUID()), idFireStore: .constant(""))
}
