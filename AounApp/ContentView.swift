import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var taskFiles: [TaskFile] // مصفوفة لتخزين المهام من SwiftData

    @State private var swipedTaskID: PersistentIdentifier? = nil // لتحديد العنصر الحالي الذي يتم سحبه

    var body: some View {
        TabView {
            // الصفحة الرئيسية: المهام
            NavigationView {
                ZStack {
                    Color(.systemGray6)
                        .edgesIgnoringSafeArea(.all)

                    if taskFiles.isEmpty {
                        EmptyStateView()
                    } else {
                        TaskListView(taskFiles: taskFiles, swipedTaskID: $swipedTaskID)
                    }
                }
                .navigationTitle("المهام")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(trailing:
                    NavigationLink(destination: AddTaskView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.purple)
                    }
                )
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("المهام")
            }

            // الصفحة الثانية: التذكيرات
            NavigationView {
                ZStack {
                    Color(.systemGray6)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Spacer()
                        Text("لا يوجد أي تذكيرات جديدة")
                            .foregroundColor(.gray)
                            .font(.title3)

                        Image(systemName: "alarm")
                            .font(.system(size: 80))
                            .foregroundColor(.purple.opacity(0.6))
                        Spacer()
                    }
                }
                .navigationTitle("التذكيرات")
                .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: "alarm")
                Text("التذكيرات")
            }
        }
        .accentColor(.purple)
    }
}

// عرض الحالة الفارغة
struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("لا يوجد أي مهام جديدة")
                .foregroundColor(.gray)
                .font(.title3)
                .padding()

            Image(systemName: "list.bullet.rectangle.portrait")
                .font(.system(size: 80))
                .foregroundColor(.purple.opacity(0.6))
            Spacer()
        }
    }
}

// عرض قائمة المهام
struct TaskListView: View {
    var taskFiles: [TaskFile]
    @Binding var swipedTaskID: PersistentIdentifier?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(taskFiles) { taskFile in
                    TaskRowView(taskFile: taskFile, swipedTaskID: $swipedTaskID)
                }
            }
            .padding()
        }
    }
}

// عرض كل عنصر من قائمة المهام
struct TaskRowView: View {
    var taskFile: TaskFile
    @Binding var swipedTaskID: PersistentIdentifier?

    var body: some View {
        NavigationLink(destination: TaskDetailView(taskFile: taskFile)) {  // تغيير الوجهة لعرض التفاصيل
            ZStack {
                // الأزرار الجانبية
                HStack {
                    Button(action: {
                        print("\(taskFile.title) تمت إعادة التنفيذ")
                    }) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green)
                            .frame(width: 80, height: 60)
                            .overlay(
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(.white)
                            )
                    }
                    Spacer()
                    Button(action: {
                        deleteTask()
                    }) {
                        VStack {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Spacer().frame(height: 2)
                            Text("حذف")
                                .font(.system(size: 18))
                                .bold()
                        }
                        .foregroundColor(.white)
                        .background(Rectangle()
                            .foregroundStyle(Color.red)
                            .frame(width: 70, height: 70)
                            .cornerRadius(9))
                    }
                }
                .padding(.horizontal)

                // العنصر الأساسي (التفاصيل)
                HStack {
                    Spacer().frame(width: 230)
                    Text(taskFile.title)
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                    Image(systemName: taskFile.iconName)  // استخدام الأيقونة المختارة
                        .font(.system(size: 40))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.purple)
                }
                .background(Rectangle()
                    .foregroundStyle(Color.white)
                    .frame(width: 370, height: 70)
                    .cornerRadius(9))
                .offset(x: swipedTaskID == taskFile.id ? -75 : 0)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < -50 {
                                swipedTaskID = taskFile.id
                            } else if value.translation.width > 50 {
                                swipedTaskID = nil
                            }
                        }
                )
                .animation(.spring(), value: swipedTaskID)
            }
        }
    }

    private func deleteTask() {
        // حذف المهمة
    }
}

#Preview {
    ContentView()
}
