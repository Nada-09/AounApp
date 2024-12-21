import SwiftUI
import SwiftData

struct TaskDetailView: View {
    var taskFile: TaskFile  // استلام مهمة من القائمة لعرض تفاصيلها

    var body: some View {
        VStack {
            Text("تفاصيل المهمة")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // عرض العنوان
            Text("العنوان: \(taskFile.title)")
                .font(.title2)
                .padding()

            // عرض المهام الموجودة في هذا الملف
            Text("المهام:")
                .font(.title3)
                .padding()

            // عرض كل مهمة من المهام المضافة
            ForEach(taskFile.tasks, id: \.self) { task in
                Text(task)
                    .font(.body)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .navigationTitle(taskFile.title)  // تعيين العنوان في الشريط العلوي
        .padding()
    }
}

#Preview {
    TaskDetailView(taskFile: TaskFile(title: "مهمة جديدة", tasks: ["مهمة 1", "مهمة 2"]))
}
