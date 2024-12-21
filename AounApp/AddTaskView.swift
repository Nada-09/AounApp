import SwiftUI
import Speech
import AVFoundation
import SwiftData

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext // الوصول إلى قاعدة البيانات

    @State private var taskTitle: String = ""
    @State private var selectedIcon: String = "list.bullet"
    @State private var tasks: [(title: String, isCompleted: Bool)] = []
    @State private var showMenu = false
    @State private var isRecording = false

    private let speechRecognizer = SpeechRecognizer()

    let icons = ["cart", "airplane", "sun.max", "moon", "pencil", "figure.walk", "pill"]

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        TextField("عنوان المهمة", text: $taskTitle)
                            .font(.title2)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 8)
                            .overlay(Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color.gray.opacity(0.5)), alignment: .bottom)

                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: selectedIcon)
                                .font(.title2)
                                .foregroundColor(.purple)
                                .padding(10)
                                .background(Color.purple.opacity(0.2))
                                .clipShape(Circle())
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    HStack {
                        Spacer()
                        Button(action: toggleRecording) {
                            Image(systemName: isRecording ? "stop.circle.fill" : "mic.fill.badge.plus")
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                                .padding(20)
                                .background(Color.purple.opacity(0.2))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.trailing, 16)

                    VStack(alignment: .leading) {
                        // عرض المهام غير المكتملة أولاً
                        ForEach(tasks.filter { !$0.isCompleted }, id: \.self.title) { task in
                            HStack {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title)
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                                    .onTapGesture {
                                        toggleCompletion(for: task)
                                    }
                                Text(task.title)
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                            .transition(.move(edge: .bottom)) // حركة نزول المهام المكتملة
                            .animation(.spring(), value: task.isCompleted)
                        }
                        
                        // عرض المهام المكتملة
                        ForEach(tasks.filter { $0.isCompleted }, id: \.self.title) { task in
                            HStack {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title)
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                                    .onTapGesture {
                                        toggleCompletion(for: task)
                                    }
                                Text(task.title)
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                            .transition(.move(edge: .bottom)) // حركة نزول المهام المكتملة
                            .animation(.spring(), value: task.isCompleted)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                
                if showMenu {
                    VStack {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showMenu = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            Text("اختر أيقونة")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Divider()

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                            ForEach(icons, id: \.self) { icon in
                                Button(action: {
                                    selectedIcon = icon
                                    withAnimation {
                                        showMenu = false
                                    }
                                }) {
                                    Image(systemName: icon)
                                        .font(.title2)
                                        .foregroundColor(.purple)
                                        .padding()
                                        .background(Color.purple.opacity(0.1))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        Divider()
                    }
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("تم") {
                    saveTask()
                    dismiss()
                }
                .foregroundColor(.purple)
                .font(.headline)
            )
            .background(Color(UIColor.systemGray6))
        }
    }

    private func saveTask() {
        let newTaskFile = TaskFile(title: taskTitle.isEmpty ? "مهمة جديدة" : taskTitle, tasks: tasks.map { $0.title })
        modelContext.insert(newTaskFile) // إضافة المهمة إلى قاعدة البيانات
    }

    private func toggleRecording() {
        if isRecording {
            speechRecognizer.stopRecording { result in
                if !result.isEmpty {
                    tasks.append((title: result, isCompleted: false))
                }
            }
        } else {
            speechRecognizer.startRecording()
        }
        isRecording.toggle()
    }

    private func toggleCompletion(for task: (title: String, isCompleted: Bool)) {
        if let index = tasks.firstIndex(where: { $0.title == task.title }) {
            tasks[index].isCompleted.toggle()

            // إعادة ترتيب المهام بحيث تكون المهام المكتملة في الأسفل
            tasks.sort { $0.isCompleted && !$1.isCompleted }
        }
    }
}

#Preview {
    AddTaskView()
}
